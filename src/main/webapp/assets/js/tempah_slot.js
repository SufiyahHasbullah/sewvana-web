/**
 * Sewvana - Modul Logik Interaksi Pengguna Premium (Langkah 1: Pemilihan Slot & Troli Multi-Service)
 */
let troliPesanan = [];

document.addEventListener("DOMContentLoaded", function() {
    console.log("Sewvana Slot Page Fully Loaded.");

    // Semak jika ada data lama dalam sessionStorage untuk mengelakkan kehilangan data jika page refresh
    const dataLama = sessionStorage.getItem("sewvana_troli");
    if (dataLama) {
        troliPesanan = JSON.parse(dataLama);
    }

    // Pastikan paparan troli dikemaskini sebaik sahaja halaman dimuatkan
    kemaskiniPaparanTroli();

    // Jalankan logik susunan bayaran (sorok/papar) berdasarkan kaedah semasa
    kawalKomitmenBayaran();

    // Validasi borang sebelum dihantar ke fasa checkout
    const borangTempahan = document.getElementById('formTempahan');
    if (borangTempahan) {
        borangTempahan.addEventListener('submit', function(e) {
            if (troliPesanan.length === 0) {
                e.preventDefault();
                alert('Sila tambah sekurang-kurangnya satu jenis perkhidmatan pakaian sebelum ke checkout!');
                return false;
            }

            // PENGUKUHAN KESELAMATAN: Paksa data troli pesanan paling terkini masuk ke input hidden sebelum submit
            const inputHidden = document.getElementById('jsonItemTempahan');
            if (inputHidden) {
                inputHidden.value = JSON.stringify(troliPesanan);
            }

            // Validasi tambahan: Jika pilih temujanji kedai, wajib isi slot masa
            const ukurHadirKedai = document.getElementById('ukur_hadir_kedai');
            const selectMasa = document.getElementById('masaSesiUkur');
            if (ukurHadirKedai && ukurHadirKedai.checked) {
                if (selectMasa && !selectMasa.value) {
                    e.preventDefault();
                    alert("Sila pilih waktu temujanji kehadiran ke kedai terlebih dahulu!");
                    return false;
                }
            }
        });
    }
});

/**
 * Menambah item perkhidmatan ke dalam troli jualan
 */
function tambahKeTroli(id, nama, harga) {
    let itemWujud = troliPesanan.find(item => item.id === id);
    if (itemWujud) {
        itemWujud.kuantiti += 1;
    } else {
        troliPesanan.push({ id: id, nama: nama, harga: harga, kuantiti: 1 });
    }
    simpanDanKemaskini();
}

/**
 * Mengurus butang tambah (+) dan tolak (-) kuantiti pada bahagian troli
 */
function larasKuantiti(id, kadar) {
    let item = troliPesanan.find(item => item.id === id);
    if (item) {
        item.kuantiti += kadar;
        if (item.kuantiti <= 0) {
            troliPesanan = troliPesanan.filter(i => i.id !== id);
        }
    }
    simpanDanKemaskini();
}

/**
 * Membuang terus perkhidmatan dari troli
 */
function buangDariTroli(id) {
    troliPesanan = troliPesanan.filter(i => i.id !== id);
    simpanDanKemaskini();
}

/**
 * Menyimpan status terkini ke dalam session storage dan mengemaskini UI skrin
 */
function simpanDanKemaskini() {
    sessionStorage.setItem("sewvana_troli", JSON.stringify(troliPesanan));
    kemaskiniPaparanTroli();
}

/**
 * Membina semula elemen HTML troli secara dinamik pada skrin kanan
 */
