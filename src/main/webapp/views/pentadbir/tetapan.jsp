<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Tetapan Kawalan";
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
                <h1 class="fw-bold m-0 text-warga-emas">Tetapan <span class="purple-text">Sistem</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Kemas kini kata laluan keselamatan admin, konfigurasi operasi sistem, dan data profil.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-light text-dark border p-3 rounded-3 fw-bold fs-6">
                    <i class="bi bi-gear-wide-connected text-success me-2"></i> Konfigurasi HQ
                </span>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-12 col-lg-5">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white mb-4">
                    <h3 class="fw-bold mb-3 text-dark text-warga-emas">
                        <i class="bi bi-person-badge text-indigo me-2"></i> Profil Pentadbir
                    </h3>
                    <div class="d-flex align-items-center gap-3 py-3 border-bottom mb-3">
                        <div class="admin-avatar text-white fw-bold fs-3 rounded-circle d-flex align-items-center justify-content-center" style="width: 70px; height: 70px; background-color: var(--sw-purple);">
                            <%= (user != null && user.getNama() != null) ? String.valueOf(user.getNama().charAt(0)).toUpperCase() : "A" %>
                        </div>
                        <div>
                            <h5 class="fw-bold m-0 text-dark"><%= (user != null) ? user.getNama() : "Admin" %></h5>
                            <span class="badge bg-danger rounded-pill px-3 py-1">Super Admin</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="text-muted small fw-bold text-uppercase d-block mb-1">E-mel Pentadbir</label>
                        <span class="fw-medium text-dark"><%= (user != null) ? user.getEmail() : "-" %></span>
                    </div>
                    <div class="mb-3">
                        <label class="text-muted small fw-bold text-uppercase d-block mb-1">No. Telefon</label>
                        <span class="fw-medium text-dark"><%= (user != null && user.getTelefon() != null && !user.getTelefon().isEmpty()) ? user.getTelefon() : "-" %></span>
                    </div>
                </div>
            </div>

            <div class="col-12 col-lg-7">
                <div class="card border-0 p-4 shadow-sm rounded-4 bg-white">
                    <h3 class="fw-bold mb-4 text-dark text-warga-emas">
                        <i class="bi bi-shield-lock-fill text-indigo me-2"></i> Pintu Keselamatan & Tukar Kata Laluan
                    </h3>

                    <%
                        String error = (String) request.getAttribute("error");
                        String success = (String) request.getAttribute("success");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Ralat!</strong> <%= error %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <%
                        }
                        if (success != null) {
                    %>
                        <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> <strong>Berjaya!</strong> <%= success %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <%
                        }
                    %>

                    <form id="formTukarKataLaluan" action="${pageContext.request.contextPath}/admin/tetapan-sistem" method="POST">
                        <input type="hidden" name="action" value="ubahPassword">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Kata Laluan Semasa</label>
                            <input type="password" class="form-control rounded-3" name="kataLaluanLama" required placeholder="Masukkan kata laluan semasa">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-dark">Kata Laluan Baharu</label>
                            <input type="password" class="form-control rounded-3" id="kataLaluanBaru" name="kataLaluanBaru" required placeholder="Masukkan kata laluan baharu">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-dark">Sahkan Kata Laluan Baharu</label>
                            <input type="password" class="form-control rounded-3" id="sahkanKataLaluan" required placeholder="Sahkan kata laluan baharu">
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn btn-purple px-4 rounded-pill fw-bold">
                                <i class="bi bi-save-fill me-2"></i> Kemas Kini Kata Laluan
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Custom Modal/Dialog Pengesahan Tukar Kata Laluan -->
    <div class="modal fade" id="modalPengesahan" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-purple text-white rounded-top-4 py-3">
                    <h5 class="modal-title fw-bold" id="modalLabel"><i class="bi bi-shield-fill-check me-2"></i> Pengesahan Profil</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4 text-center">
                    <i class="bi bi-exclamation-circle-fill text-warning display-4 mb-3 d-block"></i>
                    <p class="fs-5 fw-medium text-dark m-0">Adakah anda benar-benar pasti untuk menukar kata laluan pentadbir anda?</p>
                </div>
                <div class="modal-footer border-0 pb-4 justify-content-center">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Batal</button>
                    <button type="button" id="btnSahkanHantar" class="btn btn-purple rounded-pill px-4 fw-bold">Ya, Tukar Sekarang</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const form = document.getElementById("formTukarKataLaluan");
            const pwdBaru = document.getElementById("kataLaluanBaru");
            const pwdSahkan = document.getElementById("sahkanKataLaluan");
            
            // Bootstrap Modal Instance
            const myModal = new bootstrap.Modal(document.getElementById('modalPengesahan'), {
                keyboard: false
            });

            form.addEventListener("submit", function(event) {
                event.preventDefault(); // Batalkan hantar sementara

                // Validasi ringkas
                if (pwdBaru.value !== pwdSahkan.value) {
                    alert("Sila pastikan kata laluan baharu dan sahkan kata laluan sepadan.");
                    return;
                }

                // Tunjukkan confirmation modal
                myModal.show();
            });

            // Tindakan butang "Ya, Tukar Sekarang" di dalam modal
            document.getElementById("btnSahkanHantar").addEventListener("click", function() {
                myModal.hide();
                form.submit(); // Hantar form secara fizikal
            });
        });
    </script>
</body>
</html>
