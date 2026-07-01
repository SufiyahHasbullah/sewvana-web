<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Urus Tempahan";
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
                <h1 class="fw-bold m-0 text-warga-emas">Semua <span class="purple-text">Tempahan</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Pantau aktiviti tempahan slot, selaraskan status jahitan, dan audit pemenuhan servis pelanggan.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-calendar-check text-warning me-2"></i> Log Tempahan Global
                </span>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0 text-dark text-warga-emas">
                            <i class="bi bi-card-checklist text-indigo me-2"></i> Aliran Tempahan Sistem
                        </h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-sw table-hover align-middle m-0 text-warga-emas">
                            <thead class="table-dark-header">
                                <tr>
                                    <th class="py-3">No. Tempahan</th>
                                    <th class="py-3">Kod Tempahan</th>
                                    <th class="py-3">Pelanggan</th>
                                    <th class="py-3">Penjahit</th>
                                    <th class="py-3">Kategori</th>
                                    <th class="py-3">Tarikh Slot</th>
                                    <th class="py-3 text-center">Status</th>
                                    <th class="py-3 text-center">Tindakan</th>
                                </tr>
                            </thead>
                            <tbody id="tempahanTableBody">
                                <%
                                    List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiTempahan");
                                    if (senarai == null || senarai.isEmpty()) {
                                %>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-exclamation-triangle fs-2 d-block mb-2"></i>
                                            Tiada rekod tempahan ditemui dalam pangkalan data.
                                        </td>
                                    </tr>
                                <%
                                    } else {
                                        for (Map<String, String> t : senarai) {
                                            String statusStyle = "bg-secondary text-white";
                                            if ("MENUNGGU_PENGESAHAN".equals(t.get("status"))) {
                                                statusStyle = "bg-warning text-dark";
                                            } else if ("DISAHKAN".equals(t.get("status")) || "AKTIF".equals(t.get("status"))) {
                                                statusStyle = "bg-info text-dark";
                                            } else if ("SEDANG_DIJAHIT".equals(t.get("status"))) {
                                                statusStyle = "bg-purple text-white";
                                            } else if ("SIAP".equals(t.get("status")) || "SELESAI".equals(t.get("status"))) {
                                                statusStyle = "bg-success text-white";
                                            } else if ("BATAL".equals(t.get("status")) || "DIBATALKAN".equals(t.get("status"))) {
                                                statusStyle = "bg-danger text-white";
                                            }
                                %>
                                    <tr class="fw-medium tempahan-row">
                                        <td data-label="No. Tempahan" class="py-3">#<strong><%= t.get("id") %></strong></td>
                                        <td data-label="Kod Tempahan"><code class="text-dark fw-bold"><%= t.get("kod_tempahan") %></code></td>
                                        <td data-label="Pelanggan"><%= t.get("pelanggan") %></td>
                                        <td data-label="Penjahit"><span class="badge bg-purple-light text-purple px-2 py-1"><%= t.get("penjahit") %></span></td>
                                        <td data-label="Kategori"><%= t.get("kategori_pakaian") %></td>
                                        <td data-label="Tarikh Slot" class="text-muted"><%= t.get("tarikh_slot") %></td>
                                        <td data-label="Status" class="text-center">
                                            <span class="badge rounded-pill <%= statusStyle %> px-3 py-2"><%= t.get("status").replace("_", " ") %></span>
                                        </td>
                                        <td data-label="Tindakan" class="text-center">
                                            <% if (!"BATAL".equals(t.get("status")) && !"SELESAI".equals(t.get("status"))) { %>
                                                <form action="${pageContext.request.contextPath}/admin/urus-tempahan" method="POST" onsubmit="return confirm('Adakah anda pasti untuk membatalkan tempahan ini?')" style="display:inline;">
                                                    <input type="hidden" name="action" value="batal">
                                                    <input type="hidden" name="id" value="<%= t.get("id") %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold">
                                                        Batal Slot
                                                    </button>
                                                </form>
                                            <% } else { %>
                                                <span class="text-muted small">N/A</span>
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
                    <div id="tempahanPagination" class="py-3 bg-white border-top"></div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#tempahanTableBody",
                itemSelector: ".tempahan-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#tempahanPagination"
            });
        });
    </script>
</body>
</html>
