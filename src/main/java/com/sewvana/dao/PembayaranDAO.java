package com.sewvana.dao;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.TransaksiBayaran;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PembayaranDAO {

    public boolean simpanPembayaran(TransaksiBayaran bayaran) {
        String query = "INSERT INTO pembayaran (tempahan_slot_id, kod_resit, jenis_bayaran, jumlah_bayaran, "
                + "kaedah_bayaran, status_bayaran, id_transaksi_gateway, tarikh_bayaran) VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, bayaran.getTempahanSlotId());
            ps.setString(2, bayaran.getKodResit());
            ps.setString(3, bayaran.getJenisBayaran());
            ps.setBigDecimal(4, bayaran.getJumlahBayaran());
            ps.setString(5, bayaran.getKaedahBayaran());
            ps.setString(6, bayaran.getStatusBayaran());
            ps.setString(7, bayaran.getIdTransaksiGateway());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TransaksiBayaran> dapatkanSejarahPelanggan(int pelangganId) {
        List<TransaksiBayaran> senarai = new ArrayList<>();
        String query = "SELECT p.*, ts.kod_tempahan, j.nama AS penjahit_nama, ts.kategori_pakaian "
                + "FROM pembayaran p "
                + "JOIN tempahan_slot ts ON p.tempahan_slot_id = ts.id "
                + "JOIN pengguna j ON ts.penjahit_id = j.id "
                + "WHERE ts.pelanggan_id = ? ORDER BY p.tarikh_bayaran DESC";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, pelangganId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TransaksiBayaran t = mapResultSetToModel(rs);
                    t.setKodTempahan(rs.getString("kod_tempahan"));
                    t.setNamaPenjahit(rs.getString("penjahit_nama"));
                    t.setKategoriPakaian(rs.getString("kategori_pakaian"));
                    senarai.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    public TransaksiBayaran dapatkanResit(String kodResit) {
        String query = "SELECT p.*, ts.kod_tempahan, j.nama AS penjahit_nama, cust.nama AS pelanggan_nama, ts.kategori_pakaian "
                + "FROM pembayaran p "
                + "JOIN tempahan_slot ts ON p.tempahan_slot_id = ts.id "
                + "JOIN pengguna j ON ts.penjahit_id = j.id "
                + "JOIN pengguna cust ON ts.pelanggan_id = cust.id "
                + "WHERE p.kod_resit = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, kodResit);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TransaksiBayaran t = mapResultSetToModel(rs);
                    t.setKodTempahan(rs.getString("kod_tempahan"));
                    t.setNamaPenjahit(rs.getString("penjahit_nama"));
                    t.setNamaPelanggan(rs.getString("pelanggan_nama"));
                    t.setKategoriPakaian(rs.getString("kategori_pakaian"));
                    return t;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private TransaksiBayaran mapResultSetToModel(ResultSet rs) throws SQLException {
        TransaksiBayaran t = new TransaksiBayaran();
        t.setId(rs.getInt("id"));
        t.setTempahanSlotId(rs.getInt("tempahan_slot_id"));
        t.setKodResit(rs.getString("kod_resit"));
        t.setJenisBayaran(rs.getString("jenis_bayaran"));
        t.setJumlahBayaran(rs.getBigDecimal("jumlah_bayaran"));
        t.setKaedahBayaran(rs.getString("kaedah_bayaran"));
        t.setStatusBayaran(rs.getString("status_bayaran"));
        t.setIdTransaksiGateway(rs.getString("id_transaksi_gateway"));
        t.setTarikhBayaran(rs.getTimestamp("tarikh_bayaran"));
        return t;
    }
}