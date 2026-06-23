<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Dashboard Pelanggan";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    <style>
        .pagination .page-item .page-link {
            color: #6B4E9B !important;
            border-radius: 50% !important;
            margin: 0 3px !important;
            width: 30px !important;
            height: 30px !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            background-color: transparent !important;
            border-color: transparent !important;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .pagination .page-item.active .page-link {
            background-color: #6B4E9B !important;
            border-color: #6B4E9B !important;
            color: #fff !important;
        }
        .pagination .page-item.disabled .page-link {
            color: #ccc !important;
            background-color: transparent !important;
            border-color: transparent !important;
            pointer-events: none;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold m-0 heading-warga-emas">Hai, <span class="purple-text"><%= user.getNama() %></span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Urus dan tempah slot jahitan anda dengan gaya premium.</p>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-12 col-md-4">
                <div class="card card-stat card-purple text-white shadow" onclick="navigasiMenu('tempahan')">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-normal mb-1">Tempahan Aktif</h4>
                            <h2 class="display-6 fw-bold m-0">${tempahanAktif}</h2>
                        </div>
                        <i class="bi bi-clock-history fs-1 opacity-75"></i>
                    </div>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="card card-stat card-lavender shadow-sm" onclick="navigasiMenu('notifikasi')">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-normal purple-text mb-1">Notifikasi Baru</h4>
                            <h2 class="display-6 fw-bold purple-text m-0">${jumlahNotifikasi}</h2>
                        </div>
                        <i class="bi bi-bell fs-1 purple-text"></i>
                    </div>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="card card-stat card-white border-dashed text-center" onclick="navigasiMenu('slot')">
                    <div>
                        <i class="bi bi-calendar-plus-fill cat-icon mb-2 d-block"></i>
                        <h4 class="fw-bold purple-text m-0">Tempah Slot</h4>
                    </div>
                </div>
            </div>
        </div>

        <h3 class="fw-bold mb-4 section-title-warga-emas"><i class="bi bi-scissors me-2 purple-text"></i> Kategori Pakaian</h3>
        <div class="row g-3 mb-5 text-center">
            <div class="col-6 col-sm-3">
                <div class="card cat-card p-4 shadow-sm h-100" onclick="pilihKategori('Baju Kurung')">
                    <i class="bi bi-gender-female cat-icon mb-2"></i>
                    <h5 class="fw-bold mb-0 text-warga-emas">Baju Kurung</h5>
                </div>
            </div>
            <div class="col-6 col-sm-3">
                <div class="card cat-card p-4 shadow-sm h-100" onclick="pilihKategori('Baju Melayu')">
                    <i class="bi bi-gender-male cat-icon mb-2"></i>
                    <h5 class="fw-bold mb-0 text-warga-emas">Baju Melayu</h5>
                </div>
            </div>
            <div class="col-6 col-sm-3">
                <div class="card cat-card p-4 shadow-sm h-100" onclick="pilihKategori('Kemeja')">
                    <i class="bi bi-person-workspace cat-icon mb-2"></i>
                    <h5 class="fw-bold mb-0 text-warga-emas">Kemeja</h5>
                </div>
            </div>
            <div class="col-6 col-sm-3">
                <div class="card cat-card p-4 shadow-sm h-100" onclick="pilihKategori('Ubah Suai')">
                    <i class="bi bi-patch-check-fill cat-icon mb-2"></i>
                    <h5 class="fw-bold mb-0 text-warga-emas">Alteration</h5>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-12 col-xl-8">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold m-0 text-warga-emas">Status Tempahan Terkini</h4>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Penjahit</th>
                                    <th>Pakaian</th>
                                    <th>Tarikh Tempah</th>
                                    <th class="text-end">Harga</th>
                                    <th class="text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Map<String, String>> tempahanList = (List<Map<String, String>>) request.getAttribute("tempahanTerkini");
                                    if (tempahanList != null && !tempahanList.isEmpty()) {
                                        for (Map<String, String> t : tempahanList) {
                                            String statusRaw = t.get("status");
                                            String badgeClass = "bg-secondary";
                                            String statusKemas = statusRaw;

                                            if ("MENUNGGU_PENGESAHAN".equals(statusRaw)) {
                                                badgeClass = "bg-warning text-dark";
                                                statusKemas = "Menunggu Pengesahan";
                                            } else if ("AKTIF".equals(statusRaw)) {
                                                badgeClass = "bg-primary";
                                                statusKemas = "Aktif";
                                            } else if ("SESI_UKURAN".equals(statusRaw)) {
                                                badgeClass = "bg-info text-dark";
                                                statusKemas = "Sesi Ukuran";
                                            } else if ("SIAP".equals(statusRaw)) {
                                                badgeClass = "bg-success";
                                                statusKemas = "Siap";
                                            } else if ("BATAL".equals(statusRaw)) {
                                                badgeClass = "bg-danger";
                                                statusKemas = "Batal";
                                            }
                                %>
                                <tr>
                                    <td><strong>#<%= t.get("id") %></strong></td>
                                    <td><%= t.get("penjahit") %></td>
                                    <td><span class="text-capitalize"><%= t.get("pakaian").toLowerCase() %></span></td>
                                    <td><i class="bi bi-calendar3 me-1 text-muted"></i><%= t.get("tarikh_siap") %></td>
                                    <td class="text-end fw-bold text-purple">RM <%= t.get("bayaran") %></td>
                                    <td class="text-center">
                                        <span class="badge <%= badgeClass %> px-3 py-2 rounded-pill fw-medium" style="font-size: 0.85rem;">
                                            <%= statusKemas %>
                                        </span>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">Tiada tempahan terkini ditemui.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- PAGINATION BAR -->
                    <%
                        Integer halamanSemasa = (Integer) request.getAttribute("halamanSemasa");
                        Integer jumlahHalaman = (Integer) request.getAttribute("jumlahHalaman");

                        if (halamanSemasa == null) halamanSemasa = 1;
                        if (jumlahHalaman == null) jumlahHalaman = 1;

                        if (jumlahHalaman > 1) {
                    %>
                    <nav aria-label="Navigasi Halaman Tempahan" class="mt-4">
                        <ul class="pagination justify-content-center m-0">
                            <li class="page-item <%= (halamanSemasa == 1) ? "disabled" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/dashboard-pelanggan?page=<%= halamanSemasa - 1 %>">&laquo;</a>
                            </li>

                            <% for (int i = 1; i <= jumlahHalaman; i++) { %>
                                <li class="page-item <%= (i == halamanSemasa) ? "active" : "" %>">
                                    <a class="page-link" href="<%= request.getContextPath() %>/dashboard-pelanggan?page=<%= i %>"><%= i %></a>
                                </li>
                            <% } %>

                            <li class="page-item <%= (halamanSemasa.equals(jumlahHalaman)) ? "disabled" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/dashboard-pelanggan?page=<%= halamanSemasa + 1 %>">&raquo;</a>
                            </li>
                        </ul>
                    </nav>
                    <%
                        }
                    %>
                </div>
            </div>

            <div class="col-12 col-xl-4">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <h4 class="fw-bold mb-4 text-warga-emas">Penjahit Pilihan</h4>
                    <%
                        List<Map<String, String>> senaraiPenjahit = (List<Map<String, String>>) request.getAttribute("penjahitPopular");
                        if (senaraiPenjahit != null) {
                            for(Map<String, String> p : senaraiPenjahit) {
                    %>
                        <div class="d-flex align-items-center justify-content-between pb-3 mb-3 border-bottom">
                            <div>
                                <h6 class="fw-bold m-0"><%= p.get("nama") %></h6>
                                <small class="text-muted"><%= p.get("telefon") %></small>
                            </div>
                            <button class="btn btn-sm btn-outline-purple rounded-pill px-3" onclick="hubungiPenjahit('<%= p.get("id") %>')">Pilih</button>
                        </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>

    <script src="${pageContext.request.contextPath}/assets/js/dashboard_cust.js"></script>
</body>
</html>