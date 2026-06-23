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

@WebServlet("/penjahit/rekod-bayaran")
public class RekodBayaranPenjahitServlet extends HttpServlet {
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
        List<Map<String, String>> senaraiPembayaran = new ArrayList<>();
        double jumlahHasilKasar = 0.0;

        String sql = "SELECT p.id, p.kod_resit, p.jenis_bayaran, p.jumlah_bayaran, p.kaedah_bayaran, p.status_bayaran, p.tarikh_bayaran, cust.nama AS nama_pelanggan, t.kod_tempahan " +
                "FROM pembayaran p " +
                "JOIN tempahan_slot t ON p.tempahan_slot_id = t.id " +
                "JOIN pengguna cust ON t.pelanggan_id = cust.id " +
                "WHERE t.penjahit_id = ? " +
                "ORDER BY p.tarikh_bayaran DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenjahit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> bayaran = new HashMap<>();
                    bayaran.put("id", String.valueOf(rs.getInt("id")));
                    bayaran.put("kod_resit", rs.getString("kod_resit"));
                    bayaran.put("kod_tempahan", rs.getString("kod_tempahan"));
                    bayaran.put("pelanggan", rs.getString("nama_pelanggan"));
                    bayaran.put("jenis", rs.getString("jenis_bayaran"));
                    
                    double amaun = rs.getDouble("jumlah_bayaran");
                    bayaran.put("amaun", String.format("%.2f", amaun));
                    bayaran.put("kaedah", rs.getString("kaedah_bayaran"));
                    bayaran.put("status", rs.getString("status_bayaran"));
                    bayaran.put("tarikh", rs.getTimestamp("tarikh_bayaran").toString());

                    if ("BERJAYA".equals(rs.getString("status_bayaran"))) {
                        jumlahHasilKasar += amaun;
                    }
                    senaraiPembayaran.add(bayaran);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("senaraiPembayaran", senaraiPembayaran);
        request.setAttribute("hasilKasar", String.format("%.2f", jumlahHasilKasar));
        request.getRequestDispatcher("/views/penjahit/rekod_bayaran.jsp").forward(request, response);
    }
}
