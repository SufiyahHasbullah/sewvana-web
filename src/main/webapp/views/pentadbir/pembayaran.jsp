<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Audit Transaksi";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard_admin.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-admin.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h1 class="fw-bold m-0 text-warga-emas">Log Transaksi <span class="purple-text">Kewangan</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Audit aliran tunai masuk, pengesahan resit gerbang pembayaran, dan pemantauan status kewangan sistem.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-credit-card-2-front text-success me-2"></i> Audit Platform
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0 text-dark text-warga-emas">
                            <i class="bi bi-wallet2 text-indigo me-2"></i> Rekod Pembayaran Disahkan
                        </h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-sw table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">Kod Resit</th>
                                    <th class="py-3">Kod Tempahan</th>
                                    <th class="py-3">Nama Pelanggan</th>
                                    <th class="py-3">Nama Penjahit</th>
                                    <th class="py-3">Jenis Bayaran</th>
                                    <th class="py-3">Kaedah</th>
                                    <th class="py-3 text-end">Amaun</th>
                                    <th class="py-3">Tarikh</th>
                                    <th class="py-3 text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody id="pembayaranTableBody">
                                <%
                                    List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiPembayaran");
                                    if (senarai == null || senarai.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada data pembayaran dikesan dalam pangkalan data.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (Map<String, String> p : senarai) {
                                            String statusStyle = "bg-secondary text-white";
                                            if ("BERJAYA".equalsIgnoreCase(p.get("status_bayaran"))) {
                                                statusStyle = "bg-success text-white";
                                            } else if ("PENDING".equalsIgnoreCase(p.get("status_bayaran"))) {
                                                statusStyle = "bg-warning text-dark";
                                            } else {
                                                statusStyle = "bg-danger text-white";
                                            }
                                %>
                                     <tr class="fw-medium pembayaran-row">
                                        <td data-label="Kod Resit" class="py-3"><code><%= p.get("kod_resit") %></code></td>
                                        <td data-label="Kod Tempahan"><code class="text-dark"><%= p.get("kod_tempahan") %></code></td>
                                        <td data-label="Pelanggan"><%= p.get("pelanggan") %></td>
                                        <td data-label="Penjahit"><span class="badge bg-purple-light text-purple px-2 py-1"><%= p.get("penjahit") %></span></td>
                                        <td data-label="Jenis Bayaran"><span class="small fw-bold"><%= p.get("jenis_bayaran") %></span></td>
                                        <td data-label="Kaedah"><%= p.get("kaedah_bayaran") %></td>
                                        <td data-label="Amaun" class="text-end fw-bold text-dark">RM <%= p.get("jumlah_bayaran") %></td>
                                        <td data-label="Tarikh" class="text-muted"><%= p.get("tarikh_bayaran") %></td>
                                        <td data-label="Status" class="text-center">
                                            <span class="badge rounded-pill <%= statusStyle %> px-3 py-2"><%= p.get("status_bayaran") %></span>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div id="pembayaranPagination" class="py-3 bg-white border-top"></div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#pembayaranTableBody",
                itemSelector: ".pembayaran-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#pembayaranPagination"
            });
        });
    </script>
</body>
</html>
