package com.sewvana.controller;

import com.sewvana.dao.ServisDAO;
import com.sewvana.model.Pengguna;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet({"/penjahit/servis", "/penjahit/service"})
public class ServisPenjahitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ServisDAO servisDAO = new ServisDAO();

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
        if (!"PENJAHIT".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        // Ambil senarai servis aktif
        List<Map<String, Object>> senaraiServis = servisDAO.getServisByPenjahitId(user.getId());
        request.setAttribute("senaraiServis", senaraiServis);

        request.getRequestDispatcher("/views/penjahit/service.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Keselamatan: Semak log masuk
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENJAHIT".equals(user.getPeranan())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String errorMsg = null;
        String successMsg = null;

        if ("tambah".equals(action)) {
            String namaServis = request.getParameter("namaServis");
            String hargaUpahStr = request.getParameter("hargaUpah");
            String keterangan = request.getParameter("keterangan");
            if (namaServis == null || namaServis.trim().isEmpty() || hargaUpahStr == null || hargaUpahStr.trim().isEmpty()) {
                errorMsg = "Nama servis dan harga upah wajib diisi.";
            } else {
                try {
                    double hargaUpah = Double.parseDouble(hargaUpahStr);
                    boolean success = servisDAO.tambahServis(user.getId(), namaServis.trim(), hargaUpah, keterangan);
                    if (success) {
                        successMsg = "Servis baharu berjaya didaftarkan.";
                    } else {
                        errorMsg = "Gagal menambah servis ke database.";
                    }
                } catch (NumberFormatException e) {
                    errorMsg = "Format harga upah tidak sah (Contoh: 120.00).";
                }
            }
        } else if ("kemaskini".equals(action)) {
            String idStr = request.getParameter("serviceId");
            String namaServis = request.getParameter("namaServis");
            String hargaUpahStr = request.getParameter("hargaUpah");
            String keterangan = request.getParameter("keterangan");
            if (idStr == null || namaServis == null || namaServis.trim().isEmpty() || hargaUpahStr == null || hargaUpahStr.trim().isEmpty()) {
                errorMsg = "Semua maklumat servis wajib diisi.";
            } else {
                try {
                    int id = Integer.parseInt(idStr);
                    double hargaUpah = Double.parseDouble(hargaUpahStr);
                    boolean success = servisDAO.kemaskiniServis(id, user.getId(), namaServis.trim(), hargaUpah, keterangan);
                    if (success) {
                        successMsg = "Maklumat servis berjaya dikemas kini.";
                    } else {
                        errorMsg = "Gagal mengemas kini servis di database.";
                    }
                } catch (NumberFormatException e) {
                    errorMsg = "Format harga upah atau ID tidak sah.";
                }
            }
        } else if ("padam".equals(action)) {
            String idStr = request.getParameter("serviceId");
            if (idStr == null || idStr.isEmpty()) {
                errorMsg = "ID servis tidak sah.";
            } else {
                try {
                    int id = Integer.parseInt(idStr);
                    boolean success = servisDAO.padamServis(id, user.getId());
                    if (success) {
                        successMsg = "Servis berjaya dipadamkan.";
                    } else {
                        errorMsg = "Gagal memadam servis dari database.";
                    }
                } catch (NumberFormatException e) {
                    errorMsg = "ID servis tidak sah.";
                }
            }
        }

        // Ambil semula senarai servis terkini
        List<Map<String, Object>> senaraiServis = servisDAO.getServisByPenjahitId(user.getId());
        request.setAttribute("senaraiServis", senaraiServis);

        request.setAttribute("error", errorMsg);
        request.setAttribute("success", successMsg);
        request.getRequestDispatcher("/views/penjahit/service.jsp").forward(request, response);
    }
}
