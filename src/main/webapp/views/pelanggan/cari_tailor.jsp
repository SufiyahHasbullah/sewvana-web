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
    String pageTitle = "Cari Penjahit";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cari_tailor.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">

        <div class="content-header mb-4">
            <h1 class="fw-bold m-0 main-title">Hai, <span class="purple-text"><%= user.getNama() %></span></h1>
            <p class="text-muted m-0 sub-title">Cari dan pilih penjahit terbaik mengikut cita rasa premium anda.</p>
        </div>

        <div class="filter-card card mb-4 border-0 shadow-sm p-3">
            <form action="${pageContext.request.contextPath}/pelanggan/cari" method="GET" class="row g-3 align-items-end">

                <div class="col-12 col-md-5">
                    <label class="form-label fw-semibold text-secondary"><i class="bi bi-person"></i> Nama Penjahit</label>
                    <input type="text" name="carian" class="form-control form-control-lg" placeholder="Cari nama penjahit..." value="${carianLama != null ? carianLama : ''}">
                </div>

                <div class="col-12 col-md-5">
                    <label class="form-label fw-semibold text-secondary"><i class="bi bi-scissors"></i> Kepakaran Kategori Pakaian</label>
                    <select name="kategori" class="form-select form-select-lg">
                        <option value="">Semua Kategori</option>
                        <option value="BAJU_KURUNG" ${kategoriLama == 'BAJU_KURUNG' ? 'selected' : ''}>Baju Kurung</option>
                        <option value="BAJU_MELAYU" ${kategoriLama == 'BAJU_MELAYU' ? 'selected' : ''}>Baju Melayu</option>
                        <option value="KEMEJA" ${kategoriLama == 'KEMEJA' ? 'selected' : ''}>Kemeja</option>
                        <option value="ALTERATION" ${kategoriLama == 'ALTERATION' ? 'selected' : ''}>Alteration (Ubah Saiz)</option>
                    </select>
                </div>

                <div class="col-12 col-md-2">
                    <button type="submit" class="btn btn-purple btn-lg w-100 fw-bold shadow-sm">
                        <i class="bi bi-search me-1"></i> Tapis
                    </button>
                </div>
            </form>
        </div>

        <div class="row g-4" id="tailorListContainer">
            <%
                List<Map<String, String>> senaraiPenjahit = (List<Map<String, String>>) request.getAttribute("senaraiPenjahit");
                if (senaraiPenjahit == null || senaraiPenjahit.isEmpty()) {
            %>
                <div class="col-12 text-center py-5">
                    <div class="mb-3">
                        <i class="bi bi-emoji-frown display-1 text-muted"></i>
                    </div>
                    <p class="text-secondary fw-medium fs-4">Tiada penjahit ditemui.</p>
                    <p class="text-muted small">Cuba tukar kata kunci nama atau tetapkan semula penapis kategori pakaian.</p>
                </div>
            <%
                } else {
                    for(Map<String, String> tailor : senaraiPenjahit) {
                        String gambar = (tailor.get("gambar") != null) ? tailor.get("gambar") : "default_avatar.png";
            %>
                    <div class="col-12 col-md-6 col-xl-4">
                        <div class="card tailor-premium-card border-0 shadow-sm h-100">
                            <div class="card-body p-4 d-flex flex-column">

                                <div class="d-flex align-items-center mb-3">
                                    <img src="${pageContext.request.contextPath}/assets/img/<%= gambar %>"
                                         alt="Profil Penjahit"
                                         class="tailor-avatar me-3"
                                         onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
                                    <div>
                                        <h5 class="fw-bold m-0 text-dark"><%= tailor.get("nama") %></h5>
                                        <span class="text-muted small"><i class="bi bi-telephone-fill text-secondary me-1"></i> <%= tailor.get("no_tel") %></span>
                                    </div>
                                </div>

                                <div class="rating-badge mb-3 bg-light d-inline-block p-2 rounded-3" style="width: fit-content;">
                                    <i class="bi bi-star-fill text-warning"></i>
                                    <span class="fw-bold ms-1 text-dark"><%= tailor.get("rating") %></span>
                                    <span class="text-muted small ms-1">(<%= tailor.get("jumlah_rating") %> ulasan)</span>
                                </div>

                                <div class="text-muted small mb-4 flex-grow-1">
                                    <p class="m-0"><i class="bi bi-patch-check-fill text-success me-1"></i> Penjahit Sah Sewvana</p>
                                </div>

                                <button class="btn btn-purple w-100 rounded-pill py-3 fw-bold shadow-sm mt-auto"
                                        onclick="bukaTempahanSlot(<%= tailor.get("id") %>)">
                                    <i class="bi bi-calendar-plus me-1"></i> Tempah Slot Jahitan
                                </button>
                            </div>
                        </div>
                    </div>
            <%
                    }
                }
            %>
        </div>
        <div id="tailorPagination" class="mt-4"></div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/cari_tailor.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#tailorListContainer",
                itemSelector: ".col-12.col-md-6.col-xl-4",
                itemsPerPage: 10,
                paginationContainerSelector: "#tailorPagination"
            });
        });
    </script>
</body>
</html>