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
    String pageTitle = "Dashboard Penjahit";

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
        /* ── Dashboard Tailor — page-specific fixes ──────────────────── */

        /* Header section */
        .dash-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 1.75rem;
            padding-bottom: 1.25rem;
            border-bottom: 1px solid var(--sw-border);
            flex-wrap: wrap;
        }
        .dash-greeting { font-size: 1.5rem; font-weight: 700; color: var(--sw-text); margin: 0; line-height: 1.3; }
        .dash-greeting span { color: var(--sw-primary); }
        .dash-sub { color: var(--sw-text-muted); margin: 0.25rem 0 0; font-size: 0.875rem; }

        /* Stat grid — 4 equal cards in one row */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr)); /* minmax(0,1fr) prevents overflow */
            grid-auto-rows: 1fr;
            gap: 1rem;
            margin-bottom: 1.75rem;
        }
        @media (max-width: 991.98px) { .stat-grid { grid-template-columns: repeat(2, 1fr); grid-auto-rows: auto; } }
        @media (max-width: 575.98px)  { .stat-grid { grid-template-columns: 1fr; } }

        .stat-card {
            background: var(--sw-surface);
            border: 1px solid var(--sw-border);
            border-radius: var(--sw-radius-card);
            padding: 1rem 1.125rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.5rem;
            box-shadow: var(--sw-shadow-xs);
            transition: var(--sw-transition);
            min-height: 88px;
            overflow: hidden;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--sw-shadow-card); }
        .stat-card.accent {
            background: linear-gradient(135deg, var(--sw-sidebar-start), var(--sw-sidebar-end));
            border-color: transparent;
        }
        .stat-label {
            font-size: 0.65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--sw-text-muted);
            margin-bottom: 0.25rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .stat-card.accent .stat-label { color: rgba(255,255,255,0.65); }
        .stat-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--sw-text);
            line-height: 1.1;
            white-space: nowrap;
        }
        .stat-card.accent .stat-value { color: white; }
        .stat-icon {
            width: 40px; height: 40px;
            border-radius: var(--sw-radius);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        .stat-icon.purple { background: var(--sw-primary-pale); color: var(--sw-primary); }
        .stat-icon.teal   { background: #E0F7F4; color: #0D9488; }
        .stat-icon.white  { background: rgba(255,255,255,0.2); color: white; }
        .stat-icon.lavender { background: var(--sw-primary-pale); color: var(--sw-primary); }

        /* Activity table card */
        .activity-card {
            background: var(--sw-surface);
            border: 1px solid var(--sw-border);
            border-radius: var(--sw-radius-card);
            overflow: hidden;
            box-shadow: var(--sw-shadow-xs);
        }
        .activity-card-header {
            padding: 1.125rem 1.375rem;
            border-bottom: 1px solid var(--sw-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
        }
        .activity-card-header h3 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--sw-text);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .activity-card-header h3 i { color: var(--sw-primary); font-size: 1.1rem; }

        .table-sw { min-width: 700px; }
        .table-sw thead th {
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            color: var(--sw-text-muted);
            background: var(--sw-bg);
            border-bottom: 1px solid var(--sw-border);
            padding: 0.75rem 0.875rem;
            white-space: nowrap;
        }
        .table-sw tbody td {
            padding: 0.875rem 0.875rem;
            border-bottom: 1px solid var(--sw-divider);
            vertical-align: middle;
            font-size: 0.875rem;
        }
        .table-sw tbody tr:last-child td { border-bottom: none; }
        .table-sw tbody tr:hover td { background: var(--sw-primary-pale); }
        .kod-tempahan { font-weight: 700; color: var(--sw-text); font-family: 'Courier New', monospace; font-size: 0.78rem; }
        .badge-status {
            display: inline-block;
            padding: 0.3em 0.8em;
            border-radius: 20px;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            white-space: nowrap;
        }
        .empty-table { text-align: center; padding: 3rem 1rem; color: var(--sw-text-muted); }
        .empty-table i { font-size: 2.5rem; display: block; margin-bottom: 0.75rem; opacity: 0.4; }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">

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
        <div class="dash-header">
            <div>
                <h1 class="dash-greeting">Selamat Kembali, <span><%= user.getNama() %></span> 👋</h1>
                <p class="dash-sub">Berikut adalah ringkasan perniagaan jahitan anda hari ini.</p>
            </div>
            <a href="${pageContext.request.contextPath}/penjahit/slot"
               class="btn-sw-primary d-none d-md-inline-flex align-items-center gap-2">
                <i class="bi bi-calendar-plus"></i> Urus Slot Masa
            </a>
        </div>

        <%-- ── Stat Cards (4 equal columns) ── --%>
        <div class="stat-grid">

            <div class="stat-card">
                <div>
                    <div class="stat-label">Tempahan Hari Ini</div>
                    <div class="stat-value">${hariIni != null ? hariIni : '0'}</div>
                </div>
                <div class="stat-icon purple"><i class="bi bi-bell-fill"></i></div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Tempahan Bulan Ini</div>
                    <div class="stat-value">${bulanIni != null ? bulanIni : '0'}</div>
                </div>
                <div class="stat-icon teal"><i class="bi bi-scissors"></i></div>
            </div>

            <div class="stat-card accent">
                <div>
                    <div class="stat-label">Pendapatan (RM)</div>
                    <div class="stat-value">RM ${pendapatan != null ? pendapatan : '0.00'}</div>
                </div>
                <div class="stat-icon white"><i class="bi bi-currency-dollar"></i></div>
            </div>

            <div class="stat-card">
                <div>
                    <div class="stat-label">Slot Kosong Tersedia</div>
                    <div class="stat-value" style="color:var(--sw-primary);">${slotKosong != null ? slotKosong : '0'}</div>
                </div>
                <div class="stat-icon lavender"><i class="bi bi-calendar-check-fill"></i></div>
            </div>

        </div>

        <%-- ── Activity Table ── --%>
        <div class="activity-card">
            <div class="activity-card-header">
                <h3><i class="bi bi-list-stars"></i> Aktiviti Tempahan Terkini</h3>
                <button class="btn-sw-outline btn-sm" onclick="navigasiPenjahit('tempahan')">
                    Lihat Semua
                </button>
            </div>

            <div class="table-responsive">
                <table class="table table-sw mb-0">
                    <thead>
                        <tr>
                            <th>Kod Tempahan</th>
                            <th>Nama Pelanggan</th>
                            <th>Jenis Pakaian</th>
                            <th>Tarikh Slot</th>
                            <th class="text-end">Harga</th>
                            <th class="text-center">Status</th>
                            <th class="text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody id="tailorActivityTableBody">
                    <%
                        List<Map<String, String>> senarai = (List<Map<String, String>>) request.getAttribute("senaraiTempahan");
                        if (senarai == null || senarai.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7">
                                <div class="empty-table">
                                    <i class="bi bi-inbox"></i>
                                    Tiada rekod tempahan pelanggan masuk buat masa ini.
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, String> t : senarai) {
                                String status = t.get("status");

                                // Badge colour + short label mapping
                                String badgeBg = "#6B7280"; String badgeFg = "white"; String badgeLabel = status;
                                if      ("MENUNGGU_PENGESAHAN".equals(status)) { badgeBg = "#F59E0B"; badgeFg = "#1C1917"; badgeLabel = "Menunggu"; }
                                else if ("DISAHKAN".equals(status))            { badgeBg = "#06B6D4"; badgeFg = "#083344"; badgeLabel = "Disahkan"; }
                                else if ("SEDANG_DIJAHIT".equals(status))      { badgeBg = "#6366F1"; badgeFg = "white";   badgeLabel = "Dijahit"; }
                                else if ("SIAP".equals(status))                { badgeBg = "#10B981"; badgeFg = "white";   badgeLabel = "Siap"; }
                                else if ("DIAMBIL".equals(status))             { badgeBg = "#1F2937"; badgeFg = "white";   badgeLabel = "Diambil"; }
                                else if ("BATAL".equals(status))               { badgeBg = "#EF4444"; badgeFg = "white";   badgeLabel = "Batal"; }

                                String namaPakaian = t.get("pakaian") != null ? t.get("pakaian").replace("_", " ") : "-";
                    %>
                        <tr class="tempahan-row">
                            <td><span class="kod-tempahan"><%= t.get("kod_tempahan") != null ? t.get("kod_tempahan") : ("#" + t.get("id")) %></span></td>
                            <td><span class="fw-semibold"><%= t.get("pelanggan") %></span></td>
                             <td>
                                 <span class="badge bg-light border text-dark text-capitalize px-2 py-1" style="font-size:0.75rem;"><%= namaPakaian.toLowerCase() %></span>
                                 <% if (t.get("catatan") != null && !t.get("catatan").trim().isEmpty()) { %>
                                     <div class="text-secondary mt-1 lh-sm" style="font-size:0.78rem; font-weight: 500; white-space: pre-line; text-align: left;">
                                         <%= t.get("catatan") %>
                                     </div>
                                 <% } %>
                             </td>
                            <td style="color:var(--sw-text-muted);"><%= t.get("tarikh_tempah") %></td>
                            <td class="text-end fw-bold" style="color:var(--sw-primary);">RM <%= t.get("bayaran") %></td>
                            <td class="text-center">
                                <span class="badge-status" style="background:<%= badgeBg %>;color:<%= badgeFg %>;">
                                    <%= badgeLabel %>
                                </span>
                            </td>
                            <td class="text-center">
                                <form action="${pageContext.request.contextPath}/pengurusan-tempahan" method="POST" class="d-inline">
                                    <input type="hidden" name="tempahanId" value="<%= t.get("id") %>">
                                    <% if ("MENUNGGU_PENGESAHAN".equals(status)) { %>
                                        <button type="submit" name="action" value="sahkan" class="btn btn-sm btn-success rounded-pill px-3 fw-bold">
                                            <i class="bi bi-check-circle me-1"></i>Sahkan
                                        </button>
                                    <% } %>
                                    <% if ("DISAHKAN".equals(status)) { %>
                                        <button type="submit" name="action" value="jahit" class="btn btn-sm btn-primary rounded-pill px-3 fw-bold text-white">
                                            <i class="bi bi-scissors me-1"></i>Mula Jahit
                                        </button>
                                    <% } %>
                                    <% if ("SEDANG_DIJAHIT".equals(status)) { %>
                                        <button type="submit" name="action" value="siap" class="btn btn-sm rounded-pill px-3 fw-bold text-white" style="background:var(--sw-primary);">
                                            <i class="bi bi-check-all me-1"></i>Selesai
                                        </button>
                                    <% } %>
                                    <% if ("SIAP".equals(status)) { %>
                                        <button type="submit" name="action" value="ambil" class="btn btn-sm btn-dark rounded-pill px-3 fw-bold">
                                            <i class="bi bi-box-seam me-1"></i>Diserah
                                        </button>
                                    <% } %>
                                    <% if (!"SIAP".equals(status) && !"DIAMBIL".equals(status) && !"BATAL".equals(status)) { %>
                                        <button type="submit" name="action" value="batal" class="btn btn-sm btn-link text-danger fw-semibold ms-1 p-0 text-decoration-none">
                                            Batal
                                        </button>
                                    <% } else if ("DIAMBIL".equals(status) || "BATAL".equals(status)) { %>
                                        <span class="text-muted small">— Selesai —</span>
                                    <% } %>
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
            <div id="tailorActivityPagination" class="py-3 bg-white border-top"></div>
        </div>

    </div><%-- end sewvana-main-content --%>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard_tailor.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#tailorActivityTableBody",
                itemSelector: ".tempahan-row",
                itemsPerPage: 5,
                paginationContainerSelector: "#tailorActivityPagination"
            });
        });
    </script>

</body>
</html>