<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String pageTitle = "Log Masuk";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <%-- Google Identity Services --%>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth.css">
    <style>
        /* Login specific — centered card layout */
        body { background: var(--sw-bg); display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 1.5rem 1rem; }
        .sw-login-card {
            background: var(--sw-surface);
            border-radius: var(--sw-radius-card);
            box-shadow: var(--sw-shadow-md);
            padding: 2.5rem 2.25rem;
            width: 100%;
            max-width: 440px;
            border: 1px solid var(--sw-border);
        }
        .brand-icon {
            width: 64px; height: 64px;
            border-radius: var(--sw-radius-card);
            background: linear-gradient(135deg, var(--sw-primary-light), var(--sw-primary));
            display: flex; align-items: center; justify-content: center;
            font-size: 1.75rem; color: white;
            margin: 0 auto 1rem;
            box-shadow: var(--sw-shadow-primary);
        }
        .brand-title { font-size: 1.5rem; font-weight: 700; color: var(--sw-text); }
        .purple-link { color: var(--sw-primary); font-weight: 600; }
        .purple-link:hover { color: var(--sw-primary-dark); }
        .input-group-text { background: var(--sw-primary-pale); color: var(--sw-primary); border-color: var(--sw-border); }
        .form-control { border-color: var(--sw-border); }
        .divider { display: flex; align-items: center; gap: 0.75rem; color: var(--sw-text-muted); font-size: 0.8rem; }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--sw-border); }
        
        @media (max-width: 575.98px) {
            body { padding: 1rem 0.5rem; }
            .sw-login-card {
                padding: 1.75rem 1.25rem;
                border-radius: var(--sw-radius);
            }
            .brand-title { font-size: 1.35rem; }
        }
    </style>
</head>
<body>
    <div class="sw-login-card sw-animate-up">

        <%-- Brand --%>
        <div class="text-center mb-4">
            <div class="brand-icon"><i class="bi bi-scissors"></i></div>
            <h3 class="brand-title mb-1">Sewvana</h3>
            <p class="text-muted small">Selamat kembali! Sila log masuk ke akaun anda</p>
        </div>

        <%-- Flash: Success (selepas daftar) --%>
        <% if (session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success d-flex align-items-center gap-2 py-2 small" role="alert">
                <i class="bi bi-check-circle-fill"></i>
                <%= session.getAttribute("successMessage") %>
                <% session.removeAttribute("successMessage"); %>
            </div>
        <% } %>

        <%-- Flash: Error dari Servlet --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert" id="errorAlert">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <%-- Error dinamik JS --%>
        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small d-none" role="alert" id="clientErrorAlert">
            <i class="bi bi-exclamation-triangle-fill"></i> <span id="clientErrorMsg"></span>
        </div>

        <%-- Borang Log Masuk --%>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" id="loginForm">

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
                    <input type="password" name="password" id="password" class="form-control" placeholder="Masukkan kata laluan" required>
                    <button type="button" class="btn btn-outline-secondary border-start-0" id="togglePassword" style="border-color: var(--sw-border);">
                        <i class="bi bi-eye" id="eyeIcon"></i>
                    </button>
                </div>
            </div>

            <div class="mb-4 form-check">
                <input type="checkbox" name="remember" class="form-check-input" id="remember">
                <label class="form-check-label small text-muted fw-semibold" for="remember">Ingat saya di komputer ini</label>
            </div>

            <button type="submit" class="btn-sw-primary w-100 mb-3" id="btnLogin">
                <i class="bi bi-box-arrow-in-right"></i> Log Masuk
            </button>

            <div class="divider my-3">atau masuk dengan</div>

            <%-- Google Sign-In --%>
            <div class="d-flex justify-content-center mb-3">
                <div id="g_id_onload"
                     data-client_id="366021549310-e8242vrh6mgl5a28h4hg3h0ag00etr7d.apps.googleusercontent.com"
                     data-context="signin" data-ux_mode="popup"
                     data-callback="handleGoogleCredentialResponse"
                     data-auto_prompt="false">
                </div>
                <div class="g_id_signin" data-type="standard" data-shape="pill"
                     data-theme="outline" data-text="signin_with"
                     data-size="large" data-logo_alignment="left" data-width="320">
                </div>
            </div>
        </form>

        <div class="text-center mt-3 small">
            <p class="mb-1 text-muted">Belum mempunyai akaun?
                <a href="${pageContext.request.contextPath}/views/register.jsp" class="purple-link">Daftar Sekarang</a>
            </p>
            <a href="${pageContext.request.contextPath}/" class="text-muted">
                <i class="bi bi-arrow-left me-1"></i> Kembali ke Utama
            </a>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword').addEventListener('click', function() {
            var pwd = document.getElementById('password');
            var icon = document.getElementById('eyeIcon');
            if (pwd.type === 'password') {
                pwd.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                pwd.type = 'password';
                icon.className = 'bi bi-eye';
            }
        });
    </script>
</body>
</html>