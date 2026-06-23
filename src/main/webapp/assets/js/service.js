/**
 * service.js - Logik pengurusan servis penjahit
 */

function bukaModalTambahServis() {
    const modal = new bootstrap.Modal(document.getElementById('modalTambahServis'));
    modal.show();
}

function bukaModalEditServis(id, nama, harga, keterangan) {
    document.getElementById('editServiceId').value = id;
    document.getElementById('editNamaServis').value = nama;
    document.getElementById('editHargaUpah').value = harga;
    document.getElementById('editKeterangan').value = keterangan;
    
    const modal = new bootstrap.Modal(document.getElementById('modalEditServis'));
    modal.show();
}

function sahkanPadamServis(id, nama) {
    if (confirm("Adakah anda pasti mahu memadam servis '" + nama + "'?")) {
        document.getElementById('padamServiceId').value = id;
        document.getElementById('formPadamServis').submit();
    }
}
