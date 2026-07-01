import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class AlterTempahanEnum {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3307/sewvana_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
        String user = "sewvana_user";
        String password = "root";
        
        String sql = "ALTER TABLE tempahan_slot MODIFY COLUMN status_tempahan ENUM('MENUNGGU_PENGESAHAN','AKTIF','SESI_UKURAN','DISAHKAN','SEDANG_DIJAHIT','SIAP','DIAMBIL','BATAL')";
        
        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.executeUpdate();
            System.out.println("ENUM updated successfully!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
