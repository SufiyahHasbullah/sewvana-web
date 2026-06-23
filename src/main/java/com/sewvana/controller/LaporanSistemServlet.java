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

@WebServlet("/admin/laporan-sistem")
public class LaporanSistemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
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
        int totalTempahan = 0;
        double totalKutipan = 0.0;

        List<Map<String, String>> kategoriStats = new ArrayList<>();
        List<Map<String, String>> statusStats = new ArrayList<>();
        List<Map<String, String>> bulananStats = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection()) {

            // 1. Core counters
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM pengguna WHERE peranan = 'PELANGGAN'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalPelanggan = rs.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM pengguna WHERE peranan = 'PENJAHIT'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalPenjahit = rs.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM tempahan_slot");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalTempahan = rs.getInt(1);
            }

            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(jumlah_bayaran) FROM pembayaran WHERE status_bayaran = 'BERJAYA'");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalKutipan = rs.getDouble(1);
            }

            // 2. Kategori pakaian stats
            String sqlKategori = "SELECT kategori_pakaian, COUNT(*) as jumlah FROM tempahan_slot GROUP BY kategori_pakaian";
            try (PreparedStatement ps = conn.prepareStatement(sqlKategori);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    String kat = rs.getString("kategori_pakaian");
                    m.put("kategori", kat != null ? kat.replace("_", " ") : "LAIN-LAIN");
                    m.put("jumlah", String.valueOf(rs.getInt("jumlah")));
                    kategoriStats.add(m);
                }
            }

            // 3. Status tempahan stats
            String sqlStatus = "SELECT status_tempahan, COUNT(*) as jumlah FROM tempahan_slot GROUP BY status_tempahan";
            try (PreparedStatement ps = conn.prepareStatement(sqlStatus);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("status", rs.getString("status_tempahan"));
                    m.put("jumlah", String.valueOf(rs.getInt("jumlah")));
                    statusStats.add(m);
                }
            }

            // 4. Bulanan revenue
            String sqlBulanan = "SELECT MONTHNAME(tarikh_bayaran) as bulan, SUM(jumlah_bayaran) as jumlah " +
                    "FROM pembayaran WHERE status_bayaran = 'BERJAYA' GROUP BY MONTH(tarikh_bayaran)";
            try (PreparedStatement ps = conn.prepareStatement(sqlBulanan);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> m = new HashMap<>();
                    m.put("bulan", rs.getString("bulan"));
                    m.put("jumlah", String.format("%.2f", rs.getDouble("jumlah")));
                    bulananStats.add(m);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalPelanggan", totalPelanggan);
        request.setAttribute("totalPenjahit", totalPenjahit);
        request.setAttribute("totalTempahan", totalTempahan);
        request.setAttribute("totalKutipan", String.format("%.2f", totalKutipan));
        request.setAttribute("kategoriStats", kategoriStats);
        request.setAttribute("statusStats", statusStats);
        request.setAttribute("bulananStats", bulananStats);

        request.getRequestDispatcher("/views/pentadbir/analitik.jsp").forward(request, response);
    }
}
