package com.sewvana.dao;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.UkuranPelanggan;
import java.sql.*;

/**
 * DAO untuk menguruskan operasi data ukuran badan pelanggan.
 */
public class UkuranDAO {

    /**
     * Dapatkan rekod ukuran berdasarkan ID pelanggan.
     * Pulangkan null jika tiada rekod.
     */
    public UkuranPelanggan dapatkanUkuranByPelangganId(int pelangganId) {
        String sql = "SELECT * FROM ukuran_pelanggan WHERE pelanggan_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pelangganId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return petakanResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Simpan atau kemaskini ukuran pelanggan (UPSERT).
     * Jika rekod sedia ada, kemaskini. Jika tiada, insert baru.
     *
     * @param ukuran           objek ukuran yang hendak disimpan
     * @param dikemasKiniOleh  "PELANGGAN" atau "PENJAHIT"
     * @param namaPengemaSkini nama pengguna yang melakukan kemaskini
     * @return true jika berjaya
     */
    public boolean simpanAtauKemaskiniUkuran(UkuranPelanggan ukuran, String dikemasKiniOleh, String namaPengemaSkini) {
        // Semak sama ada rekod sudah wujud
        boolean wujud = (dapatkanUkuranByPelangganId(ukuran.getPelangganId()) != null);

        String sql;
        if (wujud) {
            sql = "UPDATE ukuran_pelanggan SET " +
                  "bahu=?, dada=?, pinggang=?, pinggul=?, " +
                  "panjang_baju=?, panjang_lengan=?, panjang_seluar=?, " +
                  "ukuran_leher=?, ukuran_lengan_atas=?, catatan_ukuran=?, " +
                  "dikemas_kini_oleh=?, nama_pengemas_kini=? " +
                  "WHERE pelanggan_id=?";
        } else {
            sql = "INSERT INTO ukuran_pelanggan " +
                  "(bahu, dada, pinggang, pinggul, panjang_baju, panjang_lengan, panjang_seluar, " +
                  "ukuran_leher, ukuran_lengan_atas, catatan_ukuran, dikemas_kini_oleh, nama_pengemas_kini, pelanggan_id) " +
                  "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        }

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1,  ukuran.getBahu());
            ps.setObject(2,  ukuran.getDada());
            ps.setObject(3,  ukuran.getPinggang());
            ps.setObject(4,  ukuran.getPinggul());
            ps.setObject(5,  ukuran.getPanjangBaju());
            ps.setObject(6,  ukuran.getPanjangLengan());
            ps.setObject(7,  ukuran.getPanjangSeluar());
            ps.setObject(8,  ukuran.getUkuranLeher());
            ps.setObject(9,  ukuran.getUkuranLenganAtas());
            ps.setString(10, ukuran.getCatatanUkuran());
            ps.setString(11, dikemasKiniOleh);
            ps.setString(12, namaPengemaSkini);
            ps.setInt(13, ukuran.getPelangganId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Semak kata laluan pelanggan (untuk pengesahan keselamatan sebelum edit ukuran).
     * Digunakan bila PELANGGAN edit ukuran mereka sendiri.
     *
     * @param penggunaId ID pengguna (pelanggan atau penjahit)
     * @param kataLaluan kata laluan yang dimasukkan
     * @return true jika kata laluan betul
     */
    public boolean semakKataLaluan(int penggunaId, String kataLaluan) {
        String sql = "SELECT id FROM pengguna WHERE id = ? AND kata_laluan = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penggunaId);
            ps.setString(2, kataLaluan);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Semak sama ada penjahit mempunyai tempahan aktif dengan pelanggan ini.
     * Keselamatan: penjahit hanya boleh akses ukuran pelanggan yang ada tempahan dengan dia.
     */
    public boolean penjahitAdaTempahanDenganPelanggan(int penjahitId, int pelangganId) {
        String sql = "SELECT id FROM tempahan_slot " +
                     "WHERE penjahit_id = ? AND pelanggan_id = ? " +
                     "AND status_tempahan NOT IN ('BATAL') LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, penjahitId);
            ps.setInt(2, pelangganId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Petakan ResultSet ke objek UkuranPelanggan.
     */
    private UkuranPelanggan petakanResultSet(ResultSet rs) throws SQLException {
        UkuranPelanggan u = new UkuranPelanggan();
        u.setId(rs.getInt("id"));
        u.setPelangganId(rs.getInt("pelanggan_id"));

        // Guna getObject supaya null boleh disimpan (bukan 0.0)
        u.setBahu(rs.getObject("bahu") != null ? rs.getDouble("bahu") : null);
        u.setDada(rs.getObject("dada") != null ? rs.getDouble("dada") : null);
        u.setPinggang(rs.getObject("pinggang") != null ? rs.getDouble("pinggang") : null);
        u.setPinggul(rs.getObject("pinggul") != null ? rs.getDouble("pinggul") : null);
        u.setPanjangBaju(rs.getObject("panjang_baju") != null ? rs.getDouble("panjang_baju") : null);
        u.setPanjangLengan(rs.getObject("panjang_lengan") != null ? rs.getDouble("panjang_lengan") : null);
        u.setPanjangSeluar(rs.getObject("panjang_seluar") != null ? rs.getDouble("panjang_seluar") : null);
        u.setUkuranLeher(rs.getObject("ukuran_leher") != null ? rs.getDouble("ukuran_leher") : null);
        u.setUkuranLenganAtas(rs.getObject("ukuran_lengan_atas") != null ? rs.getDouble("ukuran_lengan_atas") : null);
        u.setCatatanUkuran(rs.getString("catatan_ukuran"));
        u.setDikemasKiniOleh(rs.getString("dikemas_kini_oleh"));
        u.setNamaPengemaSkini(rs.getString("nama_pengemas_kini"));
        u.setTarikhKemaskini(rs.getTimestamp("tarikh_kemaskini"));
        u.setTarikhCipta(rs.getTimestamp("tarikh_cipta"));
        return u;
    }
}
