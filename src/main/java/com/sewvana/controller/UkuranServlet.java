package com.sewvana.controller;

import com.sewvana.dao.UkuranDAO;
import com.sewvana.model.Pengguna;
import com.sewvana.model.UkuranPelanggan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet menguruskan halaman ukuran badan pelanggan.
 *
 * URL Patterns:
 *  - /pelanggan/ukuran          → Pelanggan akses ukuran sendiri
 *  - /penjahit/ukuran-pelanggan → Penjahit akses ukuran pelanggan (perlu ?pelangganId=X)
 */
@WebServlet({"/pelanggan/ukuran", "/penjahit/ukuran-pelanggan"})
public class UkuranServlet extends HttpServlet {

    private final UkuranDAO ukuranDAO = new UkuranDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Pengguna pengguna = (session != null) ? (Pengguna) session.getAttribute("pengguna") : null;

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String uri = request.getRequestURI();
        boolean isPenjahit = uri.contains("/penjahit/");

        int pelangganId;
        String namaPelanggan = "";

        if (isPenjahit) {
            // --- PENJAHIT: perlu ?pelangganId=X ---
            String pidParam = request.getParameter("pelangganId");
            if (pidParam == null || pidParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/penjahit/pesanan");
                return;
            }
            try {
                pelangganId = Integer.parseInt(pidParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/penjahit/pesanan");
                return;
            }

            // Semak keselamatan: penjahit mesti ada tempahan dengan pelanggan ini
            if (!ukuranDAO.penjahitAdaTempahanDenganPelanggan(pengguna.getId(), pelangganId)) {
                session.setAttribute("flashError", "Anda tidak mempunyai kebenaran untuk melihat ukuran pelanggan ini.");
                response.sendRedirect(request.getContextPath() + "/penjahit/pesanan");
                return;
            }

            // Dapatkan nama pelanggan untuk paparan
            namaPelanggan = request.getParameter("namaPelanggan");
            if (namaPelanggan == null) namaPelanggan = "Pelanggan";
            request.setAttribute("namaPelanggan", namaPelanggan);
            request.setAttribute("isPenjahitView", true);

        } else {
            // --- PELANGGAN: ID dari session ---
            pelangganId = pengguna.getId();
            request.setAttribute("isPenjahitView", false);
        }

        // Dapatkan data ukuran sedia ada
        UkuranPelanggan ukuran = ukuranDAO.dapatkanUkuranByPelangganId(pelangganId);
        request.setAttribute("ukuran", ukuran);
        request.setAttribute("targetPelangganId", pelangganId);

        // Semak apakah pengguna adalah Google user (tiada kata laluan)
        boolean isGoogleUser = (pengguna.getEmail() != null && !pengguna.getEmail().isEmpty()
                && !ukuranDAO.semakKataLaluan(pengguna.getId(), ""));
        // Cara lebih tepat: semak dari DB jika kata_laluan IS NULL
        request.setAttribute("isGoogleUser", false); // akan semak di JSP

        request.getRequestDispatcher("/views/pelanggan/ukuran_pelanggan.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Pengguna pengguna = (session != null) ? (Pengguna) session.getAttribute("pengguna") : null;

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String uri = request.getRequestURI();
        boolean isPenjahit = uri.contains("/penjahit/");

        // Ambil ID pelanggan dari form
        String pidStr = request.getParameter("pelangganId");
        int pelangganId;
        try {
            pelangganId = Integer.parseInt(pidStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + (isPenjahit ? "/penjahit/pesanan" : "/pelanggan/profil"));
            return;
        }

        // ── PENGESAHAN KATA LALUAN ──────────────────────────────────────────
        String kataLaluan = request.getParameter("kataLaluan");

        // Pelanggan verify kata laluan sendiri; Penjahit verify kata laluan mereka
        boolean katalaluanSah = ukuranDAO.semakKataLaluan(pengguna.getId(), kataLaluan);

        if (!katalaluanSah) {
            // Kembalikan ke halaman ukuran dengan mesej ralat
            String redirectUrl = isPenjahit
                ? request.getContextPath() + "/penjahit/ukuran-pelanggan?pelangganId=" + pelangganId + "&error=kata_laluan_salah"
                : request.getContextPath() + "/pelanggan/ukuran?error=kata_laluan_salah";
            response.sendRedirect(redirectUrl);
            return;
        }

        // ── KESELAMATAN PENJAHIT ────────────────────────────────────────────
        if (isPenjahit) {
            if (!ukuranDAO.penjahitAdaTempahanDenganPelanggan(pengguna.getId(), pelangganId)) {
                session.setAttribute("flashError", "Anda tidak mempunyai kebenaran untuk mengedit ukuran pelanggan ini.");
                response.sendRedirect(request.getContextPath() + "/penjahit/pesanan");
                return;
            }
        }

        // ── BINA OBJEK UKURAN ───────────────────────────────────────────────
        UkuranPelanggan ukuran = new UkuranPelanggan();
        ukuran.setPelangganId(pelangganId);

        ukuran.setBahu(parseDouble(request.getParameter("bahu")));
        ukuran.setDada(parseDouble(request.getParameter("dada")));
        ukuran.setPinggang(parseDouble(request.getParameter("pinggang")));
        ukuran.setPinggul(parseDouble(request.getParameter("pinggul")));
        ukuran.setPanjangBaju(parseDouble(request.getParameter("panjangBaju")));
        ukuran.setPanjangLengan(parseDouble(request.getParameter("panjangLengan")));
        ukuran.setPanjangSeluar(parseDouble(request.getParameter("panjangSeluar")));
        ukuran.setUkuranLeher(parseDouble(request.getParameter("ukuranLeher")));
        ukuran.setUkuranLenganAtas(parseDouble(request.getParameter("ukuranLenganAtas")));
        ukuran.setCatatanUkuran(request.getParameter("catatanUkuran"));

        String dikemasKiniOleh = isPenjahit ? "PENJAHIT" : "PELANGGAN";
        boolean berjaya = ukuranDAO.simpanAtauKemaskiniUkuran(ukuran, dikemasKiniOleh, pengguna.getNama());

        if (berjaya) {
            String redirectUrl = isPenjahit
                ? request.getContextPath() + "/penjahit/ukuran-pelanggan?pelangganId=" + pelangganId + "&success=berjaya"
                : request.getContextPath() + "/pelanggan/ukuran?success=berjaya";
            response.sendRedirect(redirectUrl);
        } else {
            String redirectUrl = isPenjahit
                ? request.getContextPath() + "/penjahit/ukuran-pelanggan?pelangganId=" + pelangganId + "&error=gagal_simpan"
                : request.getContextPath() + "/pelanggan/ukuran?error=gagal_simpan";
            response.sendRedirect(redirectUrl);
        }
    }

    /**
     * Helper: parse string ke Double, pulangkan null jika kosong atau tidak valid.
     */
    private Double parseDouble(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
