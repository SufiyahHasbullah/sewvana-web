<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Urus Slot Operasi";
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/urus_slot.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-tailor.jspf" %>

    <div class="sewvana-main-content">
        <%@ include file="/WEB-INF/jspf/topbar.jspf" %>
        <div class="mb-4">
            <h1 class="fw-bold text-dark m-0">Kalendar & Tetapan Slot</h1>
            <p class="text-muted fs-5 m-0">Tentukan tarikh bekerja dan kapasiti maksimum pakaian yang boleh anda terima.</p>
        </div>

        <% if (session.getAttribute("mesejSukses") != null) { %>
            <div class="alert alert-success border-0 shadow-sm p-3 fs-5 mb-4 rounded-3" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= session.getAttribute("mesejSukses") %>
                <% session.removeAttribute("mesejSukses"); %>
            </div>
        <% } %>
        <% if (session.getAttribute("mesejRalat") != null) { %>
            <div class="alert alert-danger border-0 shadow-sm p-3 fs-5 mb-4 rounded-3" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= session.getAttribute("mesejRalat") %>
                <% session.removeAttribute("mesejRalat"); %>
            </div>
        <% } %>

        <div class="row g-4">
            <div class="col-12">
                <!-- Kalendar Slot Card -->
                <div class="card form-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                        <h3 class="fw-bold h4 m-0 text-dark">
                            <i class="bi bi-calendar-week-fill purple-text me-2"></i>Kalendar Slot Anda
                        </h3>
                        <div class="d-flex align-items-center gap-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle" id="prevMonthBtn"><i class="bi bi-chevron-left"></i></button>
                            <span class="fw-bold fs-5 text-purple" id="monthYearTitle">-</span>
                            <button type="button" class="btn btn-sm btn-outline-secondary rounded-circle" id="nextMonthBtn"><i class="bi bi-chevron-right"></i></button>
                        </div>
                    </div>
                    
                    <!-- Legend -->
                    <div class="d-flex gap-3 mb-3 small fw-medium flex-wrap">
                        <div class="d-flex align-items-center gap-1"><span class="badge bg-success-subtle border border-success" style="width:12px; height:12px; display:inline-block;"></span> Slot Buka</div>
                        <div class="d-flex align-items-center gap-1"><span class="badge bg-danger-subtle border border-danger" style="width:12px; height:12px; display:inline-block;"></span> Slot Tutup / Cuti</div>
                        <div class="d-flex align-items-center gap-1"><span class="badge bg-light border" style="width:12px; height:12px; display:inline-block;"></span> Belum Ditetapkan</div>
                    </div>

                    <!-- Calendar Grid -->
                    <div class="calendar-grid-wrapper">
                        <div class="calendar-weekdays-grid mb-1">
                            <div>Ahd</div><div>Isn</div><div>Sel</div><div>Rab</div><div>Kha</div><div>Jum</div><div>Sab</div>
                        </div>
                        <div class="calendar-days-grid" id="calendarDaysContainer">
                            <!-- Dynamic days will be rendered by JS -->
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12">
                <div class="card form-card p-4">
                    <h3 class="fw-bold h4 mb-3 text-dark"><i class="bi bi-info-circle-fill text-muted me-2"></i>Panduan Pengurusan</h3>

                    <div class="row g-3">
                        <div class="col-12 col-md-6">
                            <div class="panduan-box p-3 border-start border-4 border-primary h-100">
                                <h5 class="fw-bold text-primary m-0"><i class="bi bi-lightning-charge-fill me-1"></i> Sistem Kalis Pertindihan</h5>
                                <p class="text-secondary small m-0 mt-1">Jika anda memilih tarikh yang sudah wujud, sistem secara automatik mengemaskini kuota sedia ada tanpa mewujudkan baris data berkembar.</p>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <div class="panduan-box p-3 border-start border-4 border-warning h-100">
                                <h5 class="fw-bold m-0" style="color: #B45309;"><i class="bi bi-info-square-fill me-1"></i> Kesan Terhadap Pelanggan</h5>
                                <p class="text-secondary small m-0 mt-1">Sebaik sahaja disimpan, tarikh baru tersebut akan dipaparkan secara langsung (*live*) di carian slot pelanggan.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



    </div>

    <%@ include file="/WEB-INF/jspf/bottom-nav-tailor.jspf" %>
    <%@ include file="/WEB-INF/jspf/scripts.jspf" %>

    <!-- Bootstrap 5 Modal for Editing Slot -->
    <div class="modal fade" id="modalEditSlot" tabindex="-1" aria-labelledby="modalEditSlotLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-purple text-white border-0 py-3" style="background-color: var(--sw-primary) !important;">
                    <h5 class="modal-title fw-bold" id="modalEditSlotLabel">
                        <i class="bi bi-calendar-check-fill me-2"></i>Kemaskini Slot Operasi
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="formSlot" action="${pageContext.request.contextPath}/penjahit/slot" method="POST">
                    <div class="modal-body p-4">
                        <!-- Text display for visual clarity -->
                        <div class="p-3 bg-light rounded-3 mb-4 text-center">
                            <span class="d-block text-secondary small fw-bold">Tarikh Terpilih:</span>
                            <span class="fs-4 fw-bold text-dark" id="displayTarikhTerpilih">-</span>
                            <input type="hidden" name="tarikhSlot" id="inputTarikhSlot">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary">Had Slot Maksimum (Pasang/Hari)</label>
                            <select name="maxTempahan" id="selectMaxTempahan" class="form-select form-select-lg">
                                <option value="3">3 Pasang Baju (Santai)</option>
                                <option value="5" selected>5 Pasang Baju (Sederhana)</option>
                                <option value="10">10 Pasang Baju (Maksimum)</option>
                                <option value="0">0 Pasang Baju (Cuti/Tutup)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-secondary">Status Pengambilan</label>
                            <select name="statusSlot" id="selectStatusSlot" class="form-select form-select-lg">
                                <option value="BUKA">BUKA (Menerima Tempahan Pelanggan)</option>
                                <option value="TUTUP">TUTUP (Tanda sebagai Cuti / Penuh)</option>
                            </select>
                        </div>

                        <!-- Repeat Options -->
                        <div class="p-3 border rounded-3 bg-light mt-3">
                            <div class="form-check form-switch m-0">
                                <input class="form-check-input" type="checkbox" name="ulangiMingguan" id="chkUlangi" value="true">
                                <label class="form-check-label fw-bold text-dark" for="chkUlangi" id="lblUlangi">
                                    Ulangi tetapan ini setiap minggu
                                </label>
                            </div>
                            <small class="text-muted d-block mt-1">
                                Jika ditandakan, kuota/status ini akan disalin ke hari yang sama untuk 8 minggu akan datang.
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 bg-light">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-purple px-4" onclick="document.getElementById('formSlot').submit();" style="background-color: var(--sw-primary) !important;">
                            <i class="bi bi-save me-1"></i>Simpan Jadual
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Data slot yang diambil dari servlet
        const dataSlotsSediaAda = <%= (request.getAttribute("jsonSlots") != null) ? request.getAttribute("jsonSlots") : "[]" %>;
        const contextPathUrl = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/urus_slot.js"></script>
</body>
</html>