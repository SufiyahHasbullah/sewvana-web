<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.TransaksiBayaran" %>
<%
    TransaksiBayaran r = (TransaksiBayaran) request.getAttribute("resit");
    if (r == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard-pelanggan");
        return;
    }
    String pageTitle = "Resit Rasmi - " + r.getKodResit();
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <style>
        /* Resit Page — Specific Styles */
        body { font-family: 'Poppins', sans-serif; background-color: var(--sw-purple-pale); }
        .receipt-card { max-width: 600px; margin: 40px auto; background: var(--sw-surface); border-radius: var(--sw-radius-xl); box-shadow: var(--sw-shadow-lg); overflow: hidden; }
        .receipt-header { background: linear-gradient(135deg, var(--sw-purple-light), var(--sw-purple-dark)); color: white; padding: 40px 20px; text-align: center; }
        .dotted-line { border-top: 2px dashed var(--sw-border); margin: 25px 0; }
        .text-large-elderly { font-size: 1.1rem; color: var(--sw-text); }
        .btn-purple-grand { background: linear-gradient(135deg, var(--sw-purple-light), var(--sw-purple)); color: white; border: none; transition: var(--sw-transition); }
        .btn-purple-grand:hover { background: linear-gradient(135deg, var(--sw-purple), var(--sw-purple-dark)); color: white; transform: translateY(-2px); }
        .style-color { color: var(--sw-purple) !important; }
        @media print { .no-print { display: none; } body { background: white; } .receipt-card { box-shadow: none; margin: 0; } }
    </style>
</head>
<body>

<div class="receipt-card">
    <div class="receipt-header text-center">
        <h1 class="fw-bold m-0">SEWVANA</h1>
        <p class="m-0 text-white-50">Sistem Tempahan Slot Jahitan Digital</p>
        <div class="mt-3">
            <% if ("BELUM_BAYAR".equals(r.getStatusBayaran())) { %>
                <span class="badge bg-white text-warning rounded-pill px-4 py-2 fw-bold fs-6" style="color: #D97706 !important;">
                    <i class="bi bi-clock-history"></i> TEMPAHAN DISAHKAN (BELUM BAYAR)
                </span>
            <% } else { %>
                <span class="badge bg-white text-success rounded-pill px-4 py-2 fw-bold fs-6">
                    <i class="bi bi-patch-check-fill"></i> TRANSAKSI BERJAYA
                </span>
            <% } %>
        </div>
    </div>

    <div class="p-4 p-md-5">
        <div class="text-center mb-4">
            <span class="text-muted d-block small text-uppercase">
                <%= "BELUM_BAYAR".equals(r.getStatusBayaran()) ? "Jumlah Anggaran Tunai / Manual" : "Jumlah Amaun Dipotong" %>
            </span>
            <h1 class="display-4 fw-bold text-dark">RM <%= r.getJumlahBayaran() %></h1>
        </div>

        <div class="dotted-line"></div>

        <div class="row g-3 text-large-elderly">
            <div class="col-5 text-muted">No. Resit:</div>
            <div class="col-7 text-end fw-bold style-color" style="color: #8B5CF6;"><%= r.getKodResit() %></div>

            <div class="col-5 text-muted">ID Saluran Gateway:</div>
            <div class="col-7 text-end text-break small"><%= r.getIdTransaksiGateway() %></div>

            <div class="col-5 text-muted">Kod Tempahan Slot:</div>
            <div class="col-7 text-end fw-semibold"><%= r.getKodTempahan() %></div>

            <div class="col-5 text-muted">Nama Pelanggan:</div>
            <div class="col-7 text-end"><%= r.getNamaPelanggan() %></div>

            <div class="col-5 text-muted">Nama Kedai / Penjahit:</div>
            <div class="col-7 text-end fw-medium"><%= r.getNamaPenjahit() %></div>

            <div class="col-5 text-muted">Kategori Baju:</div>
            <div class="col-7 text-end text-capitalize"><%= r.getKategoriPakaian() != null ? r.getKategoriPakaian().toLowerCase().replace("_", " ") : "" %></div>

            <div class="col-5 text-muted">Fasa Transaksi:</div>
            <div class="col-7 text-end"><span class="badge bg-dark text-white"><%= r.getJenisBayaran() %></span></div>

            <div class="col-5 text-muted">Kaedah Pembayaran:</div>
            <div class="col-7 text-end"><%= r.getKaedahBayaran() %></div>

            <div class="col-5 text-muted">Masa & Tarikh:</div>
            <div class="col-7 text-end text-muted small"><%= r.getTarikhBayaran() %></div>
        </div>

        <div class="dotted-line"></div>

        <div class="text-center text-muted small px-3">
            <p>Terima kasih kerana mempercayai perkhidmatan usahawan jahitan Sewvana. Sila simpan resit elektronik ini sebagai bukti sah.</p>
        </div>

        <div class="row g-2 mt-4 no-print">
            <div class="col-6">
                <button onclick="window.print()" class="btn btn-dark w-100 py-2 rounded-pill fw-bold">
                    <i class="bi bi-printer"></i> Cetak Resit
                </button>
            </div>
            <div class="col-6">
                <a href="<%= request.getContextPath() %>/dashboard-pelanggan" class="btn btn-purple-grand w-100 py-2 rounded-pill text-white text-center fw-bold text-decoration-none d-block">
                    Selesai
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>