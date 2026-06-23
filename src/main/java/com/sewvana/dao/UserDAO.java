package com.sewvana.dao;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Pengguna;
import java.sql.*;

public class UserDAO {

    public Pengguna logMasukBiasa(String email, String password) throws SQLException {
        String sql = "SELECT id, nama, email, peranan, no_telefon FROM pengguna WHERE email = ? AND kata_laluan = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return petaPengguna(rs);
                }
            }
        }
        return null;
    }

    public Pengguna semakAtauCiptaUserGoogle(String googleId, String nama, String email) throws SQLException {
        String sqlCari = "SELECT id, nama, email, peranan, no_telefon FROM pengguna WHERE google_id = ? OR email = ?";
        try (Connection conn = DatabaseConfig.getConnection()) {
            try (PreparedStatement psCari = conn.prepareStatement(sqlCari)) {
                psCari.setString(1, googleId);
                psCari.setString(2, email);
                try (ResultSet rs = psCari.executeQuery()) {
                    if (rs.next()) {
                        // Jika sudah ada, kemas kini google_id jika kosong sebelum ini
                        String sqlUpdate = "UPDATE pengguna SET google_id = ? WHERE email = ?";
                        try (PreparedStatement psUp = conn.prepareStatement(sqlUpdate)) {
                            psUp.setString(1, googleId);
                            psUp.setString(2, email);
                            psUp.executeUpdate();
                        }
                        return petaPengguna(rs);
                    }
                }
            }

            // Jika pengguna baru, daftarkan automatik sebagai PELANGGAN
            String sqlDaftar = "INSERT INTO pengguna (nama, email, google_id, peranan) VALUES (?, ?, ?, 'PELANGGAN')";
            try (PreparedStatement psIns = conn.prepareStatement(sqlDaftar, Statement.RETURN_GENERATED_KEYS)) {
                psIns.setString(1, nama);
                psIns.setString(2, email);
                psIns.setString(3, googleId);
                psIns.executeUpdate();
                try (ResultSet keys = psIns.getGeneratedKeys()) {
                    if (keys.next()) {
                        Pengguna p = new Pengguna();
                        p.setId(keys.getInt(1));
                        p.setNama(nama);
                        p.setEmail(email);
                        p.setPeranan("PELANGGAN");
                        return p;
                    }
                }
            }
        }
        return null;
    }

    public void simpanTokenIngat(int userId, String token) throws SQLException {
        String sql = "UPDATE pengguna SET token_ingat = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private Pengguna petaPengguna(ResultSet rs) throws SQLException {
        Pengguna p = new Pengguna();
        p.setId(rs.getInt("id"));
        p.setNama(rs.getString("nama"));
        p.setEmail(rs.getString("email"));
        p.setPeranan(rs.getString("peranan"));
        p.setTelefon(rs.getString("no_telefon"));
        return p;
    }
}
