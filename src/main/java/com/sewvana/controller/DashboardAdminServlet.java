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

@WebServlet({"/admin/dashboard", "/pentadbir/dashboard"})
public class DashboardAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Pintu Keselamatan Makro: Pastikan pengguna adalah PENTADBIR
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENTADBIR".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int totalPelanggan = 0;
        int totalPenjahit = 0;
        double totalKutipanPlatform = 0.0;
        int totalTempahanAktif = 0;

        List<Map<String, String>> logPembayaranTerkini = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection()) {

            // 1. Kira Bilangan Pelanggan
            String sqlPelanggan = "SELECT COUNT(*) FROM pengguna WHERE peranan = 'PELANGGAN'";
            try (PreparedStatement ps = conn.prepareStatement(sqlPelanggan);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalPelanggan = rs.getInt(1);
            }

            // 2. Kira Bilangan Penjahit
            String sqlPenjahit = "SELECT COUNT(*) FROM pengguna WHERE peranan = 'PENJAHIT'";
            try (PreparedStatement ps = conn.prepareStatement(sqlPenjahit);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalPenjahit = rs.getInt(1);
            }

            // 3. Kira Jumlah Keseluruhan Tempahan Aktif di dalam Sistem Sewvana
            String sqlTempahan = "SELECT COUNT(*) FROM tempahan_slot WHERE status_tempahan IN ('MENUNGGU_PENGESAHAN', 'DISAHKAN', 'SEDANG_DIJAHIT')";
            try (PreparedStatement ps = conn.prepareStatement(sqlTempahan);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalTempahanAktif = rs.getInt(1);
            }

            // 4. Hitung Jumlah Keseluruhan Dana Kewangan yang Mengalir di dalam Platform
            String sqlKutipan = "SELECT SUM(jumlah_bayaran) FROM pembayaran WHERE status_bayaran = 'BERJAYA'";
            try (PreparedStatement ps = conn.prepareStatement(sqlKutipan);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalKutipanPlatform = rs.getDouble(1);
            }

            // 5. Log 5 Transaksi Pembayaran Sistem Terkini untuk Pengawasan Admin
            String sqlLog = "SELECT p.id, c.nama AS nama_pelanggan, w.nama AS nama_penjahit, p.jumlah_bayaran, p.jenis_bayaran, p.tarikh_bayaran " +
                    "FROM pembayaran p " +
                    "JOIN tempahan_slot ts ON p.tempahan_slot_id = ts.id " +
                    "JOIN pengguna c ON ts.pelanggan_id = c.id " +
                    "JOIN pengguna w ON ts.penjahit_id = w.id " +
                    "ORDER BY p.tarikh_bayaran DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(sqlLog);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> log = new HashMap<>();
                    log.put("id", String.valueOf(rs.getInt("id")));
                    log.put("pelanggan", rs.getString("nama_pelanggan"));
                    log.put("penjahit", rs.getString("nama_penjahit"));
                    log.put("amaun", String.format("%.2f", rs.getDouble("jumlah_bayaran")));
                    
                    String dbJenis = rs.getString("jenis_bayaran");
                    String mappedStatus = "DEPOSIT_DIBAYAR";
                    if ("BAYARAN_PENH".equalsIgnoreCase(dbJenis) || "BAYARAN_PENUH".equalsIgnoreCase(dbJenis)) {
                        mappedStatus = "LUNAS";
                    }
                    log.put("status", mappedStatus);
                    
                    if (rs.getTimestamp("tarikh_bayaran") != null) {
                        log.put("tarikh", rs.getTimestamp("tarikh_bayaran").toString().substring(0, 16));
                    } else {
                        log.put("tarikh", "-");
                    }
                    logPembayaranTerkini.add(log);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set Atribut ke Request Scope
        request.setAttribute("totalPelanggan", totalPelanggan);
        request.setAttribute("totalPenjahit", totalPenjahit);
        request.setAttribute("totalTempahanAktif", totalTempahanAktif);
        request.setAttribute("totalKutipan", String.format("%.2f", totalKutipanPlatform));
        request.setAttribute("logPembayaran", logPembayaranTerkini);

        // Hantar data ke JSP Pentadbir
        request.getRequestDispatcher("/views/pentadbir/dashboard_admin.jsp").forward(request, response);
    }
}
