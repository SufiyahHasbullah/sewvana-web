<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sewvana.model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("pengguna");
    String pageTitle = "Kaedah Ukuran Badan";

    String tailorId = (String) request.getAttribute("tailorId");
    String kategoriId = (String) request.getAttribute("kategoriId");
    String tarikhSlot = (String) request.getAttribute("tarikhSlot");
%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <%@ include file="/WEB-INF/jspf/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tempah_slot.css">
</head>
<body>

    <%@ include file="/WEB-INF/jspf/sidebar-customer.jspf" %>

    <div class="sewvana-main-content">
        <div class="content-header mb-4">
            <h1 class="fw-bold m-0 main-title">Pilihan Kaedah Ukuran</h1>
            <p class="text-muted m-0 sub-title text-large">Langkah 2: Sila pilih bagaimana maklumat ukuran saiz badan hendak diserahkan.</p>
        </div>

        <form action="${pageContext.request.contextPath}/pelanggan/ringkasan-tempahan" method="POST" id="formPilihUkuran">
            <input type="hidden" name="tailorId" value="<%= tailorId %>">
            <input type="hidden" name="kategoriId" value="<%= kategoriId %>">
            <input type="hidden" name="tarikhSlot" value="<%= tarikhSlot %>">

            <div class="row g-4">
                <div class="col-12 col-lg-8">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
                        <label class="form-label fw-bold text-dark fs-4 mb-3">
                            <i class="bi bi-rulers text-purple me-2"></i>Bagaimana ukuran badan hendak diserahkan?
                        </label>

                        <div class="row g-3">
                            <div class="col-12">
                                <input type="radio" class="btn-check" name="kaedahUkuran" id="ukurSediaAda" value="UKURAN_SEDIA_ADA" checked onclick="kawalPaparanMasaSesi(false)">
                                <label class="premium-option-card p-4 d-block" for="ukurSediaAda">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-box-option me-3"><i class="bi bi-folder-check fs-3"></i></div>
                                        <div>
                                            <h5 class="fw-bold m-0 text-dark fs-5">A. Gunakan Ukuran Sedia Ada (Profil Fail)</h5>
                                            <p class="text-muted m-0 small">Gunakan profil data ukuran lama anda yang telah direkodkan dalam sistem ini sebelum ini.</p>
                                        </div>
                                    </div>
                                </label>
                            </div>

                            <div class="col-12">
                                <input type="radio" class="btn-check" name="kaedahUkuran" id="ukurDatangKedai" value="DATANG_UKUR_BADAN" onclick="kawalPaparanMasaSesi(true)">
                                <label class="premium-option-card p-4 d-block" for="ukurDatangKedai">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-box-option me-3"><i class="bi bi-shop fs-3"></i></div>
                                        <div>
                                            <h5 class="fw-bold m-0 text-dark fs-5">B. Temujanji Sesi Ukur Badan (Hadir Ke Kedai)</h5>
                                            <p class="text-danger fw-semibold m-0 small"><i class="bi bi-heart-fill me-1"></i> Sangat Disyorkan untuk Warga Emas. Anda hadir ke kedai pada tarikh slot yang dipilih.</p>
                                        </div>
                                    </div>
                                </label>
                            </div>

                            <div class="col-12">
                                <input type="radio" class="btn-check" name="kaedahUkuran" id="ukurHantarSendiri" value="HANTAR_SENDIRI" onclick="kawalPaparanMasaSesi(false)">
                                <label class="premium-option-card p-4 d-block" for="ukurHantarSendiri">
                                    <div class="d-flex align-items-center">
                                        <div class="icon-box-option me-3"><i class="bi bi-pencil-square fs-3"></i></div>
                                        <div>
                                            <h5 class="fw-bold m-0 text-dark fs-5">C. Isi & Hantar Ukuran Sendiri</h5>
                                            <p class="text-muted m-0 small">Isi borang saiz digital secara manual sejurus selepas bayaran deposit selesai.</p>
                                        </div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div id="wrapperMasaUkur" class="mt-4 p-4 border rounded-3 bg-light d-none" style="animation: fadeIn 0.3s ease-in-out;">
                            <label class="form-label fw-bold text-dark fs-5 mb-2">
                                <i class="bi bi-clock-history text-purple me-2"></i>Pilih Waktu Kedatangan Anda ke Kedai:
                            </label>
                            <p class="text-muted small">Sila pilih anggaran waktu kehadiran bagi mengelakkan kesesakan ruang menunggu kedai.</p>
                            <select name="masaSesiUkur" class="form-select form-select-lg py-3 rounded-3 fs-5 bg-white">
                                <option value="10:00">10:00 Pagi</option>
                                <option value="11:30">11:30 Pagi</option>
                                <option value="14:30">02:30 Petang</option>
                                <option value="16:00">04:00 Petang</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-between mt-5 pt-3 border-top">
                            <a href="javascript:history.back()" class="btn btn-outline-secondary btn-lg px-4 py-3 rounded-3 fw-medium">
                                <i class="bi bi-arrow-left me-2"></i> Kembali
                            </a>
                            <button type="submit" class="btn btn-purple btn-lg px-5 py-3 rounded-3 fw-bold fs-5">
                                Seterusnya ke Ringkasan Tempahan <i class="bi bi-arrow-right ms-2"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-4">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
                        <h5 class="fw-bold text-dark mb-3"><i class="bi bi-info-circle text-purple me-2"></i>Maklumat Pilihan</h5>
                        <div class="mb-3 pb-2 border-bottom">
                            <span class="text-secondary small d-block">Tarikh Terpilih:</span>
                            <strong class="text-dark fs-5"><%= tarikhSlot %></strong>
                        </div>
                        <div class="alert bg-lavender border-0 p-3 rounded-3 m-0">
                            <small class="text-muted d-block"><i class="bi bi-shield-check text-purple me-1"></i> Data pilihan langkah terdahulu dijamin selamat dibawa ke fasa ringkasan.</small>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        function kawalPaparanMasaSesi(paparkan) {
            const kotakMasa = document.getElementById("wrapperMasaUkur");
            if (kotakMasa) {
                if (paparkan) {
                    kotakMasa.classList.remove("d-none");
                } else {
                    kotakMasa.classList.add("d-none");
                }
            }
        }
    </script>
</body>
</html>