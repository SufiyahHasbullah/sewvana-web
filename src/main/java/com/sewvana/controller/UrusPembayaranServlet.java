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

@WebServlet("/admin/urus-pembayaran")
public class UrusPembayaranServlet extends HttpServlet {
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

        List<Map<String, String>> senaraiPembayaran = new ArrayList<>();

        String sql = "SELECT p.id, ts.kod_tempahan, c.nama AS nama_pelanggan, w.nama AS nama_penjahit, " +
                "p.kod_resit, p.jenis_bayaran, p.jumlah_bayaran, p.kaedah_bayaran, p.status_bayaran, p.tarikh_bayaran " +
                "FROM pembayaran p " +
                "JOIN tempahan_slot ts ON p.tempahan_slot_id = ts.id " +
                "JOIN pengguna c ON ts.pelanggan_id = c.id " +
                "JOIN pengguna w ON ts.penjahit_id = w.id " +
                "ORDER BY p.tarikh_bayaran DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> p = new HashMap<>();
                p.put("id", String.valueOf(rs.getInt("id")));
                p.put("kod_tempahan", rs.getString("kod_tempahan"));
                p.put("pelanggan", rs.getString("nama_pelanggan"));
                p.put("penjahit", rs.getString("nama_penjahit"));
                p.put("kod_resit", rs.getString("kod_resit"));
                
                String jenis = rs.getString("jenis_bayaran");
                if ("BAYARAN_PENH".equalsIgnoreCase(jenis)) jenis = "BAYARAN PENUH";
                p.put("jenis_bayaran", jenis);
                
                p.put("jumlah_bayaran", String.format("%.2f", rs.getDouble("jumlah_bayaran")));
                p.put("kaedah_bayaran", rs.getString("kaedah_bayaran"));
                p.put("status_bayaran", rs.getString("status_bayaran"));
                
                if (rs.getTimestamp("tarikh_bayaran") != null) {
                    p.put("tarikh_bayaran", rs.getTimestamp("tarikh_bayaran").toString().substring(0, 16));
                } else {
                    p.put("tarikh_bayaran", "-");
                }
                
                senaraiPembayaran.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("senaraiPembayaran", senaraiPembayaran);
        request.getRequestDispatcher("/views/pentadbir/pembayaran.jsp").forward(request, response);
    }
}
