/**
 * Sewvana - Modul Urus Logik Penjahit
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Dashboard Penjahit Sewvana sedia beroperasi.");

    // =========================================================================
    // SUNTIKAN BARU: Pengesahan Keselamatan Batal Tempahan (Mesra Warga Emas)
    // =========================================================================
    // Tangkap semua borang operasi yang mempunyai kelas .action-form daripada JSP
    const senaraiBorang = document.querySelectorAll(".action-form");

    senaraiBorang.forEach(form => {
        form.addEventListener("submit", function(e) {
            // Dapatkan butang spesifik yang mencetuskan penghantaran borang
            const butangDitekan = e.submitter;

            // Jika butang tersebut membawa nilai tindakan "batal"
            if (butangDitekan && butangDitekan.value === "batal") {
                // Paparkan kotak dialog amaran teks besar yang jelas
                const sahkanPembatalan = confirm("Adakah anda pasti untuk membatalkan slot tempahan pelanggan ini?");

                // Jika penjahit menekan 'Cancel', sekat penghantaran data ke Servlet
                if (!sahkanPembatalan) {
                    e.preventDefault();
                }
            }
        });
    });
    // =========================================================================
});

function navigasiPenjahit(tujuan) {
    if (!tujuan) return;
    
    // Dapatkan laluan context path pelayan (ROOT)
    const konteksPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    
    switch(tujuan) {
        case 'tempahan':
            window.location.href = konteksPath + "/penjahit/pesanan";
            break;
        case 'jadual':
            window.location.href = konteksPath + "/penjahit/slot";
            break;
        case 'pelanggan':
            window.location.href = konteksPath + "/penjahit/senarai-pelanggan";
            break;
        case 'pembayaran':
            window.location.href = konteksPath + "/penjahit/rekod-bayaran";
            break;
        case 'laporan':
            window.location.href = konteksPath + "/penjahit/laporan-tahunan";
            break;
        case 'profil':
            window.location.href = konteksPath + "/penjahit/profil-kedai";
            break;
        default:
            window.location.href = konteksPath + "/penjahit/dashboard";
    }
}