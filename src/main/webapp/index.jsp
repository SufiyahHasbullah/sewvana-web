<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sewvana | Platform Fesyen Peribadi Premium</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome 6 (Ikon) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Google Fonts (Poppins) -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- AOS Animation Library CSS -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <!-- Sewvana Design System (MESTI DILOAD PERTAMA) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sewvana-design-system.css?v=1.2">
    <!-- Pautan Fail CSS (Betul mengikut root webapp) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.2">
</head>
<body>

    <!-- 1. NAVIGATION BAR -->
    <nav class="navbar navbar-expand-lg fixed-top navbar-custom">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="fa-solid fa-scissors me-2"></i>Sewvana
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link active" href="#">Utama</a></li>
                    <li class="nav-item"><a class="nav-link" href="#kelebihan">Tentang</a></li>
                    <li class="nav-item"><a class="nav-link" href="#cara-kerja">Cara Tempahan</a></li>
                    <li class="nav-item"><a class="nav-link" href="#testimoni">Hubungi Kami</a></li>
                    <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                        <a class="btn btn-login px-4 py-2 me-2" href="views/login.jsp">Log Masuk</a>
                        <a class="btn btn-register px-4 py-2" href="views/register.jsp">Daftar Akaun</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 2. HERO SECTION -->
    <header class="hero-section d-flex align-items-center overflow-hidden">
        <div class="container position-relative z-2">
            <div class="row align-items-center g-5">
                <div class="col-lg-6 text-center text-lg-start" data-aos="fade-right" data-aos-duration="1000">
                    <span class="badge bg-lavender text-purple mb-3 px-3 py-2 rounded-pill fw-medium">Personalize Fashion Platform</span>
                    <h1 class="display-4 fw-bold text-white mb-3 leading-sm">
                        Tempahan Jahitan Lebih <span class="text-accent">Mudah</span> dan <span class="text-accent">Teratur</span>
                    </h1>
                    <p class="lead text-white-50 mb-5">
                        Satu platform digital yang menghubungkan pelanggan dan penjahit dengan lebih cekap, teratur, dan profesional.
                    </p>
                    <div class="d-sm-flex justify-content-center justify-content-lg-start gap-3">
                        <a href="views/register.jsp" class="btn btn-primary-premium btn-lg px-4 py-3 shadow mb-3 mb-sm-0">
                            Mula Sekarang <i class="fa-solid fa-arrow-right ms-2 fs-6"></i>
                        </a>
                        <a href="#kelebihan" class="btn btn-outline-white btn-lg px-4 py-3">
                            Ketahui Lebih Lanjut
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 position-relative text-center" data-aos="fade-left" data-aos-duration="1000">
                    <div class="image-floating-wrapper">
                        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Fashion Design Mockup" class="img-fluid rounded-4 shadow-lg hero-img">
                        <div class="floating-badge card-1 shadow p-3 rounded-3 bg-white text-start">
                            <div class="d-flex align-items-center gap-3">
                                <div class="icon-circle bg-light-purple text-purple"><i class="fa-solid fa-circle-check"></i></div>
                                <div>
                                    <h6 class="mb-0 fw-bold text-dark">Ukuran Tepat</h6>
                                    <small class="text-muted">Disimpan Selamat</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="hero-shape"></div>
    </header>

    <!-- 3. KELEBIHAN SISTEM -->
    <section id="kelebihan" class="py-100 bg-white">
        <div class="container">
            <div class="text-center max-w-600 mx-auto mb-5" data-aos="fade-up">
                <h2 class="fw-bold text-dark-title">Kenapa Pilih Sewvana?</h2>
                <p class="text-muted">Kami membawa revolusi digital ke dalam industri jahitan tradisional untuk keselesaan anda.</p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="100">
                    <div class="card card-premium h-100 border-0 p-4">
                        <div class="feature-icon-box mb-4"><i class="fa-solid fa-calendar-check"></i></div>
                        <h4 class="fw-bold h5 mb-3">Tempahan Slot Mudah</h4>
                        <p class="text-muted small mb-0">Pilih tarikh dan slot masa temu janji fitting dengan tukang jahit kegemaran tanpa beratur.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="200">
                    <div class="card card-premium h-100 border-0 p-4">
                        <div class="feature-icon-box mb-4"><i class="fa-solid fa-folder-open"></i></div>
                        <h4 class="fw-bold h5 mb-3">Pengurusan Sistematik</h4>
                        <p class="text-muted small mb-0">Rekod ukuran baju, pilihan kain, dan gaya rekaan disimpan kemas dalam profil digital.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="300">
                    <div class="card card-premium h-100 border-0 p-4">
                        <div class="feature-icon-box mb-4"><i class="fa-solid fa-clock"></i></div>
                        <h4 class="fw-bold h5 mb-3">Penjadualan Teratur</h4>
                        <p class="text-muted small mb-0">Notifikasi automatik membantu mengingatkan tarikh siap kain dan mengelakkan sebarang kelewatan.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3" data-aos="fade-up" data-aos-delay="400">
                    <div class="card card-premium h-100 border-0 p-4">
                        <div class="feature-icon-box mb-4"><i class="fa-solid fa-mobile-screen-button"></i></div>
                        <h4 class="fw-bold h5 mb-3">Akses Bila-Bila Masa</h4>
                        <p class="text-muted small mb-0">Pantau status jahitan baju kurung, kemeja, atau gaun anda terus melalui telefon pintar.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 4. CARA PENGGUNAAN -->
    <section id="cara-kerja" class="py-100 bg-light">
        <div class="container">
            <div class="text-center max-w-600 mx-auto mb-5" data-aos="fade-up">
                <h2 class="fw-bold text-dark-title">Cara Menggunakan Sewvana</h2>
                <p class="text-muted">Proses ringkas dari pendaftaran sehingga pakaian idaman siap dihantar ke tangan anda.</p>
            </div>
            <div class="timeline-container position-relative">
                <div class="row g-4 step-row">
                    <div class="col-lg-3 text-center position-relative step-item" data-aos="zoom-in" data-aos-delay="100">
                        <div class="step-number mx-auto mb-3">1</div>
                        <h5 class="fw-bold">Daftar Akaun</h5>
                        <p class="text-muted small px-3">Cipta profil pengguna secara percuma dalam masa 1 minit sahaja.</p>
                    </div>
                    <div class="col-lg-3 text-center position-relative step-item" data-aos="zoom-in" data-aos-delay="200">
                        <div class="step-number mx-auto mb-3">2</div>
                        <h5 class="fw-bold">Pilih Penjahit</h5>
                        <p class="text-muted small px-3">Cari pakar jahitan berpengalaman berdekatan kawasan Ajil.</p>
                    </div>
                    <div class="col-lg-3 text-center position-relative step-item" data-aos="zoom-in" data-aos-delay="300">
                        <div class="step-number mx-auto mb-3">3</div>
                        <h5 class="fw-bold">Tempah Slot</h5>
                        <p class="text-muted small px-3">Tetapkan slot waktu hantar kain atau sesi ukuran fizikal.</p>
                    </div>
                    <div class="col-lg-3 text-center position-relative step-item" data-aos="zoom-in" data-aos-delay="400">
                        <div class="step-number mx-auto mb-3">4</div>
                        <h5 class="fw-bold">Pantau Tempahan</h5>
                        <p class="text-muted small px-3">Terima kemaskini langsung proses jahitan sehingga selesai.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 5. STATISTIK SISTEM -->
    <section class="py-5 bg-gradient-purple text-white counter-section">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-6 col-md-3">
                    <h3 class="display-5 fw-bold counter-value" data-target="1250">0</h3>
                    <p class="text-white-50 small mb-0">Pengguna Berdaftar</p>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="display-5 fw-bold counter-value" data-target="3400">0</h3>
                    <p class="text-white-50 small mb-0">Jumlah Tempahan</p>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="display-5 fw-bold counter-value" data-target="45">0</h3>
                    <p class="text-white-50 small mb-0">Tukang Jahit Pakar</p>
                </div>
                <div class="col-6 col-md-3">
                    <h3 class="display-5 fw-bold counter-value" data-target="3120">0</h3>
                    <p class="text-white-50 small mb-0">Tempahan Selesai</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 6. TESTIMONI -->
    <section id="testimoni" class="py-100 bg-white">
        <div class="container">
            <div class="text-center max-w-600 mx-auto mb-5" data-aos="fade-up">
                <h2 class="fw-bold text-dark-title">Apa Kata Pengguna Kami?</h2>
                <p class="text-muted">Maklum balas ikhlas daripada pelanggan dan rakan penjahit di komuniti Sewvana.</p>
            </div>

            <div id="testiCarousel" class="carousel slide max-w-800 mx-auto p-4 card border-0 shadow-sm rounded-4" data-bs-ride="carousel" data-aos="fade-up">
                <div class="carousel-inner text-center py-4">
                    <div class="carousel-item active">
                        <p class="fs-5 italic text-secondary px-md-5">"Dulu nak hantar tempahan baju raya terpaksa beratur panjang dan tunggu giliran lama dekat kedai. Sekarang guna Sewvana, booking slot dari rumah, datang kedai terus ambil ukuran. Sangat efisien!"</p>
                        <div class="d-flex align-items-center justify-content-center mt-4 gap-3">
                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100" alt="Avatar" class="rounded-circle profile-avatar">
                            <div class="text-start">
                                <h6 class="mb-0 fw-bold text-dark">Siti Aminah</h6>
                                <small class="text-muted">Pelanggan Setia (Ajil)</small>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <p class="fs-5 italic text-secondary px-md-5">"Sebagai tukang jahit, sistem kalendar Sewvana sangat membantu saya menguruskan had tempahan kain sebulan supaya tidak terlebih terima order. Kedai saya nampak lebih profesional."</p>
                        <div class="d-flex align-items-center justify-content-center mt-4 gap-3">
                            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100" alt="Avatar" class="rounded-circle profile-avatar">
                            <div class="text-start">
                                <h6 class="mb-0 fw-bold text-dark">Abang Ahmad</h6>
                                <small class="text-muted">Tailor Profesional</small>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#testiCarousel" data-bs-slide="prev">
                    <i class="fa-solid fa-chevron-left text-purple fs-4"></i>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#testiCarousel" data-bs-slide="next">
                    <i class="fa-solid fa-chevron-right text-purple fs-4"></i>
                </button>
            </div>
        </div>
    </section>

    <!-- 7. CTA SECTION -->
    <section class="py-5 bg-gradient-purple text-white text-center position-relative overflow-hidden">
        <div class="container py-4 position-relative z-2" data-aos="zoom-in">
            <h2 class="display-6 fw-bold mb-3">Mulakan Pengalaman Tempahan Jahitan Digital Hari Ini</h2>
            <p class="text-white-50 mb-4 max-w-600 mx-auto">Sertai ratusan pelanggan lain yang telah menikmati kemudahan tempahan baju tanpa stres.</p>
            <a href="views/register.jsp" class="btn btn-light-premium btn-lg px-5 py-3 rounded-pill fw-bold">
                Daftar Sekarang Secara Percuma
            </a>
        </div>
    </section>

    <!-- 8. FOOTER -->
    <footer class="bg-dark-title text-white-50 py-5">
        <div class="container">
            <div class="row g-4 align-items-center">
                <div class="col-md-4 text-center text-md-start">
                    <h4 class="text-white fw-bold"><i class="fa-solid fa-scissors me-2 text-purple"></i>Sewvana</h4>
                    <p class="small mt-2">Platform digitalisasi fesyen dan pemetaan ukuran peribadi terulung.</p>
                </div>
                <div class="col-md-4 text-center">
                    <ul class="list-inline mb-0 footer-links">
                        <li class="list-inline-item mx-2"><a href="#" class="text-decoration-none text-white-50">Utama</a></li>
                        <li class="list-inline-item mx-2"><a href="#kelebihan" class="text-decoration-none text-white-50">Tentang</a></li>
                        <li class="list-inline-item mx-2"><a href="#testimoni" class="text-decoration-none text-white-50">Hubungi Kami</a></li>
                    </ul>
                </div>
                <div class="col-md-4 text-center text-md-end">
                    <div class="d-flex justify-content-center justify-content-md-end gap-3 social-icons">
                        <a href="#" class="text-white-50"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#" class="text-white-50"><i class="fa-brands fa-instagram"></i></a>
                        <a href="#" class="text-white-50"><i class="fa-brands fa-tiktok"></i></a>
                    </div>
                </div>
            </div>
            <hr class="border-secondary my-4">
            <div class="text-center small">
                <p class="mb-0">&copy; 2026 Sewvana. Hak Cipta Terpelihara.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- AOS Animation Library JS -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

    <!-- Pautan Fail JS (Betul mengikut root webapp) -->
    <script src="${pageContext.request.contextPath}/assets/js/index.js"></script>
</body>
</html>