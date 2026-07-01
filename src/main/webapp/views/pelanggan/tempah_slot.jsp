<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Pilih Slot Tempahan";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tempah_slot.css">
    <!-- Tambah Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>
        <div class="content-header mb-4">
            <h1 class="fw-bold m-0 main-title">Jadual Slot <span class="purple-text">${namaPenjahit}</span></h1>
            <p class="text-muted m-0 sub-title text-large">Sila lengkapkan perincian tempahan pakaian dan pengurusan sesi jahit anda.</p>
        </div>

        <form id="formTempahan" action="${pageContext.request.contextPath}/pelanggan/ringkasan-tempahan" method="POST">
            <input type="hidden" name="tailorId" value="${tailorId}">
            <input type="hidden" id="jsonItemTempahan" name="jsonItemTempahan">
            <!-- NOTA: Input hidden 'masaSesiUkur' yang bertindih telah dibuang dari sini demi kelancaran Javascript -->

            <div class="row g-4">
                <div class="col-12 col-lg-7">

                    <!-- SEKSYEN 1: PERKHIDMATAN -->
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                        <label class="form-label fw-bold text-dark fs-4 mb-2">
                            <i class="bi bi-scissors text-purple me-2"></i>1. Pilih Perkhidmatan Yang Ditawarkan
                        </label>
                        <p class="text-muted small">Klik butang 'Tambah Order' mengikut bilangan jenis pakaian yang ingin anda tempah.</p>

                        <div class="row g-3 mt-1">
                            <%
                                List<Map<String, Object>> senaraiServis = (List<Map<String, Object>>) request.getAttribute("senaraiServis");
                                if (senaraiServis != null && !senaraiServis.isEmpty()) {
                                    for (Map<String, Object> servis : senaraiServis) {
                                        int idServis = (Integer) servis.get("id");
                                        String namaServis = (String) servis.get("nama_servis");
                                        double hargaUpah = (Double) servis.get("harga_upah");
                            %>
                                <div class="col-12">
                                    <div class="card premium-option-card p-3 d-flex flex-row align-items-center justify-content-between border rounded-3 bg-light">
                                        <div class="d-flex align-items-center">
                                            <div class="icon-box-option me-3 rounded-3 d-flex align-items-center justify-content-center">
                                                <i class="bi bi-scissors fs-4"></i>
                                            </div>
                                            <div>
                                                <strong class="d-block text-dark fs-5"><%= namaServis %></strong>
                                                <span class="text-purple fw-bold">RM <%= String.format("%.2f", hargaUpah) %></span>
                                            </div>
                                        </div>
                                        <div>
                                            <button type="button" class="btn btn-purple rounded-3 fw-bold btn-sm px-3 py-2"
                                                    onclick="tambahKeTroli(<%= idServis %>, '<%= namaServis %>', <%= hargaUpah %>)">
                                                <i class="bi bi-plus-lg me-1"></i> Tambah Order
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            <%
                                    }
                                } else {
                            %>
                                <div class="col-12 text-center py-3">
                                    <p class="text-muted small">Tiada senarai perkhidmatan aktif dari penjahit buat masa ini.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- SEKSYEN 2: PILIH TARIKH -->
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                        <label class="form-label fw-bold text-dark fs-4 mb-3">
                            <i class="bi bi-calendar3 text-purple me-2"></i>2. Pilih Tarikh Yang Tersedia
                        </label>
                        <p class="text-muted small">Sila pilih satu tarikh dari kalendar di bawah. Tarikh yang kelabu bermaksud slot penjahit telah penuh atau tutup.</p>

                        <div class="mb-2 position-relative">
                            <i class="bi bi-calendar-event position-absolute top-50 start-0 translate-middle-y ms-3 text-purple fs-5"></i>
                            <input type="text" id="tarikhSlotPicker" class="form-control form-control-lg bg-light border-0 shadow-sm px-5 py-3" placeholder="Pilih tarikh temujanji anda" readonly style="cursor: pointer; font-weight: bold; color: #3D2C5E;">
                            <input type="hidden" name="tarikhSlot" id="tarikhSlotFormInput" required>
                        </div>
                    </div>

                    <!-- SEKSYEN 3: KAEDAH UKURAN BADAN -->
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                        <label class="form-label fw-bold text-dark fs-4 mb-2">
                            <i class="bi bi-rulers text-purple me-2"></i>3. Kaedah Ukuran Badan
                        </label>
                        <p class="text-muted small">Sila pilih bagaimana anda mahu menyerahkan ukuran saiz pakaian anda kepada penjahit.</p>

                        <div class="row g-3 mt-1">
                            <div class="col-12 col-md-6">
                                <input type="radio" class="btn-check" name="kaedahUkuran" id="ukur_sedia_ada" value="UKURAN_SEDIA_ADA" checked onchange="kawalPilihanMasa(false)">
                                <label class="card option-box-interactive p-3 rounded-3 h-100" for="ukur_sedia_ada">
                                    <strong class="text-dark d-block fs-5"><i class="bi bi-file-earmark-person me-2"></i>Guna Ukuran Sedia Ada</strong>
                                    <small class="text-muted mt-1 d-block">Penjahit akan merujuk profil saiz lama yang telah anda simpan sebelum ini.</small>
                                </label>
                            </div>

                            <div class="col-12 col-md-6">
                                <input type="radio" class="btn-check" name="kaedahUkuran" id="ukur_hadir_kedai" value="DATANG_UKUR_BADAN" onchange="kawalPilihanMasa(true)">
                                <label class="card option-box-interactive p-3 rounded-3 h-100" for="ukur_hadir_kedai">
                                    <strong class="text-dark d-block fs-5"><i class="bi bi-shop me-2"></i>Hadir Janji Temu Kedai</strong>
                                    <small class="text-muted mt-1 d-block">Hadir secara fizikal ke kedai penjahit untuk diambil ukuran badan yang baharu.</small>
                                </label>
                            </div>
                        </div>

                        <!-- Dropdown Pilihan Masa Sesi Ukuran (Akan muncul jika Pilih Hadir Kedai) -->
                        <div id="kotakPilihanMasa" class="alert alert-purple mt-3 d-none bg-light-purple border-0 p-3 rounded-4 shadow-sm">
                            <div class="row align-items-center">
                                <div class="col-12 col-md-6 mb-2 mb-md-0">
                                    <h6 class="fw-bold text-purple mb-1"><i class="bi bi-clock-history me-2"></i>Pilih Masa Sesi Temujanji Ukuran</h6>
                                    <p class="text-muted small m-0">
                                        Sesi pada tarikh: <strong id="paparanTarikhUkur" class="text-dark">Sila pilih tarikh di Seksyen 2</strong>
                                    </p>
                                </div>
                                <div class="col-12 col-md-6">
                                    <!-- Dropdown interaktif masa tunggal yang sah -->
                                    <select class="form-select border-2 rounded-3 text-dark fw-medium" id="masaSesiUkur" name="masaSesiUkur" disabled required>
                                        <option value="" selected disabled>-- Pilih Waktu Ke Kedai --</option>
                                        <option value="10:00">10:00 AM (Pagi)</option>
                                        <option value="11:30">11:30 AM (Pagi)</option>
                                        <option value="14:30">02:30 PM (Petang)</option>
                                        <option value="16:00">04:00 PM (Petang)</option>
                                        <option value="20:30">08:30 PM (Malam)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="col-12 col-lg-5">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white sticky-top" style="top: 20px; z-index: 10;">
                        <label class="form-label fw-bold text-dark fs-4 mb-2">
                            <i class="bi bi-cart3 text-purple me-2"></i>Senarai Tempahan Kontrak
                        </label>
                        <hr class="my-2">

                        <div id="troliKosong" class="text-center py-4">
                            <i class="bi bi-bag-dash text-muted display-4"></i>
                            <p class="text-muted mt-2 small">Belum ada perkhidmatan dipilih.<br>Sila pilih dan klik butang 'Tambah Order'.</p>
                        </div>

                        <div id="troliBerisi" class="d-none">
                            <div id="kontainerItemTroli" class="mb-3" style="max-height: 200px; overflow-y: auto;">
                            </div>

                            <div class="p-3 bg-light rounded-3 mb-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-secondary small">Jumlah Anggaran Kasar:</span>
                                    <span class="fs-3 fw-bold text-purple" id="jumlahKasarSkrin">RM 0.00</span>
                                </div>
                            </div>

                            <!-- 1. KAEDAH PEMBAYARAN -->
                            <div class="mb-3">
                                <label class="form-label fw-bold text-dark small">
                                    <i class="bi bi-credit-card me-1"></i>1. Kaedah Pembayaran
                                </label>
                                <div class="d-flex gap-2">
                                    <!-- Fungsi JavaScript dipanggil setiap kali radio bertukar untuk semak logik sorok/papar -->
                                    <input type="radio" class="btn-check" name="kaedahPembayaran" id="pay_online" value="ONLINE" onchange="kawalKomitmenBayaran()" checked>
                                    <label class="btn btn-outline-secondary btn-sm w-50 py-2 fw-medium" for="pay_online">
                                        <i class="bi bi-globe2 me-1"></i>Atas Talian
                                    </label>

                                    <input type="radio" class="btn-check" name="kaedahPembayaran" id="pay_offline" value="MANUAL_OFFLINE" onchange="kawalKomitmenBayaran()">
                                    <label class="btn btn-outline-secondary btn-sm w-50 py-2 fw-medium" for="pay_offline">
                                        <i class="bi bi-cash-coin me-1"></i>Tunai / Manual
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-purple btn-lg w-100 py-3 rounded-3 fw-bold fs-5 shadow-sm">
                                Selesai & Semak Pesanan <i class="bi bi-arrow-right ms-2"></i>
                            </button>
                        </div>

                    </div>
                </div>
            </div>
        </form>
    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-customer.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>
    <!-- Tambah Flatpickr JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="${pageContext.request.contextPath}/assets/js/tempah_slot.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var availableDates = [
            <%
                List<Map<String, Object>> jsKalendarSlot = (List<Map<String, Object>>) request.getAttribute("kalendarSlot");
                if (jsKalendarSlot != null && !jsKalendarSlot.isEmpty()) {
                    for (Map<String, Object> slot : jsKalendarSlot) {
                        if ("TERSEDIA".equals(slot.get("status"))) {
            %>
                "<%= slot.get("tarikh") %>",
            <%
                        }
                    }
                }
            %>
            ];

            flatpickr("#tarikhSlotPicker", {
                dateFormat: "Y-m-d",
                minDate: "today",
                enable: availableDates,
                disableMobile: "true", // Pastikan sentiasa popup lawa kat mobile
                onChange: function(selectedDates, dateStr, instance) {
                    document.getElementById('tarikhSlotFormInput').value = dateStr;
                    if(typeof kemaskiniNotifikasiMasa === 'function') {
                        kemaskiniNotifikasiMasa(dateStr);
                    }
                }
            });
        });
    </script>

</body>
</html>