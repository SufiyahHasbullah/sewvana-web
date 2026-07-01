/**
 * Sewvana - Logik Kawalan Hadapan Pelanggan
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Aplikasi Sewvana sedia beroperasi.");
});

function navigasiMenu(destinasi) {
    if (!destinasi) return;
    var ctx = (typeof APP_CONTEXT !== 'undefined') ? APP_CONTEXT : '';

    switch(destinasi) {
        case 'tempahan':
            window.location.href = ctx + "/pelanggan/tempahan";
            break;
        case 'cari':
            window.location.href = ctx + "/pelanggan/cari-penjahit";
            break;
        case 'slot':
            window.location.href = ctx + "/pelanggan/cari-penjahit";
            break;
        case 'notifikasi':
            window.location.href = ctx + "/pelanggan/tempahan";
            break;
        case 'pembayaran':
            window.location.href = ctx + "/pelanggan/sejarah-bayaran";
            break;
        case 'profil':
            window.location.href = ctx + "/pelanggan/profil";
            break;
        default:
            window.location.href = ctx + "/dashboard-pelanggan";
    }
}

function pilihKategori(kategori) {
    var ctx = (typeof APP_CONTEXT !== 'undefined') ? APP_CONTEXT : '';
    window.location.href = ctx + "/pelanggan/cari-penjahit?kategori=" + encodeURIComponent(kategori);
}

function hubungiPenjahit(idPenjahit) {
    var ctx = (typeof APP_CONTEXT !== 'undefined') ? APP_CONTEXT : '';
    window.location.href = ctx + "/pelanggan/tempah-slot?id_penjahit=" + idPenjahit;
}