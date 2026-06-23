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

@WebServlet("/admin/urus-tempahan")
public class UrusTempahanServlet extends HttpServlet {
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

        List<Map<String, String>> senaraiTempahan = new ArrayList<>();

        String sql = "SELECT ts.id, ts.kod_tempahan, c.nama AS nama_pelanggan, w.nama AS nama_penjahit, " +
                "ts.tarikh_slot, ts.kategori_pakaian, ts.status_tempahan, ts.catatan " +
                "FROM tempahan_slot ts " +
                "JOIN pengguna c ON ts.pelanggan_id = c.id " +
                "JOIN pengguna w ON ts.penjahit_id = w.id " +
                "ORDER BY ts.id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> t = new HashMap<>();
                t.put("id", String.valueOf(rs.getInt("id")));
                t.put("kod_tempahan", rs.getString("kod_tempahan"));
                t.put("pelanggan", rs.getString("nama_pelanggan"));
                t.put("penjahit", rs.getString("nama_penjahit"));
                t.put("tarikh_slot", rs.getDate("tarikh_slot") != null ? rs.getDate("tarikh_slot").toString() : "-");
                t.put("kategori_pakaian", rs.getString("kategori_pakaian") != null ? rs.getString("kategori_pakaian").replace("_", " ") : "-");
                t.put("status", rs.getString("status_tempahan"));
                t.put("catatan", rs.getString("catatan") != null ? rs.getString("catatan") : "-");
                senaraiTempahan.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("senaraiTempahan", senaraiTempahan);
        request.getRequestDispatcher("/views/pentadbir/tempahan.jsp").forward(request, response);
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
        if ("batal".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try (Connection conn = DatabaseConfig.getConnection();
                     PreparedStatement ps = conn.prepareStatement("UPDATE tempahan_slot SET status_tempahan = 'BATAL' WHERE id = ?")) {
                    ps.setInt(1, Integer.parseInt(idStr));
                    ps.executeUpdate();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/urus-tempahan");
    }
}
