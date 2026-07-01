import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckTempahanSchema {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery("DESCRIBE tempahan_slot");
            while (rs.next()) {
                if (rs.getString("Field").equals("status_tempahan")) {
                    System.out.println("status_tempahan Type: " + rs.getString("Type"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
