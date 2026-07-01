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
    var ctx = (typeof APP_CONTEXT !== 'undefined') ? APP_CONTEXT : '';

    switch(tujuan) {
        case 'tempahan':
            window.location.href = ctx + "/penjahit/pesanan";
            break;
        case 'jadual':
            window.location.href = ctx + "/penjahit/slot";
            break;
        case 'pelanggan':
            window.location.href = ctx + "/penjahit/pesanan";
            break;
        case 'pembayaran':
            window.location.href = ctx + "/penjahit/rekod-bayaran";
            break;
        case 'laporan':
            window.location.href = ctx + "/penjahit/rekod-bayaran";
            break;
        case 'profil':
            window.location.href = ctx + "/penjahit/profil-kedai";
            break;
        default:
            window.location.href = ctx + "/penjahit/dashboard";
    }
}