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

@WebServlet("/penjahit/slot")
public class SlotPenjahitServlet extends HttpServlet {

    // Papar borang urus slot
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        Pengguna penjahit = (Pengguna) session.getAttribute("pengguna");
        java.util.List<java.util.Map<String, Object>> listSlot = new java.util.ArrayList<>();
        
        String sql = "SELECT tarikh, max_tempahan, status_slot FROM kuota_slot WHERE penjahit_id = ? ORDER BY tarikh ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penjahit.getId());
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("tarikh", rs.getDate("tarikh").toString());
                    map.put("max_tempahan", rs.getInt("max_tempahan"));
                    map.put("status_slot", rs.getString("status_slot"));
                    listSlot.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String jsonSlots = "[]";
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            jsonSlots = mapper.writeValueAsString(listSlot);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("jsonSlots", jsonSlots);
        request.setAttribute("senaraiSlot", listSlot);
        request.getRequestDispatcher("/views/penjahit/urus_slot.jsp").forward(request, response);
    }

    // Terima data simpan kuota baru dari penjahit
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna penjahit = (Pengguna) session.getAttribute("pengguna");

        String tarikh = request.getParameter("tarikhSlot");
        int kuotaMax = Integer.parseInt(request.getParameter("maxTempahan"));
        String status = request.getParameter("statusSlot");
        boolean repeat = request.getParameter("ulangiMingguan") != null && "true".equalsIgnoreCase(request.getParameter("ulangiMingguan"));

        String sql = "INSERT INTO kuota_slot (penjahit_id, tarikh, max_tempahan, status_slot) " +
                "VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE max_tempahan = ?, status_slot = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (repeat) {
                java.time.LocalDate startDate = java.time.LocalDate.parse(tarikh);
                for (int i = 0; i < 8; i++) {
                    java.time.LocalDate currentDate = startDate.plusWeeks(i);
                    ps.setInt(1, penjahit.getId());
                    ps.setString(2, currentDate.toString());
                    ps.setInt(3, kuotaMax);
                    ps.setString(4, status);
                    ps.setInt(5, kuotaMax);
                    ps.setString(6, status);
                    ps.addBatch();
                }
                ps.executeBatch();
                session.setAttribute("mesejSukses", "Jadual slot berulang mingguan berjaya disimpan!");
            } else {
                ps.setInt(1, penjahit.getId());
                ps.setString(2, tarikh);
                ps.setInt(3, kuotaMax);
                ps.setString(4, status);
                ps.setInt(5, kuotaMax);
                ps.setString(6, status);
                ps.executeUpdate();
                session.setAttribute("mesejSukses", "Kuota jadual tarikh " + tarikh + " berjaya disimpan!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mesejRalat", "Gagal mengemaskini kuota slot masa.");
        }

        response.sendRedirect(request.getContextPath() + "/penjahit/slot");
    }
}