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
        String isGoogle = request.getParameter("isGoogle");
        String peranan = request.getParameter("role"); // Mengambil parameter 'role' dari borang atau JS

        System.out.println(">>> DEBUG RegisterServlet - aksi: " + aksi);
        System.out.println(">>> DEBUG RegisterServlet - isGoogle: " + isGoogle);
        System.out.println(">>> DEBUG RegisterServlet - peranan: " + peranan);
        System.out.println(">>> DEBUG RegisterServlet - googleToken: " + request.getParameter("googleToken"));
        System.out.println(">>> DEBUG RegisterServlet - googleCredential: " + request.getParameter("googleCredential"));

        try {
            String tokenGoogle = request.getParameter("googleToken");
            if (tokenGoogle == null || tokenGoogle.isEmpty()) {
                tokenGoogle = request.getParameter("credential");
            }
            
            boolean isGoogleSignUp = "google".equals(aksi) || "true".equals(isGoogle) || (tokenGoogle != null && !tokenGoogle.isEmpty());
            
            if (isGoogleSignUp) {
                // ---------- PROSES PENDAFTARAN GOOGLE ----------
                String[] bahagian = tokenGoogle.split("\\.");
                String payloadJson = new String(Base64.getUrlDecoder().decode(bahagian[1]));

                String googleId = ambilNilaiJson(payloadJson, "sub");
                String email = ambilNilaiJson(payloadJson, "email");
                String nama = ambilNilaiJson(payloadJson, "name");

                if (penggunaDAO.semakEmelWujud(email)) {
                    // Pengguna sudah wujud, teruskan log masuk mereka!
                    com.sewvana.model.Pengguna penggunaSediaAda = penggunaDAO.daftarAtauLogMasukGoogle(nama, email);
                    HttpSession session = request.getSession();
                    session.setAttribute("pengguna", penggunaSediaAda);
                    
                    // Halakan mengikut peranan
                    if ("PENJAHIT".equalsIgnoreCase(penggunaSediaAda.getPeranan())) {
                        response.sendRedirect(request.getContextPath() + "/dashboard-penjahit");
                    } else if ("PENTADBIR".equalsIgnoreCase(penggunaSediaAda.getPeranan())) {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard-pelanggan");
                    }
                    return;
                }

                // Simpan maklumat pengguna Google ke dalam pangkalan data (Google registers always as PELANGGAN)
                boolean sukses = penggunaDAO.daftarPenggunaGoogle(nama, email, googleId, "PELANGGAN");
                if (sukses) {
                    // Terus log masuk selepas pendaftaran berjaya
                    com.sewvana.model.Pengguna penggunaBaru = penggunaDAO.daftarAtauLogMasukGoogle(nama, email);
                    HttpSession session = request.getSession();
                    session.setAttribute("pengguna", penggunaBaru);
                    
                    // Halakan terus ke dashboard pelanggan
                    response.sendRedirect(request.getContextPath() + "/dashboard-pelanggan");
                } else {
                    request.setAttribute("error", "Masalah dalaman sistem berlaku ketika mendaftar dengan Google. Sila cuba lagi.");
                    request.getRequestDispatcher("views/register.jsp").forward(request, response);
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