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

@WebServlet("/penjahit/pesanan")
public class PesananPenjahitServlet extends HttpServlet {
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
        if (!"PENJAHIT".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        int idPenjahit = user.getId();
        List<Map<String, String>> senaraiTempahan = new ArrayList<>();

        String sqlSenarai = "SELECT t.id, t.kod_tempahan, t.kategori_pakaian, t.catatan, t.tarikh_slot, t.status_tempahan, p.nama AS nama_pelanggan, COALESCE(bayar.jumlah_bayaran, 0.00) AS bayaran " +
                "FROM tempahan_slot t " +
                "JOIN pengguna p ON t.pelanggan_id = p.id " +
                "LEFT JOIN pembayaran bayar ON t.id = bayar.tempahan_slot_id " +
                "WHERE t.penjahit_id = ? " +
                "ORDER BY " +
                "  CASE t.status_tempahan " +
                "    WHEN 'MENUNGGU_PENGESAHAN' THEN 1 " +
                "    WHEN 'DISAHKAN' THEN 2 " +
                "    WHEN 'SEDANG_DIJAHIT' THEN 3 " +
                "    WHEN 'SIAP' THEN 4 " +
                "    WHEN 'DIAMBIL' THEN 5 " +
                "    WHEN 'BATAL' THEN 6 " +
                "    ELSE 7 " +
                "  END ASC, " +
                "  t.tarikh_slot ASC, t.tarikh_cipta DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlSenarai)) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("senaraiTempahan", senaraiTempahan);
        request.getRequestDispatcher("/views/penjahit/pesanan_masuk.jsp").forward(request, response);
    }
}
