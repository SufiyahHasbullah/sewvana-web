package com.sewvana.controller;

import com.sewvana.dao.PembayaranDAO;
import com.sewvana.model.Pengguna;
import com.sewvana.model.TransaksiBayaran;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/pelanggan/sejarah-bayaran")
public class SejarahBayaranServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PembayaranDAO pembayaranDAO = new PembayaranDAO();

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
        if (!"PELANGGAN".equalsIgnoreCase(user.getPeranan())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak mempunyai kebenaran untuk halaman ini.");
            return;
        }

        List<TransaksiBayaran> senaraiBayaran = pembayaranDAO.dapatkanSejarahPelanggan(user.getId());
        request.setAttribute("senaraiBayaran", senaraiBayaran);

        request.getRequestDispatcher("/views/pelanggan/sejarah_pembayaran.jsp").forward(request, response);
    }
}
