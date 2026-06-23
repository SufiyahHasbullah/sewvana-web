package com.sewvana.controller;

import com.sewvana.dao.PenggunaDAO;
import com.sewvana.model.Pengguna;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/pelanggan/profil")
public class ProfilPelangganServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PenggunaDAO penggunaDAO = new PenggunaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Keselamatan: Semak log masuk
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        try {
            // Ambil maklumat terkini dari database
            Pengguna profilTerkini = penggunaDAO.dapatkanPengguna(user.getId());
            if (profilTerkini != null) {
                // Selaraskan sesi jika ada perubahan
                session.setAttribute("pengguna", profilTerkini);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/views/pelanggan/profil_saya.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Keselamatan: Semak log masuk
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        String action = request.getParameter("action");
        String errorMsg = null;
        String successMsg = null;

        if ("tukar_password".equals(action)) {
            String kataLaluanLama = request.getParameter("kataLaluanLama");
            String kataLaluanBaru = request.getParameter("kataLaluanBaru");
            String sahkanKataLaluan = request.getParameter("sahkanKataLaluan");

            if (kataLaluanLama == null || kataLaluanLama.trim().isEmpty() ||
                kataLaluanBaru == null || kataLaluanBaru.trim().isEmpty() ||
                sahkanKataLaluan == null || sahkanKataLaluan.trim().isEmpty()) {
                errorMsg = "Semua ruangan kata laluan wajib diisi.";
            } else if (!kataLaluanBaru.equals(sahkanKataLaluan)) {
                errorMsg = "Kata laluan baharu dan pengesahan tidak sepadan.";
            } else {
                try {
                    boolean success = penggunaDAO.kemaskiniKataLaluan(user.getId(), kataLaluanLama, kataLaluanBaru);
                    if (success) {
                        successMsg = "KATA_LALUAN_BERJAYA";
                    } else {
                        errorMsg = "Kata laluan lama anda salah atau gagal menukar kata laluan.";
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    errorMsg = "Ralat sistem: " + e.getMessage();
                }
            }
        } else {
            String nama = request.getParameter("nama");
            String telefon = request.getParameter("telefon");

            if (nama == null || nama.trim().isEmpty()) {
                errorMsg = "Nama tidak boleh dibiarkan kosong.";
            } else {
                try {
                    boolean success = penggunaDAO.kemaskiniProfil(user.getId(), nama.trim(), telefon != null ? telefon.trim() : "");
                    if (success) {
                        successMsg = "Profil anda berjaya dikemas kini.";
                        // Kemas kini maklumat dalam session
                        user.setNama(nama.trim());
                        user.setTelefon(telefon != null ? telefon.trim() : "");
                        session.setAttribute("pengguna", user);
                    } else {
                        errorMsg = "Gagal mengemas kini profil ke database.";
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    errorMsg = "Ralat sistem: " + e.getMessage();
                }
            }
        }

        request.setAttribute("error", errorMsg);
        request.setAttribute("success", successMsg);
        request.getRequestDispatcher("/views/pelanggan/profil_saya.jsp").forward(request, response);
    }
}
