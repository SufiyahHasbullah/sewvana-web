<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%@ page import="com.sewvana.model.UkuranPelanggan" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    Boolean isPenjahitViewObj = (Boolean) request.getAttribute("isPenjahitView");
    boolean isPenjahitView = (isPenjahitViewObj != null && isPenjahitViewObj);
    
    UkuranPelanggan ukuran = (UkuranPelanggan) request.getAttribute("ukuran");
    if (ukuran == null) ukuran = new UkuranPelanggan(); // empty object

    Integer targetPelangganId = (Integer) request.getAttribute("targetPelangganId");
    String namaPelanggan = (String) request.getAttribute("namaPelanggan");
    
    String pageTitle = isPenjahitView ? "Ukuran: " + namaPelanggan : "Ukuran Badan Saya";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ukuran.css">
</head>
<body class="bg-soft-lavender">

    <% if (isPenjahitView) { %>
        <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>
    <% } else { %>
        <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>
    <% } %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>

        <%-- Flash Messages --%>
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("berjaya".equals(success)) {
        %>
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Berjaya!</strong> Rekod ukuran badan telah berjaya disimpan.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if (error != null) { 
                String errorMsg = "gagal_simpan".equals(error) ? "Gagal menyimpan rekod ukuran. Sila cuba lagi." 
                                : "kata_laluan_salah".equals(error) ? "Kata laluan pengesahan tidak tepat!" 
                                : "Ralat tidak diketahui.";
        %>
            <div class="alert alert-danger alert-dismissible fade show border-0 rounded-3 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Ralat!</strong> <%= errorMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (isPenjahitView) { %>
            <div class="tailor-access-banner shadow-sm">
                <i class="bi bi-person-lines-fill banner-icon"></i>
                <div>
                    <h5 class="mb-1 fw-bold">Profil Ukuran: <%= namaPelanggan %></h5>
                    <p class="mb-0 text-white-50 small">Anda sedang melihat/mengemas kini ukuran pelanggan berdasarkan tempahan aktif.</p>
                </div>
                <a href="${pageContext.request.contextPath}/penjahit/pesanan" class="btn btn-outline-light btn-sm ms-auto px-3 rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i> Kembali ke Pesanan
                </a>
            </div>
        <% } else { %>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="fw-bold m-0 heading-warga-emas">Ukuran <span class="purple-text">Badan</span></h1>
                    <p class="text-muted m-0 subtext-warga-emas">Simpan ukuran anda sekali sahaja, guna berkali-kali untuk setiap tempahan.</p>
                </div>
                <a href="${pageContext.request.contextPath}/pelanggan/profil" class="btn btn-outline-purple px-4 rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i> Kembali Profil
                </a>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- Left Col: Form -->
            <div class="col-12 col-xl-8">
                
                <% if (ukuran.getTarikhKemaskini() != null) { %>
                    <div class="ukuran-last-update mb-4 shadow-sm">
                        <i class="bi bi-clock-history"></i>
                        <span>Kemas kini terakhir: <strong><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(ukuran.getTarikhKemaskini()) %></strong></span>
                        <span class="ms-auto badge-who">Oleh: <%= ukuran.getNamaPengemaSkini() != null ? ukuran.getNamaPengemaSkini() : ukuran.getDikemasKiniOleh() %></span>
                    </div>
                <% } %>

                <form id="formUkuran" action="${pageContext.request.contextPath}<%= isPenjahitView ? "/penjahit/ukuran-pelanggan" : "/pelanggan/ukuran" %>" method="POST">
                    
                    <input type="hidden" name="pelangganId" value="<%= targetPelangganId %>">
                    <input type="hidden" name="kataLaluan" id="hiddenKataLaluan" value="">

                    <!-- Seksyen: Bahagian Badan Utama -->
                    <div class="ukuran-section-card">
                        <div class="ukuran-section-title">
                            <i class="bi bi-person-bounding-box"></i> Bahagian Badan Utama
                        </div>
                        <div class="row g-3">
                            <div class="col-6 col-md-3">
                                <div class="ukuran-input-group">
                                    <label for="bahu">Bahu <i class="bi bi-question-circle help-icon" title="Lebar dari hujung bahu kiri ke kanan"></i></label>
                                    <input type="number" step="0.1" name="bahu" id="bahu" class="ukuran-input-field" value="<%= ukuran.getBahu() != null ? ukuran.getBahu() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="ukuran-input-group">
                                    <label for="dada">Dada <i class="bi bi-question-circle help-icon" title="Lilitan paling penuh di bahagian dada"></i></label>
                                    <input type="number" step="0.1" name="dada" id="dada" class="ukuran-input-field" value="<%= ukuran.getDada() != null ? ukuran.getDada() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="ukuran-input-group">
                                    <label for="pinggang">Pinggang <i class="bi bi-question-circle help-icon" title="Lilitan bahagian paling ramping"></i></label>
                                    <input type="number" step="0.1" name="pinggang" id="pinggang" class="ukuran-input-field" value="<%= ukuran.getPinggang() != null ? ukuran.getPinggang() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-3">
                                <div class="ukuran-input-group">
                                    <label for="pinggul">Pinggul <i class="bi bi-question-circle help-icon" title="Lilitan pinggul paling penuh"></i></label>
                                    <input type="number" step="0.1" name="pinggul" id="pinggul" class="ukuran-input-field" value="<%= ukuran.getPinggul() != null ? ukuran.getPinggul() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Seksyen: Kepanjangan -->
                    <div class="ukuran-section-card">
                        <div class="ukuran-section-title">
                            <i class="bi bi-rulers"></i> Bahagian Kepanjangan & Lengan
                        </div>
                        <div class="row g-3">
                            <div class="col-12 col-md-4">
                                <div class="ukuran-input-group">
                                    <label for="panjangBaju">Panjang Baju</label>
                                    <input type="number" step="0.1" name="panjangBaju" id="panjangBaju" class="ukuran-input-field" value="<%= ukuran.getPanjangBaju() != null ? ukuran.getPanjangBaju() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-12 col-md-4">
                                <div class="ukuran-input-group">
                                    <label for="panjangLengan">Panjang Lengan</label>
                                    <input type="number" step="0.1" name="panjangLengan" id="panjangLengan" class="ukuran-input-field" value="<%= ukuran.getPanjangLengan() != null ? ukuran.getPanjangLengan() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-12 col-md-4">
                                <div class="ukuran-input-group">
                                    <label for="panjangSeluar">Panjang Seluar/Kain</label>
                                    <input type="number" step="0.1" name="panjangSeluar" id="panjangSeluar" class="ukuran-input-field" value="<%= ukuran.getPanjangSeluar() != null ? ukuran.getPanjangSeluar() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-6 mt-4">
                                <div class="ukuran-input-group">
                                    <label for="ukuranLeher">Lilitan Leher</label>
                                    <input type="number" step="0.1" name="ukuranLeher" id="ukuranLeher" class="ukuran-input-field" value="<%= ukuran.getUkuranLeher() != null ? ukuran.getUkuranLeher() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                            <div class="col-6 col-md-6 mt-4">
                                <div class="ukuran-input-group">
                                    <label for="ukuranLenganAtas">Lilitan Lengan Atas (Bicep)</label>
                                    <input type="number" step="0.1" name="ukuranLenganAtas" id="ukuranLenganAtas" class="ukuran-input-field" value="<%= ukuran.getUkuranLenganAtas() != null ? ukuran.getUkuranLenganAtas() : "" %>">
                                    <span class="ukuran-unit">CM</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Seksyen: Catatan Tambahan -->
                    <div class="ukuran-section-card">
                        <div class="ukuran-section-title">
                            <i class="bi bi-pencil-square"></i> Catatan Khusus
                        </div>
                        <div class="ukuran-input-group">
                            <textarea name="catatanUkuran" id="catatanUkuran" class="form-control" rows="3" placeholder="Contoh: Suka potongan longgar sikit dekat perut, bahu jenis jatuh..." style="border: 2px solid #eaeaea; border-radius: 12px; resize: none;"><%= ukuran.getCatatanUkuran() != null ? ukuran.getCatatanUkuran() : "" %></textarea>
                        </div>
                    </div>

                    <div class="text-end mb-5">
                        <button type="button" class="btn-simpan-ukuran" onclick="bukaModalPengesahan()">
                            <i class="bi bi-save"></i> Simpan Ukuran
                        </button>
                    </div>

                </form>
            </div>

            <!-- Right Col: Visual Aid -->
            <div class="col-12 col-xl-4 d-none d-xl-block">
                <div class="ukuran-hero h-100 d-flex flex-column justify-content-center text-center">
                    <i class="bi bi-scissors hero-icon mb-4"></i>
                    <h3 class="hero-title">Ketepatan Jahitan</h3>
                    <p class="text-white-50 px-3">
                        Ukuran yang tepat memastikan potongan fabrik sempurna untuk setiap rekaan. 
                        Pastikan ukuran diambil dengan pita pengukur yang tegang tetapi selesa.
                    </p>
                    <div class="mt-4 pt-4 border-top border-light border-opacity-10">
                        <p class="small text-white-50 mb-1"><i class="bi bi-shield-check me-1"></i> Data Selamat</p>
                        <p class="small text-white-50">Pengesahan kata laluan diperlukan untuk sebarang perubahan.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Pengesahan Kata Laluan -->
    <div class="modal fade modal-ukuran" id="modalPengesahan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Pengesahan Keselamatan</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="bi bi-shield-lock security-icon"></i>
                    <p class="mb-4 text-muted">Untuk keselamatan data ukuran <%= isPenjahitView ? "pelanggan" : "anda" %>, sila masukkan kata laluan <strong>akaun anda</strong> untuk meneruskan proses kemas kini.</p>
                    
                    <div class="mb-4 text-start">
                        <input type="password" class="form-control pw-input" id="inputModalPassword" placeholder="Masukkan kata laluan...">
                        <div class="invalid-feedback" id="pwError">Sila masukkan kata laluan.</div>
                    </div>
                    
                    <button type="button" class="btn btn-confirm" onclick="sahkanDanHantar()">
                        <i class="bi bi-check2-circle me-2"></i> Sahkan & Simpan
                    </button>
                </div>
            </div>
        </div>
    </div>

    <% if (isPenjahitView) { %>
        <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <% } else { %>
        <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>
    <% } %>
    
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    
    <script>
        // Check form inputs style
        document.querySelectorAll('.ukuran-input-field').forEach(input => {
            if(input.value.trim() !== '') input.classList.add('has-value');
            input.addEventListener('input', function() {
                if(this.value.trim() !== '') this.classList.add('has-value');
                else this.classList.remove('has-value');
            });
        });

        const modal = new bootstrap.Modal(document.getElementById('modalPengesahan'));
        const formUkuran = document.getElementById('formUkuran');
        const hiddenPw = document.getElementById('hiddenKataLaluan');
        const inputPw = document.getElementById('inputModalPassword');

        function bukaModalPengesahan() {
            inputPw.value = '';
            inputPw.classList.remove('is-invalid');
            modal.show();
            setTimeout(() => inputPw.focus(), 500);
        }

        function sahkanDanHantar() {
            if (inputPw.value.trim() === '') {
                inputPw.classList.add('is-invalid');
                return;
            }
            hiddenPw.value = inputPw.value;
            modal.hide();
            
            // Show loading state
            const btn = document.querySelector('.btn-simpan-ukuran');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Menyimpan...';
            btn.disabled = true;
            
            formUkuran.submit();
        }

        inputPw.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                sahkanDanHantar();
            }
        });
    </script>
</body>
</html>
