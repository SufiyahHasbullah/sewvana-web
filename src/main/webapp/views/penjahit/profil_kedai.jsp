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
    String pageTitle = "Profil Kedai";

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    
    String formatPhone = (user.getTelefon() != null) ? user.getTelefon() : "";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/dashboard.css">
    <style>
        .profile-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--sw-border);
        }
        .form-label {
            font-weight: 700;
            color: #4C3C6E;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--sw-primary);
            box-shadow: 0 0 0 0.25rem rgba(107, 78, 155, 0.25);
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>

        <%-- Header --%>
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <div>
                <h1 class="fw-bold text-dark m-0">Profil Kedai Penjahit</h1>
                <p class="text-muted m-0">Kemaskini maklumat diri perniagaan anda dan urus keselamatan akaun.</p>
            </div>
        </div>

        <%-- Mesej Maklum Balas --%>
        <% 
            boolean isPassSuccess = "KATA_LALUAN_BERJAYA".equals(success);
            if (success != null) { 
        %>
            <div class="alert alert-success border-0 shadow-sm p-3 mb-4 rounded-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-check-circle-fill"></i>
                <span class="fs-6 text-dark"><%= isPassSuccess ? "Kata laluan anda telah berjaya dikemas kini." : success %></span>
            </div>
            <% if (isPassSuccess) { %>
                <script>
                    window.addEventListener('DOMContentLoaded', () => {
                        alert("Pengesahan Keselamatan: Kata laluan akaun anda telah berjaya ditukar!");
                    });
                </script>
            <% } %>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-danger border-0 shadow-sm p-3 mb-4 rounded-3 d-flex align-items-center gap-2" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span class="fs-6 text-dark"><%= error %></span>
            </div>
        <% } %>

        <div class="row g-4">
            
            <%-- KIRI: Borang Kemaskini Profil --%>
            <div class="col-12 col-lg-6">
                <div class="profile-card p-4 shadow-sm h-100">
                    <h3 class="fw-bold h4 mb-4 text-dark"><i class="bi bi-person-gear text-purple me-2"></i>Maklumat Profil Kedai</h3>
                    
                    <form action="${pageContext.request.contextPath}/penjahit/profil-kedai" method="POST">
                        
                        <div class="mb-3">
                            <label for="namaKedai" class="form-label">Nama Penjahit / Kedai</label>
                            <input type="text" class="form-control py-2 text-dark" id="namaKedai" name="nama" value="<%= user.getNama() %>" placeholder="Nama kedai..." required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="emailKedai" class="form-label">Alamat E-mel (Log Masuk)</label>
                            <input type="email" class="form-control py-2 text-dark bg-light" id="emailKedai" value="<%= user.getEmail() %>" disabled>
                            <div class="form-text text-muted">E-mel digunakan untuk log masuk akaun dan tidak boleh diubah secara manual.</div>
                        </div>
                        
                        <div class="mb-4">
                            <label for="noTelefon" class="form-label">No. Telefon Hubungan</label>
                            <input type="text" class="form-control py-2 text-dark" id="noTelefon" name="telefon" value="<%= formatPhone %>" placeholder="Contoh: 019XXXXXXXX">
                        </div>
                        
                        <button type="submit" class="btn btn-purple py-2.5 px-4 rounded-3 fw-bold shadow-sm w-100">
                            <i class="bi bi-cloud-arrow-up me-2"></i>Simpan Perubahan Profil
                        </button>
                        
                    </form>
                </div>
            </div>

            <%-- KANAN: Card Tukar Password Kedai --%>
            <div class="col-12 col-lg-6">
                <div class="profile-card p-4 shadow-sm h-100">
                    <h3 class="fw-bold h4 mb-4 text-dark"><i class="bi bi-shield-lock-fill text-purple me-2"></i>Tukar Kata Laluan</h3>
                    
                    <form action="${pageContext.request.contextPath}/penjahit/profil-kedai" method="POST" onsubmit="return sahkanTukarPassword(this);">
                        <input type="hidden" name="action" value="tukar_password">
                        
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Kata Laluan Semasa</label>
                            <input type="password" class="form-control text-dark py-2" name="kataLaluanLama" placeholder="Masukkan kata laluan semasa" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Kata Laluan Baharu</label>
                            <input type="password" class="form-control text-dark py-2" name="kataLaluanBaru" placeholder="Masukkan kata laluan baharu" required>
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label text-secondary small fw-bold">Sahkan Kata Laluan Baharu</label>
                            <input type="password" class="form-control text-dark py-2" name="sahkanKataLaluan" placeholder="Ulang kata laluan baharu" required>
                        </div>
                        
                        <button type="submit" class="btn btn-purple py-2.5 px-4 rounded-3 fw-bold shadow-sm w-100">
                            <i class="bi bi-key-fill me-2"></i> Kemaskini Kata Laluan
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script>
        function sahkanTukarPassword(form) {
            const baru = form.kataLaluanBaru.value;
            const sah = form.sahkanKataLaluan.value;
            if (baru !== sah) {
                alert("Ralat: Kata laluan baharu dan pengesahan tidak sepadan!");
                return false;
            }
            return confirm("Adakah anda pasti mahu menukar kata laluan akaun anda sekarang?");
        }
    </script>
</body>
</html>
