import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class ResetTempahanData {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement ps = conn.prepareStatement("UPDATE tempahan_slot SET status_tempahan = 'MENUNGGU_PENGESAHAN' WHERE id = 13")) {
            
            ps.executeUpdate();
            System.out.println("Order ID 13 reset to MENUNGGU_PENGESAHAN");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
