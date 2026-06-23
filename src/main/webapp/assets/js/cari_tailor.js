/**
 * Membawa pelanggan ke halaman penjadualan slot penjahit yang dipilih
 * @param {number} idTailor - ID unik bagi penjahit yang dipilih
 */
function bukaTempahanSlot(idTailor) {
    if (!idTailor) {
        alert("Ralat: Maklumat penjahit tidak sah atau tidak ditemui.");
        return;
    }

    // 1. Dapatkan pathname semasa pelayar web (Contoh: /Sewvana/pelanggan/dashboard)
    const currentPath = window.location.pathname;

    const contextPath = currentPath.substring(0, currentPath.indexOf('/', 1) === -1 ? currentPath.length : currentPath.indexOf('/', 1));

    // 3. Kunci Keselamatan: Bersihkan contextPath jika ada perkataan '/pelanggan' yang terselit awal
    let cleanContext = contextPath;
    if (cleanContext.endsWith('/pelanggan')) {
        cleanContext = cleanContext.replace('/pelanggan', '');
    }

    // 4. Lencongan mutlak (Absolute Redirect) - Ini akan menghalang pertindihan '/pelanggan/pelanggan'
    window.location.href = window.location.origin + cleanContext + "/pelanggan/tempah-slot?tailorId=" + idTailor;
}