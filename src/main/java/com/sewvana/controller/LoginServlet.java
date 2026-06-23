package com.sewvana.controller;

import com.sewvana.dao.UserDAO;
import com.sewvana.model.Pengguna;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Base64;
import java.util.UUID;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String aksi = request.getParameter("aksi");

        try {
            Pengguna pengguna = null;

            if ("google".equals(aksi)) {
                // Proses Login Google Account
                String tokenGoogle = request.getParameter("googleToken");
                if (tokenGoogle != null && !tokenGoogle.isEmpty()) {
                    // Ekstrak data JWT Google Payload secara selamat
                    String[] bahagian = tokenGoogle.split("\\.");
                    String payloadJson = new String(Base64.getUrlDecoder().decode(bahagian[1]));

                    // Ekstrak manual ringkas untuk parameter tanpa bergantung kepada jackson/gson library luar
                    String googleId = ambilNilaiJson(payloadJson, "sub");
                    String email = ambilNilaiJson(payloadJson, "email");
                    String nama = ambilNilaiJson(payloadJson, "name");

                    pengguna = userDAO.semakAtauCiptaUserGoogle(googleId, nama, email);
                }
            } else {
                // Proses Login Email & Password Biasa
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String remember = request.getParameter("remember");

                pengguna = userDAO.logMasukBiasa(email, password);

                if (pengguna != null && remember != null) {
                    // Cipta kuki untuk ciri Remember Me
                    String tokenUnik = UUID.randomUUID().toString();
                    userDAO.simpanTokenIngat(pengguna.getId(), tokenUnik);

                    Cookie kukiRemember = new Cookie("sewvana_remember_token", tokenUnik);
                    kukiRemember.setMaxAge(60 * 60 * 24 * 30); // Valid selama 30 hari
                    kukiRemember.setHttpOnly(true);
                    kukiRemember.setPath(request.getContextPath() + "/");
                    response.addCookie(kukiRemember);
                }
            }

            if (pengguna != null) {
                // Cipta Session Management
                HttpSession session = request.getSession();
                session.setAttribute("pengguna", pengguna);
                halakanDashboard(pengguna.getPeranan(), response, request);
            } else {
                request.setAttribute("error", "Alamat emel atau kata laluan tidak sah.");
                request.getRequestDispatcher("views/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void halakanDashboard(String peranan, HttpServletResponse response, HttpServletRequest request) throws IOException {
        // Memastikan peranan ditukar ke huruf besar untuk mengelakkan ralat keserasian string
        String roleUpper = (peranan != null) ? peranan.toUpperCase() : "";

        if ("PELANGGAN".equals(roleUpper)) {
            // Kita halakan pengguna ke URL Servlet Dashboard Pelanggan yang telah kita bina
            response.sendRedirect(request.getContextPath() + "/dashboard-pelanggan");
        }
        else if ("PENJAHIT".equals(roleUpper)) {
            // Laluan terus ke fail JSP Penjahit (pastikan nama folder & fail sepadan)
            response.sendRedirect(request.getContextPath() + "/dashboard-penjahit");
        }
        else if ("PENTADBIR".equals(roleUpper)) {
            // Laluan terus ke fail JSP Admin via Servlet
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
        else {
            // Jika peranan tidak dikenali, hantar balik ke halaman utama
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        }
    }

    private String ambilNilaiJson(String json, String kunci) {
        String corak = "\"" + kunci + "\":\"";
        int indexMula = json.indexOf(corak);
        if (indexMula == -1) {
            corak = "\"" + kunci + "\":"; // untuk nilai boolean atau non-string
            indexMula = json.indexOf(corak);
            if (indexMula == -1) return "";
            int indexTamat = json.indexOf(",", indexMula);
            if (indexTamat == -1) indexTamat = json.indexOf("}", indexMula);
            return json.substring(indexMula + corak.length(), indexTamat).trim().replace("\"", "");
        }
        indexMula += corak.length();
        int indexTamat = json.indexOf("\"", indexMula);
        return json.substring(indexMula, indexTamat);
    }
}