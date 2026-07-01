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
    String pageTitle = "Pesanan Masuk";

    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    <style>
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
        .kod-tempahan { font-weight: 700; color: #3D2C5E; font-family: 'Courier New', monospace; }
        .badge-status {
            display: inline-block;
            padding: 0.4em 0.9em;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.03em;
        }
        .empty-table { text-align: center; padding: 4rem 1rem; color: var(--sw-text-muted); }
        .empty-table i { font-size: 3rem; display: block; margin-bottom: 1rem; opacity: 0.4; }
        .search-container {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid var(--sw-border);
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>

        <%-- Flash messages --%>
        <% if (flashSuccess != null) { %>
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill"></i> <%= flashSuccess %>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (flashError != null) { %>
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= flashError %>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%-- ── Header ── --%>
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <div>
                <h1 class="fw-bold text-dark m-0">Pengurusan Pesanan Masuk</h1>
                <p class="text-muted m-0">Urus dan pantau status tempahan pakaian pelanggan anda secara keseluruhan.</p>
            </div>
        </div>

        <%-- ── Filter / Carian ── --%>
        <div class="search-container p-3 mb-4 shadow-sm">
            <div class="row g-3">
                <div class="col-12 col-md-6 col-lg-8">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-0"><i class="bi bi-search text-secondary"></i></span>
                        <input type="text" id="carianPelanggan" class="form-control bg-light border-0 py-2 text-dark" placeholder="Cari nama pelanggan atau kod tempahan...">
                    </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                    <select id="penapisStatus" class="form-select bg-light border-0 py-2 text-dark">
                        <option value="">Semua Status</option>
                        <option value="MENUNGGU_PENGESAHAN">Menunggu Pengesahan</option>
                        <option value="DISAHKAN">Disahkan / Aktif</option>
                        <option value="SEDANG_DIJAHIT">Sedang Dijahit</option>
                        <option value="SIAP">Siap & Sedia Ambil</option>
                        <option value="DIAMBIL">Telah Diambil</option>
                        <option value="BATAL">Dibatalkan</option>
                    </select>
                </div>
            </div>
        </div>

        <%-- ── Jadual Pesanan ── --%>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
            <div class="table-responsive">
                <table class="table table-sw mb-0" id="jadualPesanan">
                    <thead>
                        <tr>
                            <th>Kod Tempahan</th>
                            <th>Nama Pelanggan</th>
                            <th>Perincian Tempahan & Kuantiti</th>
                            <th>Tarikh Slot</th>
                            <th class="text-end">Jumlah Amaun</th>
                            <th class="text-center">Status</th>
                            <th class="text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiTempahan");
                        if (senarai == null || senarai.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7">
                                <div class="empty-table">
                                    <i class="bi bi-inbox"></i>
                                    Tiada rekod pesanan pelanggan ditemui.
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, String> t : senarai) {
                                String status = t.get("status");

                                // Badge styling
                                String badgeBg = "#E5E7EB"; String badgeFg = "#374151"; String badgeLabel = status;
                                if      ("MENUNGGU_PENGESAHAN".equals(status)) { badgeBg = "#FEF3C7"; badgeFg = "#92400E"; badgeLabel = "Menunggu"; }
                                else if ("DISAHKAN".equals(status))            { badgeBg = "#CFFAFE"; badgeFg = "#0E7490"; badgeLabel = "Disahkan"; }
                                else if ("SEDANG_DIJAHIT".equals(status))      { badgeBg = "#E0E7FF"; badgeFg = "#3730A3"; badgeLabel = "Dijahit"; }
                                else if ("SIAP".equals(status))                { badgeBg = "#D1FAE5"; badgeFg = "#065F46"; badgeLabel = "Siap"; }
                                else if ("DIAMBIL".equals(status))             { badgeBg = "#F3F4F6"; badgeFg = "#1F2937"; badgeLabel = "Diambil"; }
                                else if ("BATAL".equals(status))               { badgeBg = "#FEE2E2"; badgeFg = "#991B1B"; badgeLabel = "Batal"; }

                                String namaPakaian = t.get("pakaian") != null ? t.get("pakaian").replace("_", " ") : "-";

                                // Logik pengiraan tempoh kepentingan tarikh slot
                                String dateClass = "";
                                String dateBadge = "";
                                try {
                                    String tarikhSlotStr = t.get("tarikh_tempah");
                                    if (tarikhSlotStr != null) {
                                        java.time.LocalDate slotDate = java.time.LocalDate.parse(tarikhSlotStr);
                                        java.time.LocalDate todayDate = java.time.LocalDate.now();
                                        
                                        if (!"SIAP".equals(status) && !"DIAMBIL".equals(status) && !"BATAL".equals(status)) {
                                            if (slotDate.isBefore(todayDate)) {
                                                dateClass = "text-danger fw-bold";
                                                dateBadge = "<span class='badge bg-danger-subtle text-danger ms-2' style='font-size:0.7rem; vertical-align: middle;'>LEWAT</span>";
                                            } else if (slotDate.isEqual(todayDate)) {
                                                dateClass = "text-warning fw-bold";
                                                dateBadge = "<span class='badge bg-warning-subtle text-warning ms-2' style='font-size:0.7rem; vertical-align: middle;'>HARI INI</span>";
                                            } else if (slotDate.isEqual(todayDate.plusDays(1))) {
                                                dateClass = "text-info fw-bold";
                                                dateBadge = "<span class='badge bg-info-subtle text-info ms-2' style='font-size:0.7rem; vertical-align: middle;'>ESOK</span>";
                                            }
                                        }
                                    }
                                } catch (Exception ex) {
                                    // bypass jika format tarikh silap
                                }
                    %>
                        <tr class="pesanan-row" data-pelanggan='<%= t.get("pelanggan") != null ? t.get("pelanggan").toLowerCase() : "" %>' data-kod='<%= (t.get("kod_tempahan") != null ? t.get("kod_tempahan") : ("#" + t.get("id"))).toLowerCase() %>' data-status="<%= status %>">
                            <td data-label="Kod Tempahan"><span class="kod-tempahan"><%= t.get("kod_tempahan") != null ? t.get("kod_tempahan") : ("#" + t.get("id")) %></span></td>
                            <td data-label="Pelanggan"><strong class="text-dark"><%= t.get("pelanggan") %></strong></td>
                            <td data-label="Perincian">
                                <span class="badge bg-light border text-dark text-capitalize px-2 py-1 mb-1" style="font-size:0.75rem;"><%= namaPakaian.toLowerCase() %></span>
                                <% if (t.get("catatan") != null && !t.get("catatan").trim().isEmpty()) { %>
                                    <div class="text-secondary mt-1 lh-sm" style="font-size:0.82rem; font-weight: 500; white-space: pre-line; text-align: left;">
                                        <%= t.get("catatan") %>
                                    </div>
                                <% } %>
                            </td>
                            <td data-label="Tarikh Slot" class="<%= dateClass %>" style="color:#5D5370;"><%= t.get("tarikh_tempah") %><%= dateBadge %></td>
                            <td data-label="Amaun" class="text-end fw-bold text-purple">RM <%= t.get("bayaran") %></td>
                            <td data-label="Status" class="text-center">
                                <span class="badge-status" style="background:<%= badgeBg %>;color:<%= badgeFg %>;">
                                    <%= badgeLabel %>
                                </span>
                            </td>
                            <td data-label="Tindakan" class="text-center">
                                <form action="${pageContext.request.contextPath}/pengurusan-tempahan" method="POST" class="d-inline">
                                    <input type="hidden" name="tempahanId" value='<%= t.get("id") %>'>
                                    <% if ("MENUNGGU_PENGESAHAN".equals(status)) { %>
                                        <button type="submit" name="action" value="sahkan" class="btn btn-sm btn-success rounded-pill px-3 fw-bold mb-1">
                                            Sahkan
                                        </button>
                                    <% } %>
                                    <% if ("DISAHKAN".equals(status)) { %>
                                        <button type="submit" name="action" value="jahit" class="btn btn-sm btn-primary rounded-pill px-3 fw-bold text-white mb-1">
                                            Mula Jahit
                                        </button>
                                    <% } %>
                                    <% if ("SEDANG_DIJAHIT".equals(status)) { %>
                                        <button type="submit" name="action" value="siap" class="btn btn-sm rounded-pill px-3 fw-bold text-white mb-1" style="background:var(--sw-primary);">
                                            Selesai
                                        </button>
                                    <% } %>
                                    <% if ("SIAP".equals(status)) { %>
                                        <button type="submit" name="action" value="ambil" class="btn btn-sm btn-dark rounded-pill px-3 fw-bold mb-1">
                                            Diserah
                                        </button>
                                    <% } %>
                                    
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/penjahit/ukuran-pelanggan?pelangganId=<%= t.get("pelanggan_id") %>&tempahanId=<%= t.get("id") %>&namaPelanggan=<%= java.net.URLEncoder.encode(t.get("pelanggan"), "UTF-8") %>" class="btn btn-sm btn-outline-purple rounded-pill px-3 fw-bold" style="font-size:0.75rem;">
                                            <i class="bi bi-rulers me-1"></i> Ukuran
                                        </a>
                                        <% if (!"SIAP".equals(status) && !"DIAMBIL".equals(status) && !"BATAL".equals(status)) { %>
                                            <button type="submit" name="action" value="batal" class="btn btn-sm btn-link text-danger fw-semibold ms-1 p-0 text-decoration-none" style="font-size:0.75rem;" onclick="return confirm('Adakah anda pasti mahu membatalkan tempahan ini? Tindakan ini tidak boleh dipadam.');">
                                                Batal
                                            </button>
                                        <% } %>
                                    </div>
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
            <div id="pesananPagination" class="py-3 bg-white border-top"></div>
        </div>

    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        // Logik Tapisan & Carian Dinamik
        document.addEventListener("DOMContentLoaded", function() {
            const paginator = window.initPagination({
                containerSelector: "#jadualPesanan tbody",
                itemSelector: ".pesanan-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#pesananPagination"
            });

            const inputCarian = document.getElementById("carianPelanggan");
            const selectStatus = document.getElementById("penapisStatus");
            const barisPesanan = document.querySelectorAll(".pesanan-row");

            function tapisJadual() {
                const kueri = inputCarian.value.toLowerCase().trim();
                const statusTerpilih = selectStatus.value;

                barisPesanan.forEach(row => {
                    const nama = row.getAttribute("data-pelanggan");
                    const kod = row.getAttribute("data-kod");
                    const status = row.getAttribute("data-status");

                    const padananKueri = nama.includes(kueri) || kod.includes(kueri);
                    const padananStatus = statusTerpilih === "" || status === statusTerpilih;

                    if (padananKueri && padananStatus) {
                        row.removeAttribute("data-search-hidden");
                        row.style.display = "";
                    } else {
                        row.setAttribute("data-search-hidden", "true");
                        row.style.display = "none";
                    }
                });

                if (paginator) {
                    paginator.reset();
                }
            }

            if (inputCarian) inputCarian.addEventListener("input", tapisJadual);
            if (selectStatus) selectStatus.addEventListener("change", tapisJadual);
        });
    </script>

</body>
</html>
