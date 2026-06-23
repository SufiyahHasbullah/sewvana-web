package com.sewvana.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/LogoutServlet", "/logout"})
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Padam Sesi Pengguna
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Hapus Kuki Remember Me jika ada
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("sewvana_remember_token".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath(request.getContextPath() + "/");
                    cookie.setMaxAge(0); // Matikan kuki sertamerta
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        // Kembali ke Halaman Utama dengan status
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}