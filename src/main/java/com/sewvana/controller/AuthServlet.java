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

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private final PenggunaDAO penggunaDAO = new PenggunaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String aksi = request.getParameter("aksi");

        if ("google-login.jsp".equals(aksi)) {
            String nama = request.getParameter("nama");
            String email = request.getParameter("email");

            try {
                Pengguna pengguna = penggunaDAO.daftarAtauLogMasukGoogle(nama, email);

                if (pengguna != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("pengguna", pengguna);

                    // Aliran ke Dashboard mengikut Peranan (Role)
                    switch (pengguna.getPeranan()) {
                        case "PELANGGAN":
                            response.sendRedirect("dashboard-pelanggan.jsp");
                            break;
                        case "PENJAHIT":
                            response.sendRedirect("dashboard-penjahit.jsp");
                            break;
                        case "PENTADBIR":
                            response.sendRedirect("dashboard-admin.jsp");
                            break;
                        default:
                            response.sendRedirect("index.jsp?error=peranan_tidak_wujud");
                    }
                } else {
                    response.sendRedirect("index.jsp?error=gagal_log_masuk");
                }
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }
    }
}
