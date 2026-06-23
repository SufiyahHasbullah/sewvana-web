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
    String pageTitle = "Urus Servis";

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/service.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">

        <%-- Header --%>
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <div>
                <h1 class="fw-bold text-dark m-0">Urus Perkhidmatan & Servis</h1>
                <p class="text-muted m-0">Tambah, kemaskini, atau padam perkhidmatan jahitan yang anda tawarkan kepada pelanggan.</p>
            </div>
        </div>

        <%-- Mesej Maklum Balas --%>
        <% if (success != null) { %>
            <div class="alert alert-success border-0 shadow-sm p-3 mb-4 rounded-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill"></i>
                <span class="fs-6 text-dark"><%= success %></span>
            </div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-danger border-0 shadow-sm p-3 mb-4 rounded-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span class="fs-6 text-dark"><%= error %></span>
            </div>
        <% } %>

        <div class="row justify-content-center">
            <div class="col-12 col-xl-10">
                <div class="services-card p-4 shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                        <h3 class="fw-bold h4 m-0 text-dark">
                            <i class="bi bi-scissors text-purple me-2"></i>Senarai Servis Ditawarkan
                        </h3>
                        <button type="button" class="btn btn-purple fw-bold px-4 py-2 rounded-pill shadow-sm" onclick="bukaModalTambahServis()">
                            <i class="bi bi-plus-lg me-1"></i> Tambah Servis Baharu
                        </button>
                    </div>

                    <div class="row g-3" id="serviceListContainer">
                        <%
                            List<Map<String, Object>> senarai = (List<Map<String, Object>>) request.getAttribute("senaraiServis");
                            if (senarai == null || senarai.isEmpty()) {
                        %>
                            <div class="col-12 text-center py-5">
                                <i class="bi bi-scissors display-3 text-muted mb-3 d-block opacity-40"></i>
                                <p class="text-muted fs-5">Tiada servis aktif didaftarkan untuk akaun kedai anda.</p>
                                <button type="button" class="btn btn-outline-purple fw-bold px-4 py-2 mt-2 rounded-pill" onclick="bukaModalTambahServis()">
                                    Mula Tambah Servis Pertama Anda
                                </button>
                            </div>
                        <%
                            } else {
                                for (Map<String, Object> servis : senarai) {
                                    String desc = (String) servis.get("KETERANGAN");
                        %>
                            <div class="col-12 service-row">
                                <div class="service-item p-3.5 d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center" style="max-width: 65%;">
                                        <div class="bg-purple bg-opacity-10 text-purple p-3 rounded-3 me-3">
                                            <i class="bi bi-check2-circle fs-4"></i>
                                        </div>
                                        <div>
                                            <strong class="text-dark d-block fs-5 text-truncate" style="font-weight:700;"><%= servis.get("nama_servis") %></strong>
                                            <% if (desc != null && !desc.trim().isEmpty()) { %>
                                                <span class="text-muted d-block text-truncate mt-1" style="font-size:0.875rem; max-width: 450px;"><%= desc %></span>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <span class="service-price fs-4 me-4">RM <%= String.format("%.2f", (Double)servis.get("harga_upah")) %></span>
                                        <button class="btn btn-outline-primary me-2 rounded-3 px-3 py-2 btn-sm fw-bold" onclick="bukaModalEditServis(<%= servis.get("id") %>, '<%= ((String)servis.get("nama_servis")).replace("'", "\\'") %>', <%= servis.get("harga_upah") %>, '<%= (desc != null) ? desc.replace("'", "\\'") : "" %>')">
                                            <i class="bi bi-pencil-fill me-1"></i> Edit
                                        </button>
                                        <button class="btn btn-outline-danger rounded-3 px-3 py-2 btn-sm fw-bold" onclick="sahkanPadamServis(<%= servis.get("id") %>, '<%= ((String)servis.get("nama_servis")).replace("'", "\\'") %>')">
                                            <i class="bi bi-trash-fill me-1"></i> Padam
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <%
                                }
                            }
                        %>
                    </div>
                    <div id="servicePagination" class="mt-4"></div>
                </div>
            </div>
        </div>

    </div>

    <div class="modal fade" id="modalTambahServis" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-purple text-white rounded-top-4 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-scissors me-2"></i>Tambah Servis Baru</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Tutup"></button>
                </div>
                <form action="${pageContext.request.contextPath}/penjahit/servis" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="tambah">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary small">Nama Servis</label>
                            <input type="text" class="form-control text-dark py-2" name="namaServis" placeholder="Contoh: Baju Kurung Moden" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary small">Harga Upah Jahit (RM)</label>
                            <input type="number" step="0.01" class="form-control text-dark py-2" name="hargaUpah" placeholder="Contoh: 120.00" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label fw-bold text-secondary small">Keterangan / Deskripsi Servis</label>
                            <textarea class="form-control text-dark py-2" name="keterangan" rows="3" placeholder="Terangkan perincian ringkas mengenai servis ini..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 bg-light rounded-bottom-4">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-3" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-purple px-4 rounded-3 shadow-sm fw-bold">Tambah Servis</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditServis" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-purple text-white rounded-top-4 py-3">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-fill me-2"></i>Kemaskini Servis</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Tutup"></button>
                </div>
                <form action="${pageContext.request.contextPath}/penjahit/servis" method="POST">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="kemaskini">
                        <input type="hidden" id="editServiceId" name="serviceId">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary small">Nama Servis</label>
                            <input type="text" class="form-control text-dark py-2" id="editNamaServis" name="namaServis" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary small">Harga Upah Jahit (RM)</label>
                            <input type="number" step="0.01" class="form-control text-dark py-2" id="editHargaUpah" name="hargaUpah" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label fw-bold text-secondary small">Keterangan / Deskripsi Servis</label>
                            <textarea class="form-control text-dark py-2" id="editKeterangan" name="keterangan" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 bg-light rounded-bottom-4">
                        <button type="button" class="btn btn-outline-secondary px-4 rounded-3" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-purple px-4 rounded-3 shadow-sm fw-bold">Simpan Kemaskini</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <form id="formPadamServis" action="${pageContext.request.contextPath}/penjahit/servis" method="POST" style="display:none;">
        <input type="hidden" name="action" value="padam">
        <input type="hidden" id="padamServiceId" name="serviceId">
    </form>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/service.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            window.initPagination({
                containerSelector: "#serviceListContainer",
                itemSelector: ".service-row",
                itemsPerPage: 10,
                paginationContainerSelector: "#servicePagination"
            });
        });
    </script>

</body>
</html>
