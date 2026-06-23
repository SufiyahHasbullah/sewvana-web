package com.sewvana.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/pelanggan/pilih-ukuran")
public class PilihUkuranServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Tangkap data input dari Langkah 1 (tempah_slot.jsp)
        String tailorId = request.getParameter("tailorId");
        String kategoriId = request.getParameter("kategori");
        String tarikhSlot = request.getParameter("tarikhSlot");

        // Validasi mudah untuk keselamatan data
        if (tailorId == null || kategoriId == null || tarikhSlot == null) {
            response.sendRedirect(request.getContextPath() + "/pelanggan/cari-penjahit?error=missing_parameters");
            return;
        }

        // 2. Tolak data ini ke request attribute supaya halaman Langkah 2 boleh baca semula
        request.setAttribute("tailorId", tailorId);
        request.setAttribute("kategoriId", kategoriId);
        request.setAttribute("tarikhSlot", tarikhSlot);

        // 3. Paparkan halaman Langkah 2 (pilih_ukuran.jsp)
        request.getRequestDispatcher("/views/pelanggan/pilih_ukuran.jsp").forward(request, response);
    }
}