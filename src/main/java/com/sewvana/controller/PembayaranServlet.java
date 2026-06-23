package com.sewvana.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.math.BigDecimal;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Pengguna;

@WebServlet("/pelanggan/pembayaran")
public class PembayaranServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Dapatkan maklumat sesi pelanggan
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        int idPelanggan = user.getId();

        // 2. Tangkap data daripada borang ringkasan & modal
        String tailorId = request.getParameter("tailorId");
        String tarikhSlot = request.getParameter("tarikhSlot");
        String kaedahUkuran = request.getParameter("kaedahUkuran");
        String masaSesiUkur = request.getParameter("masaSesiUkur");
        
        // Membaca json items terpilih
        String finalJsonItems = request.getParameter("finalJsonItems");

        String jenisBayaran = request.getParameter("jenisBayaran"); // "DEPOSIT" atau "PENUH"
        String jumlahBayaranSebut = request.getParameter("jumlahBayaranSebut");

        String saluranPembayaran = request.getParameter("saluranRadio");
        if (saluranPembayaran == null) {
            saluranPembayaran = "FPX";
        }

        if (jumlahBayaranSebut == null || jumlahBayaranSebut.trim().isEmpty()) {
            jumlahBayaranSebut = "0.00";
        }

        BigDecimal amaunBayar = new BigDecimal(jumlahBayaranSebut);

        // Jana kod unik rujukan transaksi dan tempahan
        String idResitUnik = "SVN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String kodTempahanUnik = "TMPH-" + (System.currentTimeMillis() / 1000000);
        Timestamp masaSemasa = new Timestamp(System.currentTimeMillis());

        // Hasilkan catatan dan detect kategori pakaian daripada JSON terpilih
        String catatan = formatJsonItems(finalJsonItems);
        String kategoriPakaian = detectKategoriPakaian(finalJsonItems);

        int idTempahanBaru = -1;

        // 3. PROSES SIMPAN KE DATABASE (Telah diselaraskan dengan struktur tegar database sewvana_db)
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false); // Enable transaction rollback support
            try {
                // A. Memasukkan rekod ke jadual 'tempahan_slot'
                String sqlTempahan = "INSERT INTO tempahan_slot ("
                        + "kod_tempahan, pelanggan_id, penjahit_id, tarikh_slot, "
                        + "kategori_pakaian, catatan, status_tempahan, tarikh_cipta, kaedah_ukuran, masa_sesi_ukur"
                        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement psTempah = conn.prepareStatement(sqlTempahan, Statement.RETURN_GENERATED_KEYS)) {
                    psTempah.setString(1, kodTempahanUnik);
                    psTempah.setInt(2, idPelanggan);

                    // Mengendalikan id penjahit sandaran jika parameter kosong
                    int idPenjahitAsal = (tailorId != null && !tailorId.isEmpty()) ? Integer.parseInt(tailorId) : 1;
                    psTempah.setInt(3, idPenjahitAsal);

                    // Membersihkan rentetan tarikh daripada sebarang ralat format input
                    java.sql.Date sqlDate;
                    try {
                        if (tarikhSlot != null) {
                            tarikhSlot = tarikhSlot.trim().split(" ")[0]; // Mengambil komponen tarikh utama sahaja
                            sqlDate = java.sql.Date.valueOf(tarikhSlot);
                        } else {
                            sqlDate = new java.sql.Date(System.currentTimeMillis());
                        }
                    } catch (Exception e) {
                        sqlDate = new java.sql.Date(System.currentTimeMillis()); // Tarikh sandaran automatik
                    }
                    psTempah.setDate(4, sqlDate);

                    psTempah.setString(5, kategoriPakaian);
                    psTempah.setString(6, catatan);
                    psTempah.setString(7, "MENUNGGU_PENGESAHAN");
                    psTempah.setTimestamp(8, masaSemasa);

                    // Memastikan nilai sepadan dengan struktur kekangan ENUM fizikal pangkalan data
                    String kaedahSesuai = "UKURAN_SEDIA_ADA";
                    if ("DATANG_UKUR_BADAN".equalsIgnoreCase(kaedahUkuran)) kaedahSesuai = "DATANG_UKUR_BADAN";
                    if ("HANTAR_SENDIRI".equalsIgnoreCase(kaedahUkuran)) kaedahSesuai = "HANTAR_SENDIRI";
                    psTempah.setString(9, kaedahSesuai);

                    // Masa sesi ukuran badan
                    if (masaSesiUkur != null && !masaSesiUkur.trim().isEmpty() && !masaSesiUkur.contains("Tiada")) {
                        if (masaSesiUkur.length() == 5) masaSesiUkur += ":00"; // Format pembetulan ke HH:MM:SS
                        psTempah.setTime(10, java.sql.Time.valueOf(masaSesiUkur));
                    } else {
                        psTempah.setNull(10, java.sql.Types.TIME);
                    }

                    psTempah.executeUpdate();

                    // Dapatkan id tempahan yang baru dijana
                    try (ResultSet generatedKeys = psTempah.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            idTempahanBaru = generatedKeys.getInt(1);
                        }
                    }
                }

                if (idTempahanBaru == -1) {
                    throw new SQLException("Gagal menjana ID tempahan slot baharu.");
                }

                // B. Memasukkan rekod ke jadual 'pembayaran'
                String sqlTransaksi = "INSERT INTO pembayaran ("
                        + "tempahan_slot_id, kod_resit, jenis_bayaran, jumlah_bayaran, "
                        + "kaedah_bayaran, status_bayaran, id_transaksi_gateway, tarikh_bayaran"
                        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                try (PreparedStatement psTrans = conn.prepareStatement(sqlTransaksi)) {
                    psTrans.setInt(1, idTempahanBaru);
                    psTrans.setString(2, idResitUnik);

                    // Menyelaraskan dengan ENUM database: 'DEPOSIT','BAYARAN_PENH','BAKI_AKHIR'
                    String dbJenisBayaran = "DEPOSIT";
                    if ("PENUH".equalsIgnoreCase(jenisBayaran)) {
                        dbJenisBayaran = "BAYARAN_PENH";
                    }
                    psTrans.setString(3, dbJenisBayaran);

                    psTrans.setBigDecimal(4, amaunBayar);

                    // Menyelaraskan dengan ENUM database: 'FPX','KAD_KREDIT','GOOGLE_PAY'
                    String dbKaedahBayaran = "FPX";
                    if ("CARD".equalsIgnoreCase(saluranPembayaran)) {
                        dbKaedahBayaran = "KAD_KREDIT";
                    }
                    psTrans.setString(5, dbKaedahBayaran);

                    // Set status_bayaran ke 'BELUM_BAYAR' bagi kaedah MANUAL_OFFLINE
                    String dbStatusBayaran = "BERJAYA";
                    if ("MANUAL_OFFLINE".equalsIgnoreCase(saluranPembayaran)) {
                        dbStatusBayaran = "BELUM_BAYAR";
                    }
                    psTrans.setString(6, dbStatusBayaran);
                    psTrans.setString(7, "GW-" + saluranPembayaran + "-" + (System.currentTimeMillis() / 1000));
                    psTrans.setTimestamp(8, masaSemasa);

                    psTrans.executeUpdate();
                }

                // C. Mengurangkan kuota harian penjahit (max_tempahan = max_tempahan - 1)
                String sqlUpdateKuota = "UPDATE kuota_slot SET max_tempahan = max_tempahan - 1 "
                        + "WHERE penjahit_id = ? AND tarikh = ? AND max_tempahan > 0";

                try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateKuota)) {
                    int idPenjahitAsal = (tailorId != null && !tailorId.isEmpty()) ? Integer.parseInt(tailorId) : 1;
                    psUpdate.setInt(1, idPenjahitAsal);

                    java.sql.Date sqlDate;
                    try {
                        if (tarikhSlot != null) {
                            String tarikhMurni = tarikhSlot.trim().split(" ")[0];
                            sqlDate = java.sql.Date.valueOf(tarikhMurni);
                        } else {
                            sqlDate = new java.sql.Date(System.currentTimeMillis());
                        }
                    } catch (Exception e) {
                        sqlDate = new java.sql.Date(System.currentTimeMillis());
                    }
                    psUpdate.setDate(2, sqlDate);

                    int rowsUpdated = psUpdate.executeUpdate();
                    if (rowsUpdated == 0) {
                        throw new SQLException("Slot bagi tarikh tersebut telah penuh atau tidak lagi tersedia.");
                    }
                }

                conn.commit(); // Commit transaction
                System.out.println("[BERJAYA] Transaksi, slot tempahan, dan potongan kuota berjaya ditulis ke pangkalan data.");

            } catch (Exception ex) {
                conn.rollback(); // Rollback transaction on error
                throw ex;
            }

        } catch (Exception e) {
            System.out.println("[RALAT SISTEM] Gagal menulis transaksi ke pangkalan data!");
            e.printStackTrace();
            session.setAttribute("mesejRalat", "Gagal memproses pembayaran kerana slot tarikh terpilih telah penuh.");
            response.sendRedirect(request.getContextPath() + "/pelanggan/cari-penjahit");
            return;
        }

        // 4. Lencongkan pengguna ke halaman resit rasmi dengan parameter status
        response.sendRedirect(request.getContextPath() + "/pembayaran/resit"
                + "?Id=" + idResitUnik
                + "&amaun=" + jumlahBayaranSebut
                + "&jenisBayaran=" + jenisBayaran
                + "&kaedahBayaran=" + ("CARD".equals(saluranPembayaran) ? "Kad+Kredit+%2F+Debit" : ("MANUAL_OFFLINE".equals(saluranPembayaran) ? "Tunai+%2F+Manual+%28Offline%29" : "FPX+Online+Banking"))
                + "&statusBayaran=" + ("MANUAL_OFFLINE".equals(saluranPembayaran) ? "BELUM_BAYAR" : "BERJAYA")
        );
    }

    /**
     * Memformat Json String yang dihantar dari invois pelanggan ke bentuk senarai teks mesra pembacaan
     */
    private String formatJsonItems(String jsonStr) {
        if (jsonStr == null || jsonStr.trim().isEmpty() || jsonStr.equals("[]")) {
            return "Item Tempahan Tidak Ditentukan";
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append("Senarai Tempahan Pakaian:\n");
        try {
            // Pembersihan manual string json array flat
            String clean = jsonStr.trim();
            if (clean.startsWith("[")) clean = clean.substring(1);
            if (clean.endsWith("]")) clean = clean.substring(0, clean.length() - 1);
            
            // Pecahkan mengikut objek "},{"
            String[] objects = clean.split("\\}\\,\\{");
            for (String obj : objects) {
                obj = obj.replace("{", "").replace("}", "");
                String[] fields = obj.split(",");
                String nama = "";
                double harga = 0.0;
                int kuantiti = 0;
                
                for (String field : fields) {
                    String[] pair = field.split(":");
                    if (pair.length >= 2) {
                        String key = pair[0].replace("\"", "").trim();
                        String val = field.substring(field.indexOf(":") + 1).replace("\"", "").trim();
                        
                        if ("nama".equalsIgnoreCase(key)) {
                            nama = val;
                        } else if ("harga".equalsIgnoreCase(key)) {
                            harga = Double.parseDouble(val);
                        } else if ("kuantiti".equalsIgnoreCase(key)) {
                            kuantiti = Integer.parseInt(val);
                        }
                    }
                }
                
                if (!nama.isEmpty() && kuantiti > 0) {
                    sb.append("- ").append(kuantiti).append("x ").append(nama)
                      .append(" (RM ").append(String.format("%.2f", harga * kuantiti)).append(")\n");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Item Tempahan: " + jsonStr;
        }
        return sb.toString();
    }

    /**
     * Mengkategorikan pesanan pertama pelanggan mengikut padanan ENUM kategori_pakaian database
     */
    private String detectKategoriPakaian(String jsonStr) {
        if (jsonStr == null || jsonStr.trim().isEmpty() || jsonStr.equals("[]")) {
            return "KEMEJA";
        }
        try {
            String lower = jsonStr.toLowerCase();
            if (lower.contains("kurung")) {
                return "BAJU_KURUNG";
            } else if (lower.contains("melayu")) {
                return "BAJU_MELAYU";
            } else if (lower.contains("kemeja") || lower.contains("shirt")) {
                return "KEMEJA";
            } else if (lower.contains("alter") || lower.contains("ubah")) {
                return "ALTERATION";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "KEMEJA";
    }
}