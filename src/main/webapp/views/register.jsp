<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String pageTitle = "Daftar Akaun";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth.css">
    <style>
        body { background: var(--sw-bg); display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 2rem 1rem; }
        .sw-register-card {
            background: var(--sw-surface);
            border-radius: var(--sw-radius-card);
            box-shadow: var(--sw-shadow-md);
            padding: 2.25rem 2.25rem;
            width: 100%;
            max-width: 480px;
            border: 1px solid var(--sw-border);
        }
        .brand-icon {
            width: 60px; height: 60px;
            border-radius: var(--sw-radius-card);
            background: linear-gradient(135deg, var(--sw-primary-light), var(--sw-primary));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem; color: white;
            margin: 0 auto 1rem;
            box-shadow: var(--sw-shadow-primary);
        }
        .brand-title { font-size: 1.4rem; font-weight: 700; color: var(--sw-text); }
        .purple-link { color: var(--sw-primary); font-weight: 600; }
        .purple-link:hover { color: var(--sw-primary-dark); }
        .input-group-text { background: var(--sw-primary-pale); color: var(--sw-primary); border-color: var(--sw-border); }
        .form-control, .form-select { border-color: var(--sw-border); }
        .divider { display: flex; align-items: center; gap: 0.75rem; color: var(--sw-text-muted); font-size: 0.8rem; }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--sw-border); }
    </style>
</head>
<body>
    <div class="sw-register-card sw-animate-up">

        <div class="text-center mb-4">
            <div class="brand-icon"><i class="bi bi-scissors"></i></div>
            <h3 class="brand-title mb-1">Sewvana</h3>
            <p class="text-muted small">Cipta akaun baharu anda hari ini</p>
        </div>

        <%-- Error dari Servlet --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert" id="errorAlert">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <%-- Error dinamik JS --%>
        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small d-none" role="alert" id="clientErrorAlert">
            <i class="bi bi-exclamation-triangle-fill"></i> <span id="clientErrorMsg"></span>
        </div>

        <form action="${pageContext.request.contextPath}/RegisterServlet" method="POST" id="registerForm">

            <div class="mb-3">
                <label class="form-label" for="nama">Nama Penuh</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                    <input type="text" name="nama" id="nama" class="form-control" placeholder="Masukkan nama penuh" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="email">Alamat Emel</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope-fill"></i></span>
                    <input type="email" name="email" id="email" class="form-control" placeholder="contoh@emel.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="password">Kata Laluan</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" name="password" id="password" class="form-control" placeholder="Minimum 6 aksara" required>
                    <button type="button" class="btn btn-outline-secondary border-start-0" id="togglePwd" style="border-color: var(--sw-border);">
                        <i class="bi bi-eye" id="eyePwd"></i>
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="confirmPassword">Sahkan Kata Laluan</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-shield-lock-fill"></i></span>
                    <input type="password" id="confirmPassword" class="form-control" placeholder="Ulang kata laluan asal" required>
                </div>
                <div class="invalid-feedback" id="pwdMismatch">Kata laluan tidak sepadan.</div>
            </div>

            <div class="mb-4">
                <label class="form-label" for="role">Jenis Pengguna (Peranan)</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-badge-fill"></i></span>
                    <select name="role" id="role" class="form-select" required>
                        <option value="" disabled selected>-- Pilih Peranan Anda --</option>
                        <option value="pelanggan">Pelanggan (Ingin menempah pakaian)</option>
                        <option value="penjahit">Penjahit / Tailor (Ingin menerima tempahan)</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-sw-primary w-100 mb-3" id="btnRegister">
                <i class="bi bi-person-plus-fill"></i> Daftar Akaun
            </button>

            <div class="divider my-3">atau daftar dengan</div>

            <div class="d-flex justify-content-center mb-3">
                <div id="g_id_onload"
                     data-client_id="366021549310-e8242vrh6mgl5a28h4hg3h0ag00etr7d.apps.googleusercontent.com"
                     data-context="signup" data-ux_mode="popup"
                     data-callback="handleGoogleCredentialResponse"
                     data-auto_prompt="false">
                </div>
                <div class="g_id_signin" data-type="standard" data-shape="pill"
                     data-theme="outline" data-text="signup_with"
                     data-size="large" data-logo_alignment="left" data-width="320">
                </div>
            </div>
        </form>

        <div class="text-center mt-3 small">
            <p class="mb-1 text-muted">Sudah mempunyai akaun?
                <a href="login.jsp" class="purple-link">Log Masuk</a>
            </p>
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-muted">
                <i class="bi bi-arrow-left me-1"></i> Kembali ke Utama
            </a>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
    <script>
        // Toggle password
        document.getElementById('togglePwd').addEventListener('click', function() {
            var pwd = document.getElementById('password');
            var icon = document.getElementById('eyePwd');
            pwd.type = pwd.type === 'password' ? 'text' : 'password';
            icon.className = pwd.type === 'password' ? 'bi bi-eye' : 'bi bi-eye-slash';
        });
        // Confirm password match
        document.getElementById('confirmPassword').addEventListener('input', function() {
            var match = this.value === document.getElementById('password').value;
            this.classList.toggle('is-invalid', !match && this.value.length > 0);
            this.classList.toggle('is-valid', match && this.value.length > 0);
        });
    </script>
</body>
</html>