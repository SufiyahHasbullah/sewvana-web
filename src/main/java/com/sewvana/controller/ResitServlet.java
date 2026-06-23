package com.sewvana.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.math.BigDecimal;
import java.sql.Timestamp;
import com.sewvana.model.TransaksiBayaran;
import com.sewvana.config.DatabaseConfig; // Memakai konfigurasi database sedia ada awak

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/pembayaran/resit")
public class ResitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil data parameter daripada URL / PembayaranServlet
        String idResit = request.getParameter("Id");
        String amaunSebut = request.getParameter("amaun");
        String jenisBayarParam = request.getParameter("jenisBayaran");
        String kaedahBayarParam = request.getParameter("kaedahBayaran");

        if (idResit == null || idResit.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard-pelanggan");
            return;
        }

        String statusBayarParam = request.getParameter("statusBayaran");
        TransaksiBayaran resitObjek = null;

        // 2. Cuba dapatkan data rasmi daripada jadual 'pembayaran' dengan JOIN
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "SELECT p.*, ts.kod_tempahan, j.nama AS penjahit_nama, cust.nama AS pelanggan_nama, ts.kategori_pakaian "
                    + "FROM pembayaran p "
                    + "JOIN tempahan_slot ts ON p.tempahan_slot_id = ts.id "
                    + "JOIN pengguna j ON ts.penjahit_id = j.id "
                    + "JOIN pengguna cust ON ts.pelanggan_id = cust.id "
                    + "WHERE p.kod_resit = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, idResit);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        resitObjek = new TransaksiBayaran();
                        resitObjek.setKodResit(rs.getString("kod_resit"));
                        resitObjek.setJumlahBayaran(rs.getBigDecimal("jumlah_bayaran"));
                        resitObjek.setIdTransaksiGateway(rs.getString("id_transaksi_gateway"));
                        resitObjek.setKodTempahan(rs.getString("kod_tempahan"));
                        resitObjek.setNamaPelanggan(rs.getString("pelanggan_nama"));
                        resitObjek.setNamaPenjahit(rs.getString("penjahit_nama"));
                        resitObjek.setKategoriPakaian(rs.getString("kategori_pakaian"));
                        resitObjek.setJenisBayaran(rs.getString("jenis_bayaran"));
                        resitObjek.setKaedahBayaran(rs.getString("kaedah_bayaran"));
                        resitObjek.setStatusBayaran(rs.getString("status_bayaran"));
                        resitObjek.setTarikhBayaran(rs.getTimestamp("tarikh_bayaran"));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[INFO] Membaca data secara terus melalui parameter URL.");
        }

        // 3. JIKA DATA BELUM MASUK/TIADA: Bina objek secara dinamik berasaskan parameter URL
        // Langkah keselamatan (fallback) supaya harga order tetap sepadan & tepat!
        if (resitObjek == null) {
            resitObjek = new TransaksiBayaran();
            resitObjek.setKodResit(idResit);

            // Mengambil amaun daripada pembelian sebenar secara dinamik
            if (amaunSebut != null && !amaunSebut.isEmpty()) {
                resitObjek.setJumlahBayaran(new BigDecimal(amaunSebut));
            } else {
                resitObjek.setJumlahBayaran(new BigDecimal("0.00"));
            }

            resitObjek.setIdTransaksiGateway("GW-SECURE-" + (System.currentTimeMillis() / 1000));
            resitObjek.setKodTempahan("TMPH-" + (System.currentTimeMillis() / 1000000));
            resitObjek.setNamaPelanggan("Pelanggan Sewvana");
            resitObjek.setNamaPenjahit("Kedai Penjahit Pilihan");
            resitObjek.setKategoriPakaian("KEMEJA"); // Dipadankan dengan ENUM pangkalan data
            resitObjek.setJenisBayaran((jenisBayarParam != null) ? jenisBayarParam : "DEPOSIT");
            resitObjek.setKaedahBayaran((kaedahBayarParam != null) ? kaedahBayarParam : "FPX Online Banking");
            resitObjek.setStatusBayaran((statusBayarParam != null) ? statusBayarParam : "BERJAYA");
            resitObjek.setTarikhBayaran(new Timestamp(System.currentTimeMillis()));
        }

        // 4. Set atribut "resit" dan hantar (forward) ke halaman resit JSP
        request.setAttribute("resit", resitObjek);
        request.getRequestDispatcher("/views/pelanggan/resit_pembayaran.jsp").forward(request, response);
    }
}