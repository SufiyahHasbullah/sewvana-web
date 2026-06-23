<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.sewvana.model.Tempahan" %>
<%
    String pageTitle = "Tempahan Saya";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <style>
        .booking-card {
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            border-radius: 16px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            background: #ffffff;
        }
        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(107, 78, 155, 0.1) !important;
        }
        .badge-status {
            font-size: 0.85rem;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
        }
        .text-purple-dark {
            color: #3D2C5E;
        }
        .btn-action {
            border-radius: 20px;
            padding: 8px 20px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s ease-in-out;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold m-0 heading-warga-emas">Tempahan <span class="purple-text">Saya</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Pantau kemajuan status tempahan jahitan pakaian anda secara langsung.</p>
            </div>
            <a href="<%= request.getContextPath() %>/pelanggan/cari-penjahit" class="btn btn-purple rounded-pill px-4 btn-action text-white">
                <i class="bi bi-plus-lg me-2"></i> Tempah Slot Baru
            </a>
        </div>

        <%-- Senarai Tempahan --%>
        <div class="row g-4" id="bookingListContainer">
            <%
                List<Tempahan> senarai = (List<Tempahan>) request.getAttribute("senaraiTempahan");
                if (senarai == null || senarai.isEmpty()) {
            %>
                <div class="col-12 text-center py-5">
                    <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
                        <i class="bi bi-bag-x-fill display-1 text-muted mb-3"></i>
                        <h3 class="fw-bold text-dark">Tiada Tempahan Dijumpai</h3>
                        <p class="text-muted">Anda belum membuat sebarang tempahan slot setakat ini.</p>
                        <a href="<%= request.getContextPath() %>/pelanggan/cari-penjahit" class="btn btn-purple rounded-pill px-4 py-2 mt-3 text-white fw-bold">
                            Cari Penjahit Sekarang
                        </a>
                    </div>
                </div>
            <%
                } else {
                    for (Tempahan t : senarai) {
                        String status = t.getStatusTempahan();
                        String badgeClass = "bg-secondary text-white";
                        String statusTxt = status;

                        if ("MENUNGGU_PENGESAHAN".equalsIgnoreCase(status)) {
                            badgeClass = "bg-warning text-dark";
                            statusTxt = "Menunggu Pengesahan";
                        } else if ("SESI_UKURAN".equalsIgnoreCase(status)) {
                            badgeClass = "bg-info text-dark";
                            statusTxt = "Sesi Ukuran";
                        } else if ("DISAHKAN".equalsIgnoreCase(status) || "AKTIF".equalsIgnoreCase(status)) {
                            badgeClass = "bg-primary text-white";
                            statusTxt = "Aktif";
                        } else if ("SEDANG_DIJAHIT".equalsIgnoreCase(status)) {
                            badgeClass = "bg-purple text-white";
                            statusTxt = "Sedang Dijahit";
                        } else if ("SIAP".equalsIgnoreCase(status)) {
                            badgeClass = "bg-success text-white";
                            statusTxt = "Siap & Sedia Ambil";
                        } else if ("DIAMBIL".equalsIgnoreCase(status)) {
                            badgeClass = "bg-dark text-white";
                            statusTxt = "Telah Diambil";
                        } else if ("BATAL".equalsIgnoreCase(status)) {
                            badgeClass = "bg-danger text-white";
                            statusTxt = "Dibatalkan";
                        }
            %>
                <div class="col-12 col-md-6 col-xxl-4">
                    <div class="card booking-card shadow-sm p-4 h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="badge <%= badgeClass %> badge-status shadow-sm"><%= statusTxt %></span>
                                <span class="text-muted small"><%= t.getTarikhSlot() != null ? t.getTarikhSlot().toString() : "-" %></span>
                            </div>

                            <h4 class="fw-bold text-purple-dark mb-1">#<%= t.getKodTempahan() %></h4>
                            <p class="text-muted small mb-3"><i class="bi bi-shop me-1 text-purple"></i> Penjahit: <strong><%= t.getNamaPenjahit() %></strong></p>

                            <hr class="my-3">

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <span class="text-muted small d-block">Jenis Pakaian</span>
                                    <span class="fw-semibold text-dark text-capitalize"><%= t.getKategoriPakaian().toLowerCase().replace("_", " ") %></span>
                                </div>
                                <div class="col-6">
                                    <span class="text-muted small d-block">Kaedah Ukuran</span>
                                    <span class="fw-semibold text-dark">
                                        <%= "DATANG_UKUR_BADAN".equals(t.getKaedahUkuran()) ? "Temujanji Kedai" : "Ukuran Sedia Ada" %>
                                    </span>
                                </div>
                                <% if("DATANG_UKUR_BADAN".equals(t.getKaedahUkuran()) && t.getMasaSesiUkur() != null) { %>
                                    <div class="col-12 mt-2">
                                        <span class="text-muted small d-block">Masa Temujanji</span>
                                        <span class="fw-semibold text-purple"><i class="bi bi-clock me-1"></i> <%= t.getMasaSesiUkur() %></span>
                                    </div>
                                <% } %>
                            </div>

                            <% if (t.getCatatan() != null && !t.getCatatan().trim().isEmpty()) { %>
                                <div class="p-3 bg-light rounded-3 mb-3">
                                    <span class="text-muted small d-block mb-1"><i class="bi bi-chat-right-text me-1 text-purple"></i> Catatan</span>
                                    <span class="text-dark small" style="white-space: pre-line; display: block; text-align: left;"><%= t.getCatatan() %></span>
                                </div>
                            <% } %>
                        </div>

                        <div class="d-flex gap-2 mt-4 pt-3 border-top">
                            <a href="https://wa.me/601110887123" target="_blank" class="btn btn-outline-success btn-action w-50 d-flex align-items-center justify-content-center">
                                <i class="bi bi-whatsapp me-2"></i> Hubungi
                            </a>
                            <a href="<%= request.getContextPath() %>/pelanggan/sejarah-bayaran" class="btn btn-outline-purple btn-action w-50 d-flex align-items-center justify-content-center">
                                <i class="bi bi-receipt me-2"></i> Bayaran
                            </a>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>
        <div id="bookingPagination" class="mt-4"></div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#bookingListContainer",
                itemSelector: ".col-12.col-md-6.col-xxl-4",
                itemsPerPage: 10,
                paginationContainerSelector: "#bookingPagination"
            });
        });
    </script>
</body>
</html>
