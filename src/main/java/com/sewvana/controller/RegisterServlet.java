package com.sewvana.controller;

import com.sewvana.dao.PenggunaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Base64;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private final PenggunaDAO penggunaDAO = new PenggunaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String aksi = request.getParameter("aksi");
        String peranan = request.getParameter("role"); // Mengambil parameter 'role' dari borang atau JS

        try {
            if ("google".equals(aksi)) {
                // ---------- PROSES PENDAFTARAN GOOGLE ----------
                String tokenGoogle = request.getParameter("googleToken");
                String[] bahagian = tokenGoogle.split("\\.");
                String payloadJson = new String(Base64.getUrlDecoder().decode(bahagian[1]));

                String googleId = ambilNilaiJson(payloadJson, "sub");
                String email = ambilNilaiJson(payloadJson, "email");
                String nama = ambilNilaiJson(payloadJson, "name");

                if (penggunaDAO.semakEmelWujud(email)) {
                    request.setAttribute("error", "E-mel akaun Google ini sudah berdaftar. Sila terus log masuk.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
                    return;
                }

                // Simpan maklumat pengguna Google ke dalam pangkalan data
                boolean sukses = penggunaDAO.daftarPenggunaGoogle(nama, email, googleId, peranan.toUpperCase());
                if (sukses) {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Akaun Google anda berjaya didaftarkan! Sila log masuk.");
                    response.sendRedirect(request.getContextPath() + "/views/login.jsp");
                }

            } else {
                // ---------- PROSES PENDAFTARAN MANUAL ----------
                String nama = request.getParameter("nama");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // Validasi kukuh di peringkat pelayan (Backend Validation)
                if (nama == null || email == null || password == null || peranan == null || password.length() < 6) {
                    request.setAttribute("error", "Maklumat pendaftaran tidak lengkap atau tidak memenuhi syarat.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
                    return;
                }

                // Semak jika emel sudah wujud dalam MySQL
                if (penggunaDAO.semakEmelWujud(email)) {
                    request.setAttribute("error", "Alamat emel ini telah digunakan. Sila cuba emel yang lain.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
                    return;
                }

                // Jalankan proses pendaftaran biasa ke MySQL
                boolean sukses = penggunaDAO.daftarPenggunaBiasa(nama, email, password, peranan.toUpperCase(), "");
                if (sukses) {
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Pendaftaran berjaya! Sila log masuk menggunakan emel anda.");
                    response.sendRedirect(request.getContextPath() + "/views/login.jsp");
                } else {
                    request.setAttribute("error", "Masalah dalaman sistem berlaku. Sila cuba sebentar lagi.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // Fungsi pemproses rentetan (String helper) JSON JWT Google
    private String ambilNilaiJson(String json, String kunci) {
        String corak = "\"" + kunci + "\":\"";
        int indexMula = json.indexOf(corak);
        if (indexMula == -1) return "";
        indexMula += corak.length();
        int indexTamat = json.indexOf("\"", indexMula);
        return json.substring(indexMula, indexTamat);
    }
}