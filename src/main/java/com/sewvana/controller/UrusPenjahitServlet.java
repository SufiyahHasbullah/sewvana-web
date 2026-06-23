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

@WebServlet("/admin/urus-penjahit")
public class UrusPenjahitServlet extends HttpServlet {
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

        List<Map<String, String>> senaraiPenjahit = new ArrayList<>();

        // Query details and count how many services (perkhidmatan) and slots each tailor has
        String sql = "SELECT p.id, p.nama, p.email, p.no_telefon, " +
                "(SELECT COUNT(*) FROM perkhidmatan_penjahit WHERE penjahit_id = p.id) AS total_servis, " +
                "(SELECT COUNT(*) FROM tempahan_slot WHERE penjahit_id = p.id) AS total_tempahan " +
                "FROM pengguna p WHERE p.peranan = 'PENJAHIT' ORDER BY p.id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("id", String.valueOf(rs.getInt("id")));
                p.put("nama", rs.getString("nama"));
                p.put("email", rs.getString("email"));
                p.put("telefon", rs.getString("no_telefon") != null ? rs.getString("no_telefon") : "-");
                p.put("total_servis", String.valueOf(rs.getInt("total_servis")));
                p.put("total_tempahan", String.valueOf(rs.getInt("total_tempahan")));
                senaraiPenjahit.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("senaraiPenjahit", senaraiPenjahit);
        request.getRequestDispatcher("/views/pentadbir/penjahit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String action = request.getParameter("action");
        if ("padam".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DatabaseConfig.getConnection();
                     PreparedStatement ps = conn.prepareStatement("DELETE FROM pengguna WHERE id = ?")) {
                    ps.setInt(1, Integer.parseInt(idStr));
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/urus-penjahit");
    }
}
