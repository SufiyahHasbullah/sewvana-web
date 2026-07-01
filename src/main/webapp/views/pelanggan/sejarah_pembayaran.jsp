<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sewvana.model.TransaksiBayaran" %>
<%
    String pageTitle = "Sejarah Pembayaran";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/pembayaran.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold m-0 heading-warga-emas">Rekod <span class="purple-text">Urus Niaga</span> Anda</h1>
                <p class="text-muted m-0 subtext-warga-emas">Senarai resit pelan pembayaran deposit dan baki jahitan.</p>
            </div>
            <a href="<%= request.getContextPath() %>/dashboard-pelanggan" class="btn btn-outline-purple rounded-pill px-4 d-none d-md-inline-block">
                <i class="bi bi-arrow-left"></i> Kembali ke Dashboard
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-sw table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="p-3">Kod Resit</th>
                            <th class="p-3">Tempahan</th>
                            <th class="p-3">Penjahit</th>
                            <th class="p-3">Jenis Fasa</th>
                            <th class="p-3 text-end">Jumlah</th>
                            <th class="p-3 text-center">Status</th>
                            <th class="p-3 text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody id="sejarahPembayaranBody">
                        <%
                            List<TransaksiBayaran> senarai = (List<TransaksiBayaran>) request.getAttribute("senaraiBayaran");
                            if (senarai == null || senarai.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-credit-card-2-back fs-1 d-block text-muted mb-3"></i>
                                    Tiada rekod transaksi pembayaran dijumpai.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (TransaksiBayaran b : senarai) {
                        %>
                            <tr class="fw-medium payment-row">
                                <td data-label="Kod Resit" class="p-3 text-purple fw-bold"><%= b.getKodResit() %></td>
                                <td data-label="Tempahan">
                                    <strong><%= b.getKodTempahan() %></strong><br>
                                    <span class="badge bg-light text-dark text-capitalize"><%= b.getKategoriPakaian() != null ? b.getKategoriPakaian().toLowerCase().replace("_", " ") : "KEMEJA" %></span>
                                </td>
                                <td data-label="Penjahit"><%= b.getNamaPenjahit() != null ? b.getNamaPenjahit() : "Kedai Penjahit Pilihan" %></td>
                                <td data-label="Jenis Fasa"><span class="badge bg-purple-pale purple-text px-2 py-1"><%= b.getJenisBayaran() %></span></td>
                                <td data-label="Jumlah" class="text-end fw-bold text-dark">RM <%= String.format("%.2f", b.getJumlahBayaran()) %></td>
                                <td data-label="Status" class="text-center">
                                    <% if ("BELUM_BAYAR".equals(b.getStatusBayaran())) { %>
                                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2">BELUM BAYAR</span>
                                    <% } else { %>
                                        <span class="badge bg-success text-white rounded-pill px-3 py-2">SUCCESS</span>
                                    <% } %>
                                </td>
                                <td data-label="Tindakan" class="text-center">
                                    <a href="<%= request.getContextPath() %>/pembayaran/resit?Id=<%= b.getKodResit() %>" class="btn btn-sm btn-purple rounded-pill px-3 text-white">
                                        <i class="bi bi-receipt"></i> Lihat Resit
                                    </a>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div id="sejarahPagination" class="py-3 bg-white border-top"></div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#sejarahPembayaranBody",
                itemSelector: ".payment-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#sejarahPagination"
            });
        });
    </script>
</body>
</html>