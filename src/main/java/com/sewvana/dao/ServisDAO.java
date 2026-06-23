package com.sewvana.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.sewvana.config.DatabaseConfig; // Pastikan mengikut utiliti DB asal anda

public class ServisDAO {

    public List<Map<String, Object>> getServisByPenjahitId(int penjahitId) {
        List<Map<String, Object>> senarai = new ArrayList<>();
        String sql = "SELECT id, nama_servis, harga_upah, KETERANGAN FROM perkhidmatan_penjahit WHERE penjahit_id = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, penjahitId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("nama_servis", rs.getString("nama_servis"));
                    map.put("harga_upah", rs.getDouble("harga_upah"));
                    map.put("KETERANGAN", rs.getString("KETERANGAN"));
                    senarai.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return senarai;
    }
    public boolean tambahServis(int penjahitId, String namaServis, double hargaUpah, String keterangan) {
        String sql = "INSERT INTO perkhidmatan_penjahit (penjahit_id, nama_servis, harga_upah, KETERANGAN) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penjahitId);
            ps.setString(2, namaServis);
            ps.setDouble(3, hargaUpah);
            ps.setString(4, keterangan);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean kemaskiniServis(int id, int penjahitId, String namaServis, double hargaUpah, String keterangan) {
        String sql = "UPDATE perkhidmatan_penjahit SET nama_servis = ?, harga_upah = ?, KETERANGAN = ? WHERE id = ? AND penjahit_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, namaServis);
            ps.setDouble(2, hargaUpah);
            ps.setString(3, keterangan);
            ps.setInt(4, id);
            ps.setInt(5, penjahitId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean padamServis(int id, int penjahitId) {
        String sql = "DELETE FROM perkhidmatan_penjahit WHERE id = ? AND penjahit_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, penjahitId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}