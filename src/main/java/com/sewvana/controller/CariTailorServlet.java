package com.sewvana.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.sewvana.config.DatabaseConfig;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/pelanggan/cari", "/pelanggan/cari-penjahit"})
public class CariTailorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String carianNama = request.getParameter("carian");
        String tapisKategori = request.getParameter("kategori");

        List<Map<String, String>> senaraiPenjahit = new ArrayList<>();

        // QUERY YANG BETUL: Kita senaraikan semua penjahit, dan jika ada ulasan kita hitung rating purata
        StringBuilder sql = new StringBuilder(
                "SELECT p.id, p.nama, p.foto_profil, p.no_telefon, " +
                        "       COALESCE(AVG(u.bintang), 0.0) AS rating_purata, " +
                        "       COUNT(DISTINCT u.id) AS jumlah_rating " +
                        "FROM pengguna p " +
                        "LEFT JOIN ulasan u ON p.id = u.penjahit_id " +
                        "WHERE p.peranan = 'PENJAHIT' "
        );

        List<Object> params = new ArrayList<>();

        if (carianNama != null && !carianNama.trim().isEmpty()) {
            sql.append("AND p.nama LIKE ? ");
            params.add("%" + carianNama.trim() + "%");
        }

        // Tapisan kategori sekarang disemak berdasarkan ketersediaan slot penjahit
        if (tapisKategori != null && !tapisKategori.trim().isEmpty()) {
            // Memastikan penjahit mempunyai sekurang-kurangnya satu slot buka pada masa depan
            sql.append("AND p.id IN (SELECT DISTINCT penjahit_id FROM kuota_slot WHERE status_slot = 'BUKA' AND tarikh >= CURDATE() AND max_tempahan > 0) ");
        }

        sql.append("GROUP BY p.id, p.nama, p.foto_profil, p.no_telefon ");
        sql.append("ORDER BY rating_purata DESC");

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> tailor = new HashMap<>();
                    tailor.put("id", String.valueOf(rs.getInt("id")));
                    tailor.put("nama", rs.getString("nama"));
                    tailor.put("gambar", rs.getString("foto_profil"));
                    tailor.put("no_tel", rs.getString("no_telefon") != null ? rs.getString("no_telefon") : "Tiada");
                    tailor.put("rating", String.format("%.1f", rs.getDouble("rating_purata")));
                    tailor.put("jumlah_rating", String.valueOf(rs.getInt("jumlah_rating")));

                    senaraiPenjahit.add(tailor);
                }
            }
        } catch (Exception e) {
            getServletContext().log("Ralat CariTailorServlet: ", e);
        }

        request.setAttribute("senaraiPenjahit", senaraiPenjahit);
        request.setAttribute("carianLama", carianNama);
        request.setAttribute("kategoriLama", tapisKategori);

        request.getRequestDispatcher("/views/pelanggan/cari_tailor.jsp").forward(request, response);
    }
}