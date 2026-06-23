package com.sewvana.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.sewvana.config.DatabaseConfig;
import com.sewvana.model.Pengguna;
// IMPORT ServisDAO supaya servlet boleh membaca data servis pakaian dari DB
import com.sewvana.dao.ServisDAO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/pelanggan/tempah-slot")
public class SlotPelangganServlet extends HttpServlet {

    // =========================================================================
    // 1. FUNGSI GET: Membaca slot dari DB mengikut format nama atribut JSP anda
    // =========================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tailorIdStr = request.getParameter("tailorId");
        List<Map<String, Object>> kalendarSlot = new ArrayList<>();
        List<Map<String, Object>> senaraiServis = new ArrayList<>(); // Sediakan list untuk menampung servis pakaian
        String namaPenjahit = "Penjahit";

        if (tailorIdStr != null && !tailorIdStr.isEmpty()) {
            String sqlTailor = "SELECT nama FROM pengguna WHERE id = ? AND peranan = 'PENJAHIT'";
            String sqlSlots = "SELECT tarikh, max_tempahan, status_slot FROM kuota_slot " +
                    "WHERE penjahit_id = ? AND tarikh >= CURDATE() ORDER BY tarikh ASC";

            try (Connection conn = DatabaseConfig.getConnection()) {
                // Ambil Nama Penjahit
                try (PreparedStatement ps = conn.prepareStatement(sqlTailor)) {
                    ps.setInt(1, Integer.parseInt(tailorIdStr));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            namaPenjahit = rs.getString("nama");
                        }
                    }
                }

                // Ambil Senarai Slot Masa
                try (PreparedStatement ps = conn.prepareStatement(sqlSlots)) {
                    ps.setInt(1, Integer.parseInt(tailorIdStr));
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> slot = new HashMap<>();
                            slot.put("tarikh", rs.getString("tarikh"));
                            slot.put("baki", rs.getInt("max_tempahan"));

                            String statusDb = rs.getString("status_slot");
                            if ("BUKA".equals(statusDb) && rs.getInt("max_tempahan") > 0) {
                                slot.put("status", "TERSEDIA");
                            } else {
                                slot.put("status", "PENUH / TUTUP");
                            }

                            kalendarSlot.add(slot);
                        }
                    }
                }

                // =========================================================================
                // TAMBAHAN: Memanggil ServisDAO untuk mendapatkan perkhidmatan aktif penjahit
                // =========================================================================
                try {
                    ServisDAO servisDAO = new ServisDAO();
                    senaraiServis = servisDAO.getServisByPenjahitId(Integer.parseInt(tailorIdStr));
                } catch (Exception e) {
                    getServletContext().log("Ralat memanggil ServisDAO di SlotPelangganServlet: ", e);
                }
                // =========================================================================

            } catch (Exception e) {
                getServletContext().log("Ralat sistem doGet SlotPelangganServlet: ", e);
            }
        }

        // SETKAN ATRIBUT YANG SEPADAN 100% DENGAN tempah_slot.jsp ANDA
        request.setAttribute("tailorId", tailorIdStr);
        request.setAttribute("namaPenjahit", namaPenjahit);
        request.setAttribute("kalendarSlot", kalendarSlot);

        // Hantar data servis yang ditarik dari database ke dalam JSP
        request.setAttribute("senaraiServis", senaraiServis);

        request.getRequestDispatcher("/views/pelanggan/tempah_slot.jsp").forward(request, response);
    }

    // =========================================================================
    // 2. FUNGSI POST: Memproses borang Modal, Kaedah Ukuran & Aliran Pembayaran
    // =========================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna pelanggan = (Pengguna) session.getAttribute("pengguna");

        if (pelanggan == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String penjahitIdStr = request.getParameter("tailorId");
        String tarikhTerpilih = request.getParameter("tarikhSlot");
        String kategoriAngka = request.getParameter("kategori");

        // PEMBERSIHAN BARU: Menarik parameter Kaedah Ukuran & Masa Sesi Ukur (Untuk Airbnb Flow)
        String kaedahUkuran = request.getParameter("kaedahUkuran");
        String masaSesiUkurStr = request.getParameter("masaSesiUkur"); // Format dari JSP: "10:00", "14:30" dsb

        // Pemetaan angka borang kepada String ENUM pangkalan data
        String kategoriPakaian = "BAJU_KURUNG";
        if ("2".equals(kategoriAngka)) {
            kategoriPakaian = "BAJU_MELAYU";
        } else if ("3".equals(kategoriAngka)) {
            kategoriPakaian = "KEMEJA";
        } else if ("4".equals(kategoriAngka)) {
            kategoriPakaian = "ALTERATION";
        }

        // Menentukan status awal tempahan berdasarkan kaedah ukuran pilihan
        String statusTempahanAwal = "MENUNGGU_PENGESAHAN";
        if ("DATANG_UKUR_BADAN".equals(kaedahUkuran)) {
            statusTempahanAwal = "SESI_UKURAN"; // Mengubah kitaran kerja pangkalan data secara dinamik
        }

        String masaSemasa = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String kodTempahan = "SVN-" + masaSemasa;

        // PENAMBAHBAIKAN SQL: Memasukkan kolum `kaedah_ukuran` dan `masa_sesi_ukur` ke dalam query asal
        String sqlInsert = "INSERT INTO tempahan_slot (kod_tempahan, pelanggan_id, penjahit_id, tarikh_slot, " +
                "kategori_pakaian, status_tempahan, kaedah_ukuran, masa_sesi_ukur) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlUpdateKuota = "UPDATE kuota_slot SET max_tempahan = max_tempahan - 1 " +
                "WHERE penjahit_id = ? AND tarikh = ? AND max_tempahan > 0";

        int idTempahanBaru = -1;

        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);

            // Menggunakan Statement.RETURN_GENERATED_KEYS untuk mendapatkan ID auto-increment demi kelancaran modul pembayaran
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateKuota)) {

                psInsert.setString(1, kodTempahan);
                psInsert.setInt(2, pelanggan.getId());
                psInsert.setInt(3, Integer.parseInt(penjahitIdStr));
                psInsert.setDate(4, java.sql.Date.valueOf(tarikhTerpilih));
                psInsert.setString(5, kategoriPakaian);
                psInsert.setString(6, statusTempahanAwal);

                // Set parameter baharu (Jika null/tidak dipilih, set jenis lalai atau null)
                psInsert.setString(7, kaedahUkuran != null ? kaedahUkuran : "UKURAN_SEDIA_ADA");

                if (masaSesiUkurStr != null && !masaSesiUkurStr.isEmpty() && "DATANG_UKUR_BADAN".equals(kaedahUkuran)) {
                    psInsert.setTime(8, java.sql.Time.valueOf(masaSesiUkurStr + ":00"));
                } else {
                    psInsert.setNull(8, java.sql.Types.TIME);
                }

                psInsert.executeUpdate();

                // Dapatkan ID yang baru dihasilkan untuk dihantar ke resit/pembayaran
                try (ResultSet generatedKeys = psInsert.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        idTempahanBaru = generatedKeys.getInt(1);
                    }
                }

                // Mengurangkan kuota harian penjahit
                psUpdate.setInt(1, Integer.parseInt(penjahitIdStr));
                psUpdate.setDate(2, java.sql.Date.valueOf(tarikhTerpilih));
                int rowsUpdated = psUpdate.executeUpdate();

                if (rowsUpdated > 0 && idTempahanBaru != -1) {
                    conn.commit();
                    session.setAttribute("mesejSukses", "Slot anda berjaya dikunci! Kod Tempahan: " + kodTempahan);

                    // ALIRAN MODEN: Pemangkasan klik! Terus bawa pelanggan ke gateway pembayaran dengan rujukan ID tempahan baharu
                    response.sendRedirect(request.getContextPath() + "/pembayaran?tempahanSlotId=" + idTempahanBaru + "&kodTempahan=" + kodTempahan);
                    return;
                } else {
                    conn.rollback();
                    session.setAttribute("mesejRalat", "Slot bagi tarikh tersebut baru sahaja penuh atau ditutup.");
                }

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mesejRalat", "Ralat sistem: Gagal memproses tempahan slot.");
        }

        // Jika gagal, kembalikan ke paparan kalendar asal
        response.sendRedirect(request.getContextPath() + "/pelanggan/tempah-slot?tailorId=" + penjahitIdStr);
    }
}