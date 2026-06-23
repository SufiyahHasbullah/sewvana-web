<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Senarai Penjahit";
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
                <h1 class="fw-bold m-0 text-warga-emas">Senarai <span class="purple-text">Penjahit</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Pantau kedai jahit aktif, semak prestasi perkhidmatan, dan urus pendaftaran rakan niaga.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-scissors text-purple me-2"></i> Ekosistem Jahitan
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0 text-dark text-warga-emas">
                            <i class="bi bi-shop text-indigo me-2"></i> Rakan Niaga Penjahit
                        </h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-sw table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">ID Penjahit</th>
                                    <th class="py-3">Nama Kedai / Penjahit</th>
                                    <th class="py-3">E-mel Rasmi</th>
                                    <th class="py-3">No. Telefon</th>
                                    <th class="py-3 text-center">Jumlah Servis</th>
                                    <th class="py-3 text-center">Jumlah Tempahan</th>
                                    <th class="py-3 text-center">Tindakan</th>
                                </tr>
                            </thead>
                            <tbody id="penjahitTableBody">
                                <%
                                    List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiPenjahit");
                                    if (senarai == null || senarai.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada rakan niaga penjahit dikesan dalam pangkalan data.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (Map<String, String> p : senarai) {
                                %>
                                     <tr class="fw-medium penjahit-row">
                                        <td data-label="ID Penjahit" class="py-3">#<strong><%= p.get("id") %></strong></td>
                                        <td data-label="Penjahit">
                                            <div class="d-flex align-items-center">
                                                <div class="admin-icon-box bg-purple-light me-3" style="width: 40px; height: 40px; font-size: 1.1rem;">
                                                    <i class="bi bi-scissors purple-text"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark"><%= p.get("nama") %></div>
                                                    <span class="badge bg-purple-light text-purple small">Rakan Sewvana</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td data-label="E-mel Rasmi" class="text-muted"><%= p.get("email") %></td>
                                        <td data-label="No. Telefon"><%= p.get("telefon") %></td>
                                        <td data-label="Jumlah Servis" class="text-center">
                                            <span class="badge bg-light text-dark border px-3 py-2"><%= p.get("total_servis") %> Servis</span>
                                        </td>
                                        <td data-label="Jumlah Tempahan" class="text-center">
                                            <span class="badge bg-light text-dark border px-3 py-2"><%= p.get("total_tempahan") %> Tempahan</span>
                                        </td>
                                        <td data-label="Tindakan" class="text-center">
                                            <form action="${pageContext.request.contextPath}/admin/urus-penjahit" method="POST" onsubmit="return confirm('Adakah anda pasti untuk menamatkan rakan niaga <%= p.get("nama") %>?')" style="display:inline;">
                                                <input type="hidden" name="action" value="padam">
                                                <input type="hidden" name="id" value="<%= p.get("id") %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold">
                                                    <i class="bi bi-x-circle-fill"></i> Hentikan
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div id="penjahitPagination" class="py-3 bg-white border-top"></div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#penjahitTableBody",
                itemSelector: ".penjahit-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#penjahitPagination"
            });
        });
    </script>
</body>
</html>
