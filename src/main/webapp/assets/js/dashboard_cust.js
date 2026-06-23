/**
 * Sewvana - Logik Kawalan Hadapan Pelanggan
 */
document.addEventListener("DOMContentLoaded", function() {
    console.log("Aplikasi Sewvana sedia beroperasi.");
});

function navigasiMenu(destinasi) {
    if (!destinasi) return;
    const konteks = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));

    switch(destinasi) {
        case 'tempahan':
            window.location.href = konteks + "/pelanggan/tempahan";
            break;
        case 'cari':
            window.location.href = konteks + "/pelanggan/cari";
            break;
        case 'slot':
            window.location.href = konteks + "/pelanggan/tempah-slot";
            break;
        case 'pembayaran':
            window.location.href = konteks + "/pelanggan/bayar";
            break;
        case 'notifikasi':
            window.location.href = konteks + "/pelanggan/notifikasi";
            break;
        case 'profil':
            window.location.href = konteks + "/pelanggan/profil";
            break;
        default:
            window.location.href = konteks + "/pelanggan/dashboard";
    }
}

function pilihKategori(kategori) {
    const konteks = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    window.location.href = konteks + "/pelanggan/tempah-slot?kategori=" + encodeURIComponent(kategori);
}

function hubungiPenjahit(idPenjahit) {
    const konteks = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    window.location.href = konteks + "/pelanggan/tempah-slot?id_penjahit=" + idPenjahit;
}