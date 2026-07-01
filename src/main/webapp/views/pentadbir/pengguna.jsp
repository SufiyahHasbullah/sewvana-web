<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Urus Pengguna";
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
                <h1 class="fw-bold m-0 text-warga-emas">Pengurusan <span class="purple-text">Pengguna</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Urus peranan pengguna, pantau profil pendaftaran, dan audit capaian keselamatan sistem.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-shield-check text-success me-2"></i> Pintu HQ Selamat
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0 text-dark text-warga-emas">
                            <i class="bi bi-people-fill text-indigo me-2"></i> Warga Sewvana
                        </h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-sw table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">ID Pengguna</th>
                                    <th class="py-3">Nama</th>
                                    <th class="py-3">E-mel</th>
                                    <th class="py-3">No. Telefon</th>
                                    <th class="py-3">Peranan</th>
                                    <th class="py-3 text-center">Tindakan</th>
                                </tr>
                            </thead>
                            <tbody id="penggunaTableBody">
                                <%
                                    List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiPengguna");
                                    if (senarai == null || senarai.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada rekod pengguna dikesan dalam pangkalan data.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (Map<String, String> p : senarai) {
                                            String roleStyle = "bg-secondary text-white";
                                            if ("PENTADBIR".equals(p.get("peranan"))) {
                                                roleStyle = "bg-danger text-white";
                                            } else if ("PENJAHIT".equals(p.get("peranan"))) {
                                                roleStyle = "bg-success text-white";
                                            } else if ("PELANGGAN".equals(p.get("peranan"))) {
                                                roleStyle = "bg-primary text-white";
                                            }
                                %>
                                     <tr class="fw-medium pengguna-row">
                                        <td data-label="ID Pengguna" class="py-3">#<strong><%= p.get("id") %></strong></td>
                                        <td data-label="Nama"><%= p.get("nama") %></td>
                                        <td data-label="E-mel" class="text-muted"><%= p.get("email") %></td>
                                        <td data-label="No. Telefon"><%= p.get("telefon") %></td>
                                        <td data-label="Peranan">
                                            <span class="badge rounded-pill <%= roleStyle %> px-3 py-2"><%= p.get("peranan") %></span>
                                        </td>
                                        <td data-label="Tindakan" class="text-center">
                                            <% if (!"PENTADBIR".equals(p.get("peranan"))) { %>
                                                <form action="${pageContext.request.contextPath}/admin/urus-pengguna" method="POST" onsubmit="return confirm('Adakah anda pasti untuk memadam akaun pengguna <%= p.get("nama") %>?')" style="display:inline;">
                                                    <input type="hidden" name="action" value="padam">
                                                    <input type="hidden" name="id" value="<%= p.get("id") %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold">
                                                        <i class="bi bi-trash3-fill"></i> Padam
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span class="badge bg-light text-dark border px-2 py-1">Utama</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div id="penggunaPagination" class="py-3 bg-white border-top"></div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#penggunaTableBody",
                itemSelector: ".pengguna-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#penggunaPagination"
            });
        });
    </script>
</body>
</html>
