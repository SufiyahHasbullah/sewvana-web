import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckLocalDB {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Tables in local sewvana_db:");
            ResultSet rs = stmt.executeQuery("SHOW TABLES");
            while (rs.next()) {
                System.out.println("- " + rs.getString(1));
            }
            
            System.out.println("\nColumns in 'pengguna':");
            rs = stmt.executeQuery("DESCRIBE pengguna");
            while (rs.next()) {
                System.out.println("- " + rs.getString("Field"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
