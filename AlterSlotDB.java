import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class AlterSlotDB {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Adding unique constraint to kuota_slot...");
            try {
                stmt.executeUpdate("ALTER TABLE kuota_slot ADD CONSTRAINT unique_penjahit_tarikh UNIQUE (penjahit_id, tarikh);");
                System.out.println("Constraint added.");
            } catch (Exception e) {
                System.out.println("Constraint might exist: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
