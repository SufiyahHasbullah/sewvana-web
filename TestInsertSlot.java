import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class TestInsertSlot {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "INSERT INTO kuota_slot (penjahit_id, tarikh, max_tempahan, status_slot) " +
                         "VALUES (?, ?, ?, ?) " +
                         "ON DUPLICATE KEY UPDATE max_tempahan = ?, status_slot = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, 2); // assuming penjahit 2
                ps.setString(2, "2026-07-03");
                ps.setInt(3, 5);
                ps.setString(4, "BUKA");
                ps.setInt(5, 5);
                ps.setString(6, "BUKA");
                ps.executeUpdate();
                System.out.println("Insert successful!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
