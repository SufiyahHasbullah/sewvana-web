<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Analitik Sistem";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard_admin.css">
    <style>
        .progress-bar-purple { background-color: var(--sw-purple); }
        .progress-bar-indigo { background-color: var(--sw-admin-accent); }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-admin.jspf" %>

    <div class="sewvana-main-content">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h1 class="fw-bold m-0 text-warga-emas">Pusat Analitik <span class="purple-text">Sistem</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Data prestasi operasi global, taburan pakaian, dan audit aliran hasil kewangan platform.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-bar-chart-line-fill text-purple me-2"></i> Laporan Live
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
                        <div class="admin-icon-box bg-indigo-light"><i class="bi bi-people-fill text-indigo"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card shadow-sm border-start-purple">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-muted mb-1 fw-bold text-uppercase tracking-wider small">Rakan Penjahit</p>
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
                            <p class="text-muted mb-1 fw-bold text-uppercase tracking-wider small">Tempahan Terkumpul</p>
                            <h2 class="display-6 fw-bold m-0 text-warning">${totalTempahan}</h2>
                        </div>
                        <div class="admin-icon-box bg-warning-light"><i class="bi bi-journal-check text-warning"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card admin-card card-premium-dark text-white shadow-lg">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-white-50 mb-1 fw-bold text-uppercase tracking-wider small">Kutipan Kasar Sewvana</p>
                            <h2 class="display-6 fw-bold m-0 text-gradient-gold">RM ${totalKutipan}</h2>
                        </div>
                        <div class="admin-icon-box bg-blur"><i class="bi bi-cash-coin text-white"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-12 col-lg-6">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white" style="height: 100%;">
                    <h3 class="fw-bold mb-4 text-dark text-warga-emas">
                        <i class="bi bi-pie-chart-fill text-indigo me-2"></i> Kategori Pakaian Popular
                    </h3>
                    <div class="d-flex flex-column gap-3">
                        <%
                            List<Map<String, String>> kategoriStats = (List<Map<String, String>>) request.getAttribute("kategoriStats");
                            if (kategoriStats == null || kategoriStats.isEmpty()) {
                        %>
                            <p class="text-muted text-center py-4">Tiada data kategori pakaian.</p>
                        <%
                            } else {
                                int colorIndex = 0;
                                for (Map<String, String> stat : kategoriStats) {
                                    String colorClass = colorIndex % 2 == 0 ? "progress-bar-purple" : "progress-bar-indigo";
                                    colorIndex++;
                        %>
                            <div>
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span class="fw-bold text-dark"><%= stat.get("kategori") %></span>
                                    <span class="badge bg-light text-dark border px-2 py-1"><%= stat.get("jumlah") %> Tempahan</span>
                                </div>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar <%= colorClass %>" role="progressbar" style="width: <%= (Integer.parseInt(stat.get("jumlah")) * 10) %>%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-6">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white" style="height: 100%;">
                    <h3 class="fw-bold mb-4 text-dark text-warga-emas">
                        <i class="bi bi-tags-fill purple-text me-2"></i> Taburan Status Pesanan
                    </h3>
                    <div class="d-flex flex-column gap-3">
                        <%
                            List<Map<String, String>> statusStats = (List<Map<String, String>>) request.getAttribute("statusStats");
                            if (statusStats == null || statusStats.isEmpty()) {
                        %>
                            <p class="text-muted text-center py-4">Tiada data status pesanan.</p>
                        <%
                            } else {
                                for (Map<String, String> stat : statusStats) {
                                    String status = stat.get("status");
                                    String badgeStyle = "bg-secondary";
                                    if ("MENUNGGU_PENGESAHAN".equals(status)) badgeStyle = "bg-warning text-dark";
                                    else if ("DISAHKAN".equals(status) || "AKTIF".equals(status)) badgeStyle = "bg-info text-dark";
                                    else if ("SEDANG_DIJAHIT".equals(status)) badgeStyle = "bg-primary";
                                    else if ("SIAP".equals(status) || "SELESAI".equals(status)) badgeStyle = "bg-success";
                                    else if ("BATAL".equals(status)) badgeStyle = "bg-danger";
                        %>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded bg-light border-start border-4 border-indigo">
                                <span class="fw-bold text-dark"><i class="bi bi-tag-fill me-2 text-muted"></i><%= status.replace("_", " ") %></span>
                                <span class="badge <%= badgeStyle %> rounded-pill px-3 py-2"><%= stat.get("jumlah") %> Fail</span>
                            </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <h3 class="fw-bold mb-4 text-dark text-warga-emas">
                        <i class="bi bi-graph-up-arrow text-success me-2"></i> Aliran Tunai Bulanan (RM)
                    </h3>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">Bulan</th>
                                    <th class="py-3 text-end">Jumlah Kutipan Kasar</th>
                                    <th class="py-3 text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Map<String, String>> bulanan = (List<Map<String, String>>) request.getAttribute("bulananStats");
                                    if (bulanan == null || bulanan.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="3" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada data aliran tunai direkodkan untuk tahun ini.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (Map<String, String> b : bulanan) {
                                %>
                                    <tr class="fw-bold">
                                        <td class="py-3"><i class="bi bi-calendar-event me-2 text-indigo"></i><%= b.get("bulan") %></td>
                                        <td class="text-end text-success">RM <%= b.get("jumlah") %></td>
                                        <td class="text-center"><span class="badge bg-success-light text-success rounded-pill px-3 py-2">Diaudit</span></td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
</body>
</html>