function kemaskiniPaparanTroli() {
    const elKosong = document.getElementById('troliKosong');
    const elBerisi = document.getElementById('troliBerisi');
    const kontainer = document.getElementById('kontainerItemTroli');
    const txtTotal = document.getElementById('jumlahKasarSkrin');
    const inputHidden = document.getElementById('jsonItemTempahan');

    if (!kontainer) return; // Mengelakkan ralat jika dipanggil di halaman lain

    if (troliPesanan.length === 0) {
        if (elKosong) elKosong.classList.remove('d-none');
        if (elBerisi) elBerisi.classList.add('d-none');
        if (inputHidden) inputHidden.value = "";
        return;
    }

    if (elKosong) elKosong.classList.add('d-none');
    if (elBerisi) elBerisi.classList.remove('d-none');
    kontainer.innerHTML = '';

    let jumlahBesar = 0;
    troliPesanan.forEach(item => {
        let subtotal = item.harga * item.kuantiti;
        jumlahBesar += subtotal;

        kontainer.innerHTML += `
            <div class="d-flex align-items-center justify-content-between border-bottom py-3">
                <div style="max-width: 55%;">
                    <span class="fw-bold text-dark d-block text-truncate fs-6">${item.nama}</span>
                    <small class="text-purple fw-medium">RM ${item.harga.toFixed(2)} / pasang</small>
                </div>
                <div class="d-flex align-items-center">
                    <div class="input-group input-group-sm rounded-3 overflow-hidden border bg-white" style="width: 100px;">
                        <button class="btn btn-light text-dark fw-bold border-0" type="button" onclick="larasKuantiti(${item.id}, -1)">-</button>
                        <input type="text" class="form-control text-center border-0 bg-white fw-bold px-0" value="${item.kuantiti}" readonly>
                        <button class="btn btn-light text-dark fw-bold border-0" type="button" onclick="larasKuantiti(${item.id}, 1)">+</button>
                    </div>
                    <span class="fw-bold text-dark ms-2 text-end" style="min-width: 80px;">RM ${subtotal.toFixed(2)}</span>
                </div>
            </div>
        `;
    });

    if (txtTotal) txtTotal.innerText = 'RM ' + jumlahBesar.toFixed(2);

    // PEMBETULAN: Menggunakan variable 'troliPesanan' yang betul (Bukan 'troli')
    if (inputHidden) {
        inputHidden.value = JSON.stringify(troliPesanan);
    }
}

/**
 * Fungsi pembantu menukar String tarikh ISO kepada pembacaan penuh Bahasa Melayu
 */
function ubahFormatTarikhMesra(tarikhStr) {
    if (!tarikhStr) return "Sila pilih tarikh di Seksyen 2";
    const pilihanFormat = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    const objekTarikh = new Date(tarikhStr);
    return objekTarikh.toLocaleDateString('ms-MY', pilihanFormat);
}

/**
 * Mengawal kemunculan kotak pilihan masa temujanji ukuran badan (Fizikal Kedai)
 * Dipanggil oleh Radio Button 'kaedahUkuran' di tempah_slot.jsp
 */
function kawalPilihanMasa(paparKotak) {
    const kotak = document.getElementById('kotakPilihanMasa');
    const selectMasa = document.getElementById('masaSesiUkur');

    if (kotak && selectMasa) {
        if (paparKotak) {
            kotak.classList.remove('d-none');
            selectMasa.disabled = false;
        } else {
            kotak.classList.add('d-none');
            selectMasa.disabled = true;
            selectMasa.value = "";
        }
    }
}

/**
 * Mengemaskini teks notifikasi tarikh janji temu di bahagian bawah Seksyen 3
 * Dipanggil oleh Radio Button 'tarikhSlot' di Seksyen 2
 */
function kemaskiniNotifikasiMasa(tarikhTerpilih) {
    const labelTarikh = document.getElementById('paparanTarikhUkur');
    if (labelTarikh && tarikhTerpilih) {
        labelTarikh.innerText = ubahFormatTarikhMesra(tarikhTerpilih);
    }
}

/**
 * Mengawal paparan pilihan komitmen bayaran (Deposit/Penuh)
 * berdasarkan kaedah pembayaran yang dipilih oleh pelanggan.
 */
function kawalKomitmenBayaran() {
    const payOnline = document.getElementById('pay_online');
    const sectionKomitmen = document.getElementById('sectionKomitmen');
}