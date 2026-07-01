package com.sewvana.dao;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Tempahan;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TempahanDAO {

    public List<Tempahan> dapatkanSemaraiTempahanPenjahit(int penjahitId) {
        List<Tempahan> senarai = new ArrayList<>();
        String sql = "SELECT t.id, t.kod_tempahan, p.nama AS nama_pelanggan, t.tarikh_slot, " +
                "t.kategori_pakaian, t.catatan, t.status_tempahan " +
                "FROM tempahan_slot t " +
                "JOIN pengguna p ON t.pelanggan_id = p.id " +
                "WHERE t.penjahit_id = ? " +
                "ORDER BY t.tarikh_slot ASC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, penjahitId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tempahan t = new Tempahan();
                    t.setId(rs.getInt("id"));
                    t.setKodTempahan(rs.getString("kod_tempahan"));
                    t.setNamaPelanggan(rs.getString("nama_pelanggan"));
                    t.setTarikhSlot(rs.getDate("tarikh_slot"));
                    t.setKategoriPakaian(rs.getString("kategori_pakaian"));
                    t.setCatatan(rs.getString("catatan"));
                    t.setStatusTempahan(rs.getString("status_tempahan"));
                    senarai.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return senarai;
    }

    public List<Tempahan> dapatkanSemaraiTempahanPelanggan(int pelangganId) {
        List<Tempahan> senarai = new ArrayList<>();
        String sql = "SELECT t.id, t.kod_tempahan, p.nama AS nama_penjahit, t.tarikh_slot, " +
                "t.kategori_pakaian, t.catatan, t.status_tempahan, t.kaedah_ukuran, t.masa_sesi_ukur " +
                "FROM tempahan_slot t " +
                "JOIN pengguna p ON t.penjahit_id = p.id " +
                "WHERE t.pelanggan_id = ? " +
                "ORDER BY t.id DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, pelangganId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Tempahan t = new Tempahan();
                    t.setId(rs.getInt("id"));
                    t.setKodTempahan(rs.getString("kod_tempahan"));
                    t.setNamaPenjahit(rs.getString("nama_penjahit"));
                    t.setTarikhSlot(rs.getDate("tarikh_slot"));
                    t.setKategoriPakaian(rs.getString("kategori_pakaian"));
                    t.setCatatan(rs.getString("catatan"));
                    t.setStatusTempahan(rs.getString("status_tempahan"));
                    t.setKaedahUkuran(rs.getString("kaedah_ukuran"));
                    
                    // Ambil masa jika ada
                    java.sql.Time timeVal = rs.getTime("masa_sesi_ukur");
                    if (timeVal != null) {
                        t.setMasaSesiUkur(timeVal.toString().substring(0, 5)); // HH:mm
                    } else {
                        t.setMasaSesiUkur(null);
                    }
                    
                    senarai.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return senarai;
    }

    public boolean kemaskiniStatus(int tempahanId, String statusBaru) {
        String sql = "UPDATE tempahan_slot SET status_tempahan = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, statusBaru);
            ps.setInt(2, tempahanId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int dapatkanPelangganId(int tempahanId) {
        String sql = "SELECT pelanggan_id FROM tempahan_slot WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tempahanId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("pelanggan_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean tambahNotifikasi(int penggunaId, String tajuk, String mesej) {
        String sql = "INSERT INTO notifikasi (pengguna_id, tajuk, mesej, status_baca) VALUES (?, ?, ?, 'BELUM_BACA')";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penggunaId);
            ps.setString(2, tajuk);
            ps.setString(3, mesej);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void tandakanNotifikasiTelahDibaca(int penggunaId) {
        String sql = "UPDATE notifikasi SET status_baca = 'DAH_BACA' WHERE pengguna_id = ? AND status_baca = 'BELUM_BACA'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penggunaId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}