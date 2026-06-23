package com.sewvana.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.sewvana.dao.PenggunaDAO;
import com.sewvana.model.Pengguna;

import java.io.IOException;

@WebServlet("/admin/tetapan-sistem")
public class TetapanSistemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PenggunaDAO penggunaDAO = new PenggunaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENTADBIR".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        request.getRequestDispatcher("/views/pentadbir/tetapan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENTADBIR".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("ubahPassword".equalsIgnoreCase(action)) {
            String kataLaluanLama = request.getParameter("kataLaluanLama");
            String kataLaluanBaru = request.getParameter("kataLaluanBaru");

            if (kataLaluanLama == null || kataLaluanLama.trim().isEmpty() ||
                kataLaluanBaru == null || kataLaluanBaru.trim().isEmpty()) {
                request.setAttribute("error", "Semua medan kata laluan wajib diisi.");
            } else {
                try {
                    boolean berjaya = penggunaDAO.kemaskiniKataLaluan(user.getId(), kataLaluanLama, kataLaluanBaru);
                    if (berjaya) {
                        request.setAttribute("success", "Kata laluan anda telah berjaya dikemas kini!");
                    } else {
                        request.setAttribute("error", "Kata laluan semasa anda adalah tidak sah.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Ralat sistem dikesan: " + e.getMessage());
                }
            }
        }

        request.getRequestDispatcher("/views/pentadbir/tetapan.jsp").forward(request, response);
    }
}
