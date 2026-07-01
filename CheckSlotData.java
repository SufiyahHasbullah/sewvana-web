import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckSlotData {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Data in 'kuota_slot':");
            ResultSet rs = stmt.executeQuery("SELECT * FROM kuota_slot");
            while (rs.next()) {
                System.out.println("- id=" + rs.getInt("id") + ", penjahit_id=" + rs.getInt("penjahit_id") + 
                                   ", tarikh=" + rs.getString("tarikh") + ", max_tempahan=" + rs.getInt("max_tempahan") +
                                   ", status_slot=" + rs.getString("status_slot"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
