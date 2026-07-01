package com.sewvana.controller;

import com.sewvana.dao.TempahanDAO;
import com.sewvana.model.Pengguna;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/pengurusan-tempahan")
public class PengurusanTempahanServlet extends HttpServlet {

    private final TempahanDAO tempahanDAO = new TempahanDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ambil sesi sedia ada tanpa mencipta sesi baharu
        HttpSession session = request.getSession(false);

        // 2. KESELAMATAN: Semak log masuk pengguna
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        // 3. KESELAMATAN SEKATAN: Pastikan hanya peranan PENJAHIT sahaja boleh memproses URL ini
        Pengguna user = (Pengguna) session.getAttribute("pengguna");
        if (!"PENJAHIT".equalsIgnoreCase(user.getPeranan())) {
            // Jika pelanggan cuba menceroboh, hantar ralat HTTP 403 Forbidden (Tiada Keizinan)
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak mempunyai kebenaran untuk melakukan operasi ini.");
            return;
        }

        // 4. Ekstrak data borang POST
        String action = request.getParameter("action");
        String idStr = request.getParameter("tempahanId");

        // Sediakan pembungkus mesej maklum balas (Flash Session Message)
        String ralatMesej = null;
        String jayaMesej = null;

        if (action != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                String statusBaru = null;

                // Pemetaan tindakan kepada nilai ENUM pangkalan data asal anda
                switch (action) {
                    case "sahkan":
                        statusBaru = "DISAHKAN";
                        jayaMesej = "Slot tempahan berjaya disahkan!";
                        break;
                    case "jahit":
                        statusBaru = "SEDANG_DIJAHIT";
                        jayaMesej = "Status tugasan kini ditukar ke Sedang Dijahit.";
                        break;
                    case "siap":
                        statusBaru = "SIAP";
                        jayaMesej = "Tahniah! Tempahan telah ditanda sebagai Siap.";
                        break;
                    case "ambil":
                        statusBaru = "DIAMBIL";
                        jayaMesej = "Tempahan telah diserahkan kepada pelanggan.";
                        break;
                    case "batal":
                        statusBaru = "BATAL";
                        jayaMesej = "Slot tempahan tersebut telah dibatalkan.";
                        break;
                    default:
                        ralatMesej = "Tindakan operasi tidak dikenali.";
                }

                // 5. Kemaskini pangkalan data jika status sah
                if (statusBaru != null) {
                    boolean isSuccess = tempahanDAO.kemaskiniStatus(id, statusBaru);
                    if (isSuccess) {
                        // Tambah notifikasi untuk pelanggan
                        int pelangganId = tempahanDAO.dapatkanPelangganId(id);
                        if (pelangganId > 0) {
                            String tajukNotis = "Status Tempahan Dikemaskini";
                            String mesejNotis = "Tempahan anda (ID: #" + id + ") kini berstatus: " + statusBaru + ".";
                            if (statusBaru.equals("DISAHKAN")) {
                                tajukNotis = "Tempahan Disahkan!";
                                mesejNotis = "Penjahit telah mengesahkan slot tempahan anda (ID: #" + id + "). Anda kini boleh melihat maklumat lanjut dan menunggu langkah seterusnya.";
                            }
                            tempahanDAO.tambahNotifikasi(pelangganId, tajukNotis, mesejNotis);
                        }
                    } else {
                        ralatMesej = "Gagal mengemas kini status ke pangkalan data. Sila cuba lagi.";
                        jayaMesej = null;
                    }
                }
            } catch (NumberFormatException e) {
                ralatMesej = "Format ID tempahan tidak sah.";
                e.printStackTrace();
            }
        } else {
            ralatMesej = "Parameter operasi tidak mencukupi.";
        }

        // 6. Simpan mesej dalam sesi seketika (Flash Attribute Pattern) untuk UI Bootstrap Alert di JSP
        if (jayaMesej != null) {
            session.setAttribute("flashSuccess", jayaMesej);
        }
        if (ralatMesej != null) {
            session.setAttribute("flashError", ralatMesej);
        }

        // 7. Alihkan semula pengguna kembali ke halaman asalnya
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/penjahit/pesanan-masuk");
        }
    }
}