<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    String pageTitle = "Rekod Bayaran";

    String totalRevenue = (String) request.getAttribute("hasilKasar");
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    <style>
        .revenue-card {
            background: linear-gradient(135deg, #3D2C5E 0%, #6B4E9B 100%);
            border-radius: 16px;
            color: #FFFFFF;
        }
        .table-sw { min-width: 800px; }
        .table-sw thead th {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--sw-text-muted);
            background: var(--sw-bg);
            border-bottom: 1px solid var(--sw-border);
            padding: 0.9rem 1rem;
        }
        .table-sw tbody td {
            padding: 1.1rem 1rem;
            border-bottom: 1px solid var(--sw-divider);
            vertical-align: middle;
            font-size: 0.9rem;
            color: #2D253E;
        }
        .kod-resit { font-weight: 700; color: #3D2C5E; font-family: 'Courier New', monospace; }
        .empty-table { text-align: center; padding: 4rem 1rem; color: var(--sw-text-muted); }
        .empty-table i { font-size: 3rem; display: block; margin-bottom: 1rem; opacity: 0.4; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>

        <%-- ── Header ── --%>
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <div>
                <h1 class="fw-bold text-dark m-0">Rekod & Sejarah Pembayaran</h1>
                <p class="text-muted m-0">Tinjau semua maklumat kewangan dan hasil transaksi tempahan pelanggan anda.</p>
            </div>
        </div>

        <%-- ── Statistik Ringkas ── --%>
        <div class="row g-4 mb-4">
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card revenue-card border-0 shadow p-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-white-50 small text-uppercase fw-bold letter-spacing">Jumlah Hasil Kasar</span>
                            <h2 class="display-6 fw-bold m-0 mt-1">RM <%= totalRevenue != null ? totalRevenue : "0.00" %></h2>
                        </div>
                        <i class="bi bi-wallet2 fs-1 text-white-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <%-- ── Jadual Rekod Transaksi ── --%>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
            <div class="card-header bg-white py-3 border-bottom">
                <h5 class="fw-bold text-dark m-0"><i class="bi bi-list-columns-reverse text-purple me-2"></i>Log Transaksi Masuk</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-sw mb-0">
                    <thead>
                        <tr>
                            <th>Kod Resit</th>
                            <th>Kod Tempahan</th>
                            <th>Nama Pelanggan</th>
                            <th>Jenis Komitmen</th>
                            <th>Kaedah Transaksi</th>
                            <th>Tarikh Bayaran</th>
                            <th class="text-end">Amaun</th>
                            <th class="text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody id="rekodBayaranBody">
                    <%
                        List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiPembayaran");
                        if (senarai == null || senarai.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="8">
                                <div class="empty-table">
                                    <i class="bi bi-credit-card-2-back"></i>
                                    Tiada transaksi pembayaran dikesan buat masa ini.
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, String> p : senarai) {
                                String status = p.get("status");
                                String badgeBg = "#E5E7EB"; String badgeFg = "#374151";
                                if ("BERJAYA".equals(status)) { badgeBg = "#D1FAE5"; badgeFg = "#065F46"; }
                                else if ("GAGAL".equals(status)) { badgeBg = "#FEE2E2"; badgeFg = "#991B1B"; }

                                String jenis = p.get("jenis");
                                String jenisTxt = "Deposit (20%)";
                                if ("BAYARAN_PENH".equals(jenis)) jenisTxt = "Bayaran Penuh";
                                else if ("BAKI_AKHIR".equals(jenis)) jenisTxt = "Baki Akhir";

                                String kaedah = p.get("kaedah");
                                String kaedahTxt = "Online Banking FPX";
                                if ("KAD_KREDIT".equals(kaedah)) kaedahTxt = "Kad Kredit / Debit";
                    %>
                        <tr class="bayaran-row">
                            <td data-label="Kod Resit"><span class="kod-resit"><%= p.get("kod_resit") %></span></td>
                            <td data-label="Kod Tempahan"><span class="text-secondary small font-monospace"><%= p.get("kod_tempahan") %></span></td>
                            <td data-label="Pelanggan"><strong class="text-dark"><%= p.get("pelanggan") %></strong></td>
                            <td data-label="Jenis"><span class="text-dark"><%= jenisTxt %></span></td>
                            <td data-label="Kaedah"><span class="text-secondary small"><%= kaedahTxt %></span></td>
                            <td data-label="Tarikh" style="color:#5D5370;"><%= p.get("tarikh") %></td>
                            <td data-label="Amaun" class="text-end fw-bold text-success">RM <%= p.get("amaun") %></td>
                            <td data-label="Status" class="text-center">
                                <span class="badge bg-opacity-75 px-3 py-1 rounded-pill fw-bold" style="background-color:<%= badgeBg %>; color:<%= badgeFg %>; font-size:0.75rem;">
                                    <%= status %>
                                </span>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <div id="bayaranPagination" class="py-3 bg-white border-top"></div>
        </div>

    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#rekodBayaranBody",
                itemSelector: ".bayaran-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#bayaranPagination"
            });
        });
    </script>

</body>
</html>
