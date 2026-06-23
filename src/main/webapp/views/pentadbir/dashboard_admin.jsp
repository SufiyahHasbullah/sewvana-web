<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Panel Kawalan Pusat";
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
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h1 class="fw-bold m-0 text-warga-emas">Sistem Analitik <span class="purple-text">Sewvana</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Kawalan penuh operasi pelayan, pemantauan eko-sistem, dan audit kewangan.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-cpu text-success me-2"></i> Status Server: Stabil
                </span>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card shadow-sm border-start-indigo">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 fw-bold text-uppercase tracking-wider small">Jumlah Pelanggan</p>
                            <h2 class="display-6 fw-bold m-0">${totalPelanggan}</h2>
                        </div>
                        <div class="admin-icon-box bg-indigo-light"><i class="bi bi-person-fill text-indigo"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card shadow-sm border-start-purple">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 fw-bold text-uppercase tracking-wider small">Penjahit Aktif</p>
                            <h2 class="display-6 fw-bold m-0 purple-text">${totalPenjahit}</h2>
                        </div>
                        <div class="admin-icon-box bg-purple-light"><i class="bi bi-scissors purple-text"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card shadow-sm border-start-warning">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 fw-bold text-uppercase tracking-wider small">Tempahan Aktif Global</p>
                            <h2 class="display-6 fw-bold m-0 text-warning">${totalTempahanAktif}</h2>
                        </div>
                        <div class="admin-icon-box bg-warning-light"><i class="bi bi-activity text-warning"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card card-premium-dark text-white shadow-lg">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-white-50 mb-1 fw-bold text-uppercase tracking-wider small">Jumlah Aliran Tunai</p>
                            <h2 class="display-6 fw-bold m-0 text-gradient-gold">RM ${totalKutipan}</h2>
                        </div>
                        <div class="admin-icon-box bg-blur"><i class="bi bi-currency-exchange text-white"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0 text-dark text-warga-emas">
                            <i class="bi bi-shield-shaded text-danger me-2"></i> Jejak Audit Pembayaran Terkini
                        </h3>
                        <button class="btn btn-purple btn-sm rounded-pill px-4 fw-bold" onclick="navigasiAdmin('pembayaran')">Urus Transaksi</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">No. Tempahan</th>
                                    <th class="py-3">Nama Pelanggan</th>
                                    <th class="py-3">Nama Penjahit</th>
                                    <th class="py-3">Tarikh Transaksi</th>
                                    <th class="py-3 text-end">Nilai Transaksi</th>
                                    <th class="py-3 text-center">Status Kewangan</th>
                                </tr>
                            </thead>
                            <tbody id="adminLogsBody">
                                <%
                                    List<Map<String, String>> logs = (List<Map<String, String>>) request.getAttribute("logPembayaran");
                                    if (logs == null || logs.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada rekod pergerakan dana dikesan dalam pangkalan data.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for(Map<String, String> log : logs) {
                                            String statusStyle = "bg-danger text-white";
                                            if("LUNAS".equals(log.get("status"))) statusStyle = "bg-success text-white";
                                            else if("DEPOSIT_DIBAYAR".equals(log.get("status"))) statusStyle = "bg-info text-dark";
                                %>
                                    <tr class="fw-medium log-row">
                                        <td class="py-3">#<strong><%= log.get("id") %></strong></td>
                                        <td><%= log.get("pelanggan") %></td>
                                        <td><span class="badge bg-purple-light text-purple px-2 py-1"><%= log.get("penjahit") %></span></td>
                                        <td class="text-muted"><%= log.get("tarikh") %></td>
                                        <td class="text-end fw-bold text-dark">RM <%= log.get("amaun") %></td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill <%= statusStyle %> px-3 py-2"><%= log.get("status").replace("_", " ") %></span>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div id="adminPagination" class="py-3 bg-white border-top"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="admin-bottom-nav d-block d-lg-none fixed-bottom bg-dark text-white border-top shadow-lg py-2">
        <div class="container-fluid">
            <div class="row text-center align-items-center">
                <div class="col">
                    <a href="#" class="nav-link text-white active">
                        <i class="bi bi-shield-fill-check d-block"></i> HQ
                    </a>
                </div>
                <div class="col">
                    <a href="#" class="nav-link text-white-50" onclick="navigasiAdmin('pengguna')">
                        <i class="bi bi-people d-block"></i> Warga
                    </a>
                </div>
                <div class="col">
                    <a href="#" class="nav-link text-white-50" onclick="navigasiAdmin('penjahit')">
                        <i class="bi bi-scissors d-block"></i> Kedai
                    </a>
                </div>
                <div class="col">
                    <a href="#" class="nav-link text-white-50" onclick="navigasiAdmin('pembayaran')">
                        <i class="bi bi-cash-coin d-block"></i> Dana
                    </a>
                </div>
                <div class="col">
                    <a href="#" class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-power d-block"></i> Keluar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard_admin.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#adminLogsBody",
                itemSelector: ".log-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#adminPagination"
            });
        });
    </script>
</body>
</html>