package com.sewvana.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Pengguna;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard-pelanggan")
public class DashboardCustServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Sekatan Keselamatan Pengguna
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        int idPelanggan = user.getId();

        int tempahanAktif = 0;
        int jumlahNotifikasi = 0;
        List<Map<String, String>> tempahanTerkini = new ArrayList<>();
        List<Map<String, String>> penjahitPopular = new ArrayList<>();

        // --- TETAPAN PAGINATION (5 DATA SEHALAMAN) ---
        int saizHalaman = 5;
        int halamanSemasa = 1;

        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                halamanSemasa = Integer.parseInt(pageParam);
                if (halamanSemasa < 1) halamanSemasa = 1;
            } catch (NumberFormatException e) {
                halamanSemasa = 1;
            }
        }

        try (Connection conn = DatabaseConfig.getConnection()) {

            // A. Kira Tempahan Aktif
            String sqlAktif = "SELECT COUNT(*) FROM tempahan_slot WHERE pelanggan_id = ? AND status_tempahan IN ('MENUNGGU_PENGESAHAN', 'AKTIF', 'SESI_UKURAN')";
            try (PreparedStatement ps = conn.prepareStatement(sqlAktif)) {
                ps.setInt(1, idPelanggan);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) tempahanAktif = rs.getInt(1);
                }
            }

            // B. Kira Notifikasi Belum Dibaca
            String sqlNotif = "SELECT COUNT(*) FROM notifikasi WHERE id_pengguna = ? AND status = 'Belum Dibaca'";
            try (PreparedStatement ps = conn.prepareStatement(sqlNotif)) {
                ps.setInt(1, idPelanggan);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) jumlahNotifikasi = rs.getInt(1);
                }
            } catch (Exception e) {
                jumlahNotifikasi = 0;
            }

            // C. KIRA JUMLAH REKOD KESELURUHAN UNTUK PAGINATION
            int jumlahRekod = 0;
            String sqlKiraTotal = "SELECT COUNT(*) FROM tempahan_slot WHERE pelanggan_id = ?";
            try (PreparedStatement psKira = conn.prepareStatement(sqlKiraTotal)) {
                psKira.setInt(1, idPelanggan);
                try (ResultSet rsKira = psKira.executeQuery()) {
                    if (rsKira.next()) {
                        jumlahRekod = rsKira.getInt(1);
                    }
                }
            }

            // Hitung total halaman maksima
            int jumlahHalaman = (int) Math.ceil((double) jumlahRekod / saizHalaman);
            if (jumlahHalaman == 0) jumlahHalaman = 1;
            if (halamanSemasa > jumlahHalaman) halamanSemasa = jumlahHalaman;

            // Formula offset pembahagi SQL
            int offset = (halamanSemasa - 1) * saizHalaman;

            // D. AMBIL DATA DENGAN HAD LIMIT 5 (GUNA STRUKTUR ASAL REKOD AWAK)
            String sqlSenarai = "SELECT t.id, t.kategori_pakaian, t.tarikh_slot, t.status_tempahan, p.nama AS nama_penjahit " +
                    "FROM tempahan_slot t " +
                    "JOIN pengguna p ON t.penjahit_id = p.id " +
                    "WHERE t.pelanggan_id = ? " +
                    "ORDER BY t.id DESC LIMIT ? OFFSET ?"; // Mengekalkan order by t.id supaya selamat

            try (PreparedStatement ps = conn.prepareStatement(sqlSenarai)) {
                ps.setInt(1, idPelanggan);
                ps.setInt(2, saizHalaman);
                ps.setInt(3, offset);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> t = new HashMap<>();
                        t.put("id", String.valueOf(rs.getInt("id")));
                        t.put("penjahit", rs.getString("nama_penjahit"));

                        String pakaianRaw = rs.getString("kategori_pakaian");
                        t.put("pakaian", pakaianRaw != null ? pakaianRaw.replace("_", " ") : "-");

                        t.put("tarikh_siap", rs.getDate("tarikh_slot") != null ? rs.getDate("tarikh_slot").toString() : "-");
                        t.put("status", rs.getString("status_tempahan"));
                        t.put("bayaran", "135.00");

                        tempahanTerkini.add(t);
                    }
                }
            }

            // E. Senarai Cadangan Penjahit Pilihan
            String sqlPenjahit = "SELECT id, nama, telefon FROM pengguna WHERE peranan = 'Penjahit' LIMIT 3";
            try (PreparedStatement ps = conn.prepareStatement(sqlPenjahit);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> p = new HashMap<>();
                    p.put("id", String.valueOf(rs.getInt("id")));
                    p.put("nama", rs.getString("nama"));
                    p.put("telefon", rs.getString("telefon"));
                    penjahitPopular.add(p);
                }
            } catch (Exception e) {
                // Bypass jika error
            }

            // Hantar data pagination ke JSP
            request.setAttribute("halamanSemasa", halamanSemasa);
            request.setAttribute("jumlahHalaman", jumlahHalaman);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("tempahanAktif", tempahanAktif);
        request.setAttribute("jumlahNotifikasi", jumlahNotifikasi);
        request.setAttribute("tempahanTerkini", tempahanTerkini);
        request.setAttribute("penjahitPopular", penjahitPopular);

        // KEMBALI KEPADA LALUAN ASAL PROJEK AWAK YANG 404 TADI
        request.getRequestDispatcher("/views/pelanggan/dashboard_cust.jsp").forward(request, response);
    }
}