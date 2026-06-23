package com.sewvana.controller;

import com.sewvana.dao.TempahanDAO;
import com.sewvana.model.Pengguna;
import com.sewvana.model.Tempahan;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/pelanggan/tempahan")
public class TempahanPelangganServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final TempahanDAO tempahanDAO = new TempahanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Sekatan Keselamatan: Mesti log masuk dan peranan PELANGGAN
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PELANGGAN".equalsIgnoreCase(user.getPeranan())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak mempunyai kebenaran untuk halaman ini.");
            return;
        }

        int idPelanggan = user.getId();
        List<Tempahan> senaraiTempahan = tempahanDAO.dapatkanSemaraiTempahanPelanggan(idPelanggan);

        request.setAttribute("senaraiTempahan", senaraiTempahan);
        request.getRequestDispatcher("/views/pelanggan/tempahan_saya.jsp").forward(request, response);
    }
}
