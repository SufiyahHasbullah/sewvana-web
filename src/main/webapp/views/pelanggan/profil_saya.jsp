<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    String pageTitle = "Profil Saya";
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String initial = (user != null && user.getNama() != null && !user.getNama().isEmpty()) ? String.valueOf(user.getNama().charAt(0)).toUpperCase() : "P";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <style>
        .profile-avatar-large {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #3D2C5E, #6B4E9B);
            color: #ffffff;
            font-size: 3rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            box-shadow: 0 8px 16px rgba(107, 78, 155, 0.2);
            margin: 0 auto 20px auto;
        }
        .profile-card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            background: #ffffff;
            padding: 40px;
        }
        .form-control-premium {
            border: 2px solid #eaeaea;
            border-radius: 12px;
            padding: 12px 18px;
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
            font-weight: 500;
        }
        .form-control-premium:focus {
            border-color: #6B4E9B;
            box-shadow: 0 0 0 4px rgba(107, 78, 155, 0.15);
            color: #3D2C5E;
        }
        .form-label-premium {
            font-weight: 600;
            color: #3D2C5E;
            margin-bottom: 8px;
        }
        .btn-update {
            background: linear-gradient(135deg, #6B4E9B, #3D2C5E);
            border: none;
            border-radius: 30px;
            padding: 12px 35px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 8px 16px rgba(61, 44, 94, 0.2);
        }
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 20px rgba(61, 44, 94, 0.3);
            background: linear-gradient(135deg, #3D2C5E, #6B4E9B);
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold m-0 heading-warga-emas">Profil <span class="purple-text">Saya</span></h1>
                <p class="text-muted m-0 subtext-warga-emas">Kemas kini maklumat diri anda untuk memudahkan urusan tempahan jahitan.</p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-12 col-lg-8">
                
                <%-- Success/Error Alerts --%>
                <%
                    String success = (String) request.getAttribute("success");
                    String error = (String) request.getAttribute("error");
                    boolean isPassSuccess = "KATA_LALUAN_BERJAYA".equals(success);
                    if (success != null) {
                %>
                    <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm mb-4 p-3" role="alert">
                        <i class="bi bi-check-circle-fill me-2 fs-5"></i> 
                        <strong>Berjaya!</strong> <%= isPassSuccess ? "Kata laluan anda telah berjaya dikemas kini." : success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <% if (isPassSuccess) { %>
                        <script>
                            window.addEventListener('DOMContentLoaded', () => {
                                alert("Pengesahan Keselamatan: Kata laluan akaun anda telah berjaya ditukar!");
                            });
                        </script>
                    <% } %>
                <%
                    }
                    if (error != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show border-0 rounded-3 shadow-sm mb-4 p-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i> <strong>Ralat!</strong> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <%
                    }
                %>

                <div class="card profile-card text-center text-md-start">
                    <div class="row align-items-center">
                        <div class="col-12 col-md-4 text-center border-md-end mb-4 mb-md-0">
                            <div class="profile-avatar-large"><%= initial %></div>
                            <h4 class="fw-bold text-purple-dark m-0"><%= user.getNama() %></h4>
                            <span class="badge bg-purple-pale purple-text px-3 py-2 rounded-pill mt-2 fw-semibold">Pelanggan</span>
                        </div>
                        <div class="col-12 col-md-8 ps-md-5">
                            <form action="<%= request.getContextPath() %>/pelanggan/profil" method="POST">
                                
                                <div class="mb-3">
                                    <label for="nama" class="form-label form-label-premium">Nama Penuh</label>
                                    <input type="text" class="form-control form-control-premium" id="nama" name="nama" value="<%= user.getNama() %>" placeholder="Masukkan nama penuh" required>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label form-label-premium">Alamat Emel</label>
                                    <input type="email" class="form-control form-control-premium bg-light text-muted" id="email" name="email" value="<%= user.getEmail() %>" readonly disabled>
                                    <small class="text-muted d-block mt-1">Alamat emel tidak boleh ditukar kerana bersambung dengan akaun log masuk.</small>
                                </div>

                                <div class="mb-4">
                                    <label for="telefon" class="form-label form-label-premium">No. Telefon Bimbit</label>
                                    <input type="tel" class="form-control form-control-premium" id="telefon" name="telefon" value="<%= user.getTelefon() != null ? user.getTelefon() : "" %>" placeholder="Contoh: 0123456789">
                                </div>

                                <div class="text-end">
                                    <button type="submit" class="btn btn-update text-white w-100 w-md-auto">
                                        <i class="bi bi-save me-2"></i> Simpan Perubahan
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <%-- Card Tukar Password Pelanggan --%>
                <div class="card profile-card mt-4">
                    <h3 class="fw-bold h4 mb-4 text-purple-dark"><i class="bi bi-shield-lock-fill me-2"></i>Tukar Kata Laluan</h3>
                    
                    <form action="<%= request.getContextPath() %>/pelanggan/profil" method="POST" onsubmit="return sahkanTukarPassword(this);">
                        <input type="hidden" name="action" value="tukar_password">
                        
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label form-label-premium">Kata Laluan Semasa</label>
                                <input type="password" class="form-control form-control-premium" name="kataLaluanLama" placeholder="Masukkan kata laluan semasa" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label form-label-premium">Kata Laluan Baharu</label>
                                <input type="password" class="form-control form-control-premium" name="kataLaluanBaru" placeholder="Masukkan kata laluan baharu" required>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label form-label-premium">Sahkan Kata Laluan Baharu</label>
                                <input type="password" class="form-control form-control-premium" name="sahkanKataLaluan" placeholder="Ulang kata laluan baharu" required>
                            </div>
                            <div class="col-12 text-end mt-4">
                                <button type="submit" class="btn btn-update text-white w-100 w-md-auto">
                                    <i class="bi bi-key-fill me-2"></i> Kemaskini Kata Laluan
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
