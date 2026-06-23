<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    String pageTitle = "Gerbang Pembayaran";
    String idTempahan = request.getParameter("tempahanSlotId");
    if (idTempahan == null) idTempahan = "1";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/pembayaran.css">
</head>
<body class="bg-soft-lavender">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card card-premium shadow border-0 p-4 rounded-4 bg-white">
                <div class="text-center mb-4">
                    <h2 class="fw-bold purple-text m-0">Sahkan Bayaran</h2>
                    <p class="text-muted small">Pilih pelan cagaran atau bayaran penuh baju anda</p>
                </div>

                <form action="<%= request.getContextPath() %>/pembayaran/proses" method="POST" id="formSahkanBayar">
                    <input type="hidden" name="tempahanSlotId" value="<%= idTempahan %>">

                    <!-- Bahagian Pelan Bayaran (Mesra Penglihatan Warga Emas) -->
                    <label class="fw-bold text-dark mb-2 fs-5">1. Jenis Pilihan Bayaran</label>
                    <div class="row g-3 mb-4">
                        <div class="col-6">
                            <input type="radio" class="btn-check" name="jenisBayaran" id="payDeposit" value="DEPOSIT" checked onclick="tukarHarga('30.00')">
                            <label class="btn btn-outline-purple w-100 py-3 rounded-3 fw-bold fs-5" for="payDeposit">
                                <i class="bi bi-shield-lock d-block fs-3 mb-1"></i> Deposit (RM 30)
                            </label>
                        </div>
                        <div class="col-6">
                            <input type="radio" class="btn-check" name="jenisBayaran" id="payFull" value="BAYARAN_PENH" onclick="tukarHarga('120.00')">
                            <label class="btn btn-outline-purple w-100 py-3 rounded-3 fw-bold fs-5" for="payFull">
                                <i class="bi bi-wallet2 d-block fs-3 mb-1"></i> Penuh (RM 120)
                            </label>
                        </div>
                    </div>

                    <!-- Input Nilai Tersembunyi Dinamik -->
                    <input type="hidden" name="jumlahBayaran" id="txtJumlah" value="30.00">

                    <!-- Kaedah Bayaran -->
                    <label class="fw-bold text-dark mb-2 fs-5">2. Saluran Pembayaran Elektronik</label>
                    <div class="form-check card-kaedah p-3 mb-2 border rounded-3 d-flex align-items-center">
                        <input class="form-check-input ms-1 me-3" type="radio" name="kaedahBayaran" id="fpx" value="FPX" checked>
                        <label class="form-check-label fw-semibold fs-5 w-100" for="fpx">
                            <i class="bi bi-bank purple-text me-2"></i> Perbankan Internet FPX
                        </label>
                    </div>

                    <div class="form-check card-kaedah p-3 mb-4 border rounded-3 d-flex align-items-center">
                        <input class="form-check-input ms-1 me-3" type="radio" name="kaedahBayaran" id="kad" value="KAD_KREDIT">
                        <label class="form-check-label fw-semibold fs-5 w-100" for="kad">
                            <i class="bi bi-credit-card-2-front purple-text me-2"></i> Kad Kredit / Debit
                        </label>
                    </div>

                    <!-- Rumusan Jumlah Amaun -->
                    <div class="p-3 bg-light rounded-3 mb-4 text-center border">
                        <span class="text-muted d-block uppercase fw-bold small">Jumlah Perlu Dibayar Sekarang</span>
                        <h1 class="display-5 fw-bold purple-text m-0" id="labelBesarHarga">RM 30.00</h1>
                    </div>

                    <!-- Butang Serahan Besar -->
                    <button type="submit" class="btn btn-purple-grand w-100 py-3 rounded-pill shadow-lg text-white fw-bold fs-4">
                        <i class="bi bi-lock-fill me-2"></i> Bayar Sekarang Securely
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function tukarHarga(amaun) {
        document.getElementById('txtJumlah').value = amaun;
        document.getElementById('labelBesarHarga').innerText = "RM " + parseFloat(amaun).toFixed(2);
    }
</script>
</body>
</html>