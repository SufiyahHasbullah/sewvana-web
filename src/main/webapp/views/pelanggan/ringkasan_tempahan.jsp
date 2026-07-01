<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Ringkasan Tempahan";

    String tailorId = (String) request.getAttribute("tailorId");
    String tarikhSlot = (String) request.getAttribute("tarikhSlot");
    String kaedahUkuran = (String) request.getAttribute("kaedahUkuran");
    String masaSesiUkur = (String) request.getAttribute("masaSesiUkur");
    String kaedahPembayaran = (String) request.getAttribute("kaedahPembayaran");
    String jenisKomitmen = (String) request.getAttribute("jenisKomitmen");
    String jsonItemTempahan = (String) request.getAttribute("jsonItemTempahan");

    String formatKaedah = "Gunakan Ukuran Sedia Ada";
    if("DATANG_UKUR_BADAN".equals(kaedahUkuran)) {
        formatKaedah = "Temujanji Sesi Ukur Badan (Hadir Ke Kedai)";
    } else if("HANTAR_SENDIRI".equals(kaedahUkuran)) {
        formatKaedah = "Isi & Hantar Ukuran Manual Kemudian";
    }
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tempah_slot.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ringkasan_tempahan.css">
</head>
<body>

    <input type="hidden" id="rawJsonData" value='<%= jsonItemTempahan != null ? jsonItemTempahan : "[]" %>'>
    <input type="hidden" id="pilihanKaedahBayarAwal" value="<%= kaedahPembayaran %>">
    <input type="hidden" id="pilihanKomitmenAwal" value="<%= jenisKomitmen %>">

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>
        <div class="content-header mb-4">
            <h1 class="fw-bold m-0 main-title">Semakan Ringkasan Tempahan</h1>
            <p class="text-muted m-0 sub-title text-large">Langkah 3: Sila semak perincian invois multi-service dan tentukan komitmen bayaran.</p>
        </div>

        <form id="formCheckoutUtama" action="${pageContext.request.contextPath}/pelanggan/pembayaran" method="POST">
            <input type="hidden" name="tailorId" value="<%= tailorId %>">
            <input type="hidden" name="tarikhSlot" value="<%= tarikhSlot %>">
            <input type="hidden" name="kaedahUkuran" value="<%= kaedahUkuran %>">
            <input type="hidden" name="masaSesiUkur" value="<%= masaSesiUkur %>">
            <input type="hidden" name="kaedahPembayaran" value="<%= kaedahPembayaran %>">

            <input type="hidden" id="finalJsonItems" name="finalJsonItems">
            <input type="hidden" id="jenisBayaran" name="jenisBayaran" value="DEPOSIT">
            <input type="hidden" id="jumlahBayaranSebut" name="jumlahBayaranSebut">

            <input type="hidden" id="saluranPembayaranElektronik" name="saluranPembayaranElektronik" value="FPX">
            <input type="hidden" name="saluranRadio" id="hiddenSaluranRadio" disabled="true" value="MANUAL_OFFLINE">

            <div class="row g-4">
                <div class="col-12 col-lg-7">

                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                        <h4 class="fw-bold text-dark mb-4"><i class="bi bi-file-earmark-text text-purple me-2"></i>Butiran Maklumat Sesi</h4>

                        <div class="row g-3">
                            <div class="col-12 col-md-6">
                                <span class="text-muted small d-block">Tarikh Slot Di-book</span>
                                <span class="fw-semibold text-dark fs-5"><i class="bi bi-calendar-check text-success me-1"></i> <%= tarikhSlot %></span>
                            </div>
                            <div class="col-12 col-md-6">
                                <span class="text-muted small d-block">Kaedah Ukuran Badan</span>
                                <span class="fw-semibold text-dark fs-5"><%= formatKaedah %></span>
                            </div>
                            <% if("DATANG_UKUR_BADAN".equals(kaedahUkuran)) { %>
                                <div class="col-12">
                                    <span class="text-muted small d-block">Waktu Sesi Kehadiran Kedai</span>
                                    <span class="fw-semibold text-purple fs-5"><i class="bi bi-clock me-1"></i> <%= masaSesiUkur %></span>
                                </div>
                            <% } %>
                        </div>

                        <% if("DATANG_UKUR_BADAN".equals(kaedahUkuran)) { %>
                            <div class="alert bg-warning-subtle p-3 rounded-3 mt-4 border-0 d-flex align-items-center">
                                <i class="bi bi-exclamation-triangle-fill fs-3 me-3 text-warning"></i>
                                <div>
                                    <strong class="d-block text-dark">Nota Penting Pengesahan Kedatangan:</strong>
                                    <small class="text-muted">Sila pastikan anda hadir ke kedai jahit tepat pada waktu yang dipilih demi kelancaran proses ukuran badan.</small>
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
                        <h4 class="fw-bold text-dark mb-3"><i class="bi bi-scissors text-purple me-2"></i>Senarai Pakaian Dalam Invois</h4>
                        <p class="text-muted small">Anda masih boleh melaras kuantiti atau membuang item pakaian sebelum pengesahan transaksi.</p>

                        <div id="kontainerCheckout"></div>
                    </div>
                </div>

                <div class="col-12 col-lg-5">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white position-sticky" style="top: 20px;">

                        <h4 class="fw-bold text-dark mb-3"><i class="bi bi-credit-card text-purple me-2"></i>Komitmen Pembayaran</h4>
                        <p class="text-muted small">Pilih pelan bayaran awal yang bersesuaian dengan bajet anda.</p>

                        <div id="wrapperPilihanKomitmen" class="row g-2 text-center mb-4">
                            <div class="col-6">
                                <div class="pilihan-komitmen p-3 rounded-4 aktif" id="optDeposit" onclick="tukarModBayaran('DEPOSIT')">
                                    <h6 class="fw-bold m-0 text-dark">Deposit (20%)</h6>
                                    <small class="text-muted small">Cagaran Slot</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="pilihan-komitmen p-3 rounded-4" id="optFull" onclick="tukarModBayaran('FULL')">
                                    <h6 class="fw-bold m-0 text-dark">Bayaran Penuh</h6>
                                    <small class="text-muted small">Selesai Terus</small>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-secondary fs-5">Jumlah Kasar (Upah Asas)</span>
                            <span class="fw-semibold text-dark fs-5" id="txtKasar">RM 0.00</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                            <span class="text-secondary fs-5">Caj Pendaftaran Sesi</span>
                            <span class="text-success fw-medium fs-5">Percuma (RM 0.00)</span>
                        </div>

                        <div class="p-3 bg-light rounded-4 mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <strong class="text-dark fs-5" id="lblJenisBayaran">Deposit Wajib Dibayar:</strong>
                                <strong class="purple-text fs-2" id="txtJumlahBersih">RM 0.00</strong>
                            </div>
                            <small class="text-muted d-block text-end" id="txtNotaBaki"></small>
                        </div>

                        <div class="row g-2">
                            <div class="col-5">
                                <a href="javascript:history.back()" class="btn btn-outline-secondary btn-lg w-100 py-3 rounded-3 fw-medium fs-6">
                                    <i class="bi bi-arrow-left"></i> Kembali
                                </a>
                            </div>
                            <div class="col-7">
                                <button type="button" onclick="bukaPopupSahkanBayaran()" class="btn btn-purple btn-lg w-100 py-3 rounded-3 fw-bold fs-6 shadow-sm">
                                    Sahkan & Bayar <i class="bi bi-arrow-right ms-1"></i>
                                </button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="modalSahkanBayaran" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalPembayaranLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered text-dark">
            <div class="modal-content border-0 shadow rounded-4 p-3">
                <div class="modal-header border-0 pb-0 justify-content-center position-relative">
                    <h3 class="modal-title modal-pembayaran-title text-center w-100 fs-4" id="modalPembayaranLabel">Sahkan Bayaran</h3>
                    <button type="button" class="btn-close position-absolute end-0 top-50 translate-middle-y me-2" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted text-center small mt-0 mb-4" id="modalSubTitle">Pilih saluran cagaran atau bayaran penuh baju anda</p>

                    <div class="mb-4" id="modalPelanKomitmenSection">
                        <label class="fw-bold text-dark mb-2 small d-block"><i class="bi bi-shield-check text-purple me-1"></i> Status Pelan Komitmen Terpilih:</label>
                        <div class="p-3 rounded-3 bg-purple text-white fw-bold d-flex align-items-center justify-content-between shadow-sm">
                            <div class="d-flex align-items-center">
                                <i id="iconStatusPopup" class="bi bi-shield-lock-fill fs-4 me-2"></i>
                                <span id="txtPelanPopup" class="fs-5">Deposit (20%)</span>
                            </div>
                            <span class="badge bg-white text-purple px-3 py-2 rounded-pill small">Aktif</span>
                        </div>
                    </div>

                    <div class="mb-4" id="modalSaluranPaymentSection">
                        <label class="fw-bold text-dark mb-2 small d-block"><i class="bi bi-bank me-1"></i> Saluran Pembayaran Elektronik</label>

                        <div class="mb-2">
                            <label class="kotak-pilihan-saluran" for="radioFpx">
                                <span class="fw-semibold fs-6 text-dark d-flex align-items-center">
                                    <i class="bi bi-bank2 text-primary me-3 fs-5"></i> Perbankan Internet FPX
                                </span>
                                <input class="form-check-input" type="radio" name="saluranRadio" id="radioFpx" value="FPX" checked onchange="tukarSaluranBank('FPX')">
                            </label>
                        </div>

                        <div class="mb-2">
                            <label class="kotak-pilihan-saluran" for="radioKad">
                                <span class="fw-semibold fs-6 text-dark d-flex align-items-center">
                                    <i class="bi bi-credit-card-2-front text-info me-3 fs-5"></i> Kad Kredit / Debit
                                </span>
                                <input class="form-check-input" type="radio" name="saluranRadio" id="radioKad" value="CARD" onchange="tukarSaluranBank('CARD')">
                            </label>
                        </div>
                    </div>

                    <div class="box-jumlah-bayar-secure p-4 text-center mb-4 rounded-4">
                        <span class="text-muted small fw-medium d-block mb-1" id="lblJumlahPopup">Jumlah Perlu Dibayar Sekarang</span>
                        <h1 class="fw-bold text-purple m-0 display-5" id="txtJumlahPopup">RM 0.00</h1>
                    </div>

                    <button type="button" onclick="hantarTransaksiMuktamad()" class="btn btn-purple btn-lg w-100 py-3 rounded-3 fw-bold fs-5 shadow" id="btnSubmitBayarSecure">
                        <i class="bi bi-lock-fill me-2" id="btnSubmitIcon"></i> <span id="btnSubmitText">Bayar Sekarang Securely</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <script src="${pageContext.request.contextPath}/assets/js/ringkasan_tempahan.js"></script>
</body>
</html>