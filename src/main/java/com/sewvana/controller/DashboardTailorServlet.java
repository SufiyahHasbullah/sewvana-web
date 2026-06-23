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

@WebServlet({"/dashboard-penjahit", "/penjahit/dashboard"})
public class DashboardTailorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENJAHIT".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int idPenjahit = user.getId();

        int tempahanHariIni = 0;
        int tempahanBulanIni = 0;
        double jumlahPendapatan = 0.0;
        int slotKosong = 0;

        List<Map<String, String>> senaraiTempahan = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection()) {

            // 1. Kira Tempahan Hari Ini (Berdasarkan tarikh_slot)
            String sqlHariIni = "SELECT COUNT(*) FROM tempahan_slot WHERE penjahit_id = ? AND tarikh_slot = CURDATE()";
            try (PreparedStatement ps = conn.prepareStatement(sqlHariIni)) {
                ps.setInt(1, idPenjahit);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) tempahanHariIni = rs.getInt(1);
                }
            }

            // 2. Kira Tempahan Bulan Ini (Berdasarkan tarikh_slot)
            String sqlBulanIni = "SELECT COUNT(*) FROM tempahan_slot WHERE penjahit_id = ? " +
                    "AND MONTH(tarikh_slot) = MONTH(CURDATE()) AND YEAR(tarikh_slot) = YEAR(CURDATE())";
            try (PreparedStatement ps = conn.prepareStatement(sqlBulanIni)) {
                ps.setInt(1, idPenjahit);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) tempahanBulanIni = rs.getInt(1);
                }
            }

            // 3. Jumlah Pendapatan (Diambil dari jadual pembayaran dengan status 'BERJAYA')
            String sqlPendapatan = "SELECT SUM(p.jumlah_bayaran) FROM pembayaran p " +
                    "JOIN tempahan_slot t ON p.tempahan_slot_id = t.id " +
                    "WHERE t.penjahit_id = ? AND p.status_bayaran = 'BERJAYA'";
            try (PreparedStatement ps = conn.prepareStatement(sqlPendapatan)) {
                ps.setInt(1, idPenjahit);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) jumlahPendapatan = rs.getDouble(1);
                }
            }

            // 4. Kira Baki Kuota Slot Aktif yang masih 'BUKA' bermula hari ini dan ke hadapan
            String sqlSlot = "SELECT SUM(max_tempahan) FROM kuota_slot WHERE penjahit_id = ? AND status_slot = 'BUKA' AND tarikh >= CURDATE()";
            try (PreparedStatement ps = conn.prepareStatement(sqlSlot)) {
                ps.setInt(1, idPenjahit);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) slotKosong = rs.getInt(1);
                }
            }

            // 5. Ambil 5 Tempahan Terkini untuk Paparan Jadual Utama Dashboard (Diselaraskan dengan skema anda)
            String sqlSenarai = "SELECT t.id, t.kod_tempahan, t.kategori_pakaian, t.catatan, t.tarikh_slot, t.status_tempahan, p.nama AS nama_pelanggan, COALESCE(bayar.jumlah_bayaran, 0.00) AS bayaran " +
                    "FROM tempahan_slot t " +
                    "JOIN pengguna p ON t.pelanggan_id = p.id " +
                    "LEFT JOIN pembayaran bayar ON t.id = bayar.tempahan_slot_id " +
                    "WHERE t.penjahit_id = ? ORDER BY t.tarikh_cipta DESC LIMIT 5";
            try (PreparedStatement ps = conn.prepareStatement(sqlSenarai)) {
                ps.setInt(1, idPenjahit);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> tempahan = new HashMap<>();
                        tempahan.put("id", String.valueOf(rs.getInt("id")));
                        tempahan.put("kod_tempahan", rs.getString("kod_tempahan")); 
                        tempahan.put("pelanggan", rs.getString("nama_pelanggan"));
                        tempahan.put("pakaian", rs.getString("kategori_pakaian")); 
                        tempahan.put("catatan", rs.getString("catatan"));
                        tempahan.put("tarikh_tempah", rs.getDate("tarikh_slot").toString());
                        tempahan.put("status", rs.getString("status_tempahan")); 
                        tempahan.put("bayaran", String.format("%.2f", rs.getDouble("bayaran")));
                        senaraiTempahan.add(tempahan);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set data ke scope request
        request.setAttribute("hariIni", tempahanHariIni);
        request.setAttribute("bulanIni", tempahanBulanIni);
        request.setAttribute("pendapatan", String.format("%.2f", jumlahPendapatan));
        request.setAttribute("slotKosong", slotKosong);
        request.setAttribute("senaraiTempahan", senaraiTempahan);

        // Forward ke paparan JSP penjahit
        request.getRequestDispatcher("/views/penjahit/dashboard_tailor.jsp").forward(request, response);
    }
}