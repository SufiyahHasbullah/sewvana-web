package com.sewvana.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/pelanggan/ringkasan-tempahan")
public class RingkasanTempahanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Tangkap semua data pengumpulan dari fasa sebelum ini
        String tailorId = request.getParameter("tailorId");
        String tarikhSlot = request.getParameter("tarikhSlot");
        String kaedahUkuran = request.getParameter("kaedahUkuran");
        String masaSesiUkur = request.getParameter("masaSesiUkur");

        // Tambahan: Tangkap kaedah dan komitmen bayaran pilihan awal dari pelanggan
        String kaedahPembayaran = request.getParameter("kaedahPembayaran");
        String jenisKomitmen = request.getParameter("jenisKomitmen");

        // Tangkap string JSON troli pakaian (Multi-Service) yang dihantar oleh tempah_slot.js
        String jsonItemTempahan = request.getParameter("jsonItemTempahan");

        // Set nilai lalai jika pelanggan tidak memilih Sesi Ukur Badan (Pilihan Hadir Ke Kedai)
        if (masaSesiUkur == null || "UKURAN_SEDIA_ADA".equals(kaedahUkuran) || "HANTAR_SENDIRI".equals(kaedahUkuran)) {
            masaSesiUkur = "Tiada (Bukan Temujanji Kedai)";
        }

        // Set nilai sandaran (fallback) jika jsonItemTempahan kosong untuk mengelakkan ralat JavaScript di halaman sebelah
        if (jsonItemTempahan == null || jsonItemTempahan.trim().isEmpty()) {
            jsonItemTempahan = "[]";
        }

        // 2. Hantar semua data ke Request Attribute untuk dibaca oleh ringkasan_tempahan.jsp
        request.setAttribute("tailorId", tailorId);
        request.setAttribute("tarikhSlot", tarikhSlot);
        request.setAttribute("kaedahUkuran", kaedahUkuran);
        request.setAttribute("masaSesiUkur", masaSesiUkur);
        request.setAttribute("kaedahPembayaran", kaedahPembayaran);
        request.setAttribute("jenisKomitmen", jenisKomitmen);
        request.setAttribute("jsonItemTempahan", jsonItemTempahan);

        // 3. Forward ke halaman Ringkasan Tempahan JSP
        request.getRequestDispatcher("/views/pelanggan/ringkasan_tempahan.jsp").forward(request, response);
    }
}