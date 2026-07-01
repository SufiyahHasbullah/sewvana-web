/**
 * Sewvana - Modul Urus Logik Pentadbir (HQ Control)
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Pusat Kawalan Pentadbir Sewvana sedia dipantau.");
});

function navigasiAdmin(tujuan) {
    if (!tujuan) return;
    var ctx = (typeof APP_CONTEXT !== 'undefined') ? APP_CONTEXT : '';

    switch(tujuan) {
        case 'pengguna':
            window.location.href = ctx + "/admin/urus-pengguna";
            break;
        case 'penjahit':
            window.location.href = ctx + "/admin/urus-penjahit";
            break;
        case 'tempahan':
            window.location.href = ctx + "/admin/urus-tempahan";
            break;
        case 'pembayaran':
            window.location.href = ctx + "/admin/urus-pembayaran";
            break;
        case 'laporan':
            window.location.href = ctx + "/admin/laporan-sistem";
            break;
        case 'tetapan':
            window.location.href = ctx + "/admin/tetapan-sistem";
            break;
        default:
            window.location.href = ctx + "/admin/dashboard";
    }
}