/**
 * Sewvana - Modul Urus Logik Pentadbir (HQ Control)
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Pusat Kawalan Pentadbir Sewvana sedia dipantau.");
});

function navigasiAdmin(tujuan) {
    if (!tujuan) return;

    // Mengekstrak laluan konteks aplikasi web secara dinamik
    const konteks = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));

    switch(tujuan) {
        case 'pengguna':
            window.location.href = konteks + "/admin/urus-pengguna";
            break;
        case 'penjahit':
            window.location.href = konteks + "/admin/urus-penjahit";
            break;
        case 'tempahan':
            window.location.href = konteks + "/admin/urus-tempahan";
            break;
        case 'pembayaran':
            window.location.href = konteks + "/admin/urus-pembayaran";
            break;
        case 'laporan':
            window.location.href = konteks + "/admin/laporan-sistem";
            break;
        case 'tetapan':
            window.location.href = konteks + "/admin/tetapan-sistem";
            break;
        default:
            window.location.href = konteks + "/admin/dashboard";
    }
}