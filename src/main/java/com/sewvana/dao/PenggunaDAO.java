package com.sewvana.dao;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Pengguna;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PenggunaDAO {

    public Pengguna daftarAtauLogMasukGoogle(String nama, String email) throws SQLException {
        String sqlCari = "SELECT * FROM pengguna WHERE email = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement psCari = conn.prepareStatement(sqlCari)) {

            psCari.setString(1, email);
            try (ResultSet rs = psCari.executeQuery()) {
                if (rs.next()) {
                    Pengguna p = new Pengguna();
                    p.setId(rs.getInt("id"));
                    p.setNama(rs.getString("nama"));
                    p.setEmail(rs.getString("email"));
                    p.setPeranan(rs.getString("peranan"));
                    return p;
                } else {
                    // Jika pengguna baru (Lalai sebagai PELANGGAN)
                    String sqlDaftar = "INSERT INTO pengguna (nama, email, peranan) VALUES (?, ?, 'PELANGGAN')";
                    try (PreparedStatement psDaftar = conn.prepareStatement(sqlDaftar, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        psDaftar.setString(1, nama);
                        psDaftar.setString(2, email);
                        psDaftar.executeUpdate();

                        try (ResultSet rsKeys = psDaftar.getGeneratedKeys()) {
                            if (rsKeys.next()) {
                                Pengguna pBaru = new Pengguna();
                                pBaru.setId(rsKeys.getInt(1));
                                pBaru.setNama(nama);
                                pBaru.setEmail(email);
                                pBaru.setPeranan("PELANGGAN");
                                return pBaru;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }

    public boolean semakEmelWujud(String email) throws SQLException {
        String sql = "SELECT id FROM pengguna WHERE email = ?";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Pulangkan true jika emel sudah ada, false jika belum ada
            }
        }
    }

    public boolean daftarPenggunaBiasa(String nama, String email, String password, String peranan, String noTelefon) throws SQLException {
        String sql = "INSERT INTO pengguna (nama, email, kata_laluan, peranan, no_telefon) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, password); // Nota: Disimpan sebagai teks biasa untuk fasa pembangunan awal
            ps.setString(4, peranan.toUpperCase()); // Memastikan nilai sentiasa 'PELANGGAN' atau 'PENJAHIT'
            ps.setString(5, noTelefon != null ? noTelefon : "");

            int barisTerkesan = ps.executeUpdate();
            return barisTerkesan > 0; // Pulangkan true jika berjaya disisip ke dalam MySQL
        }
    }

    public boolean daftarPenggunaGoogle(String nama, String email, String googleId, String peranan) throws SQLException {
        String sql = "INSERT INTO pengguna (nama, email, google_id, peranan) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nama);
            ps.setString(2, email);
            ps.setString(3, googleId);
            ps.setString(4, peranan.toUpperCase());

            int barisTerkesan = ps.executeUpdate();
            return barisTerkesan > 0;
        }
    }

    public Pengguna dapatkanPengguna(int id) throws SQLException {
        String sql = "SELECT id, nama, email, peranan, no_telefon FROM pengguna WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Pengguna(
                        rs.getInt("id"),
                        rs.getString("nama"),
                        rs.getString("email"),
                        rs.getString("peranan"),
                        rs.getString("no_telefon")
                    );
                }
            }
        }
        return null;
    }

    public boolean kemaskiniProfil(int id, String nama, String telefon) throws SQLException {
        String sql = "UPDATE pengguna SET nama = ?, no_telefon = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nama);
            ps.setString(2, telefon);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean kemaskiniKataLaluan(int id, String kataLaluanLama, String kataLaluanBaru) throws SQLException {
        // Mula-mula semak kata laluan lama betul atau tidak
        String sqlSemak = "SELECT id FROM pengguna WHERE id = ? AND kata_laluan = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement psSemak = conn.prepareStatement(sqlSemak)) {
            psSemak.setInt(1, id);
            psSemak.setString(2, kataLaluanLama);
            try (ResultSet rs = psSemak.executeQuery()) {
                if (!rs.next()) {
                    return false; // Kata laluan lama tidak sepadan
                }
            }
        }

        // Kemaskini kata laluan baharu
        String sqlKemaskini = "UPDATE pengguna SET kata_laluan = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement psKemaskini = conn.prepareStatement(sqlKemaskini)) {
            psKemaskini.setString(1, kataLaluanBaru);
            psKemaskini.setInt(2, id);
            return psKemaskini.executeUpdate() > 0;
        }
    }
}