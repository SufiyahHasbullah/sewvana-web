/**
 * Sewvana - Modul Logik Dinamik Halaman Checkout (Multi-Service & Komitmen Bayaran)
 */

// Pembolehubah global memegang data items pakaian
let senaraiItems = [];
let modBayaranSemasa = 'DEPOSIT';

// Menggunakan DOMContentLoaded bagi menjamin elemen HTML sedia dibaca sebelum JS bermula
document.addEventListener("DOMContentLoaded", function() {
    const rawInput = document.getElementById('rawJsonData');
    const kaedahBayarAwal = document.getElementById('pilihanKaedahBayarAwal') ? document.getElementById('pilihanKaedahBayarAwal').value : 'ONLINE';
    const komitmenAwal = document.getElementById('pilihanKomitmenAwal') ? document.getElementById('pilihanKomitmenAwal').value : 'DEPOSIT';

    let jsonMula = [];
    if (rawInput && rawInput.value.trim() !== "") {
        try {
            jsonMula = JSON.parse(rawInput.value);
        } catch (e) {
            console.error("Gagal menukar data raw JSON: ", e);
        }
    }

    senaraiItems = jsonMula || [];

    // Logik Baharu: Jika fasa fasa borang memilih MANUAL_OFFLINE (Tunai), kunci pilihan kepada bayaran 'FULL'
    if (kaedahBayarAwal === 'MANUAL_OFFLINE') {
        const wrapperKomitmen = document.getElementById('wrapperPilihanKomitmen');
        if (wrapperKomitmen) {
            wrapperKomitmen.classList.add('d-none'); // Sorok pilihan deposit/penfull terus
        }
        modBayaranSemasa = 'FULL';

        // Aktifkan hidden input MANUAL_OFFLINE, lumpuhkan radio FPX/Kad
        const hiddenRadio = document.getElementById('hiddenSaluranRadio');
        if (hiddenRadio) {
            hiddenRadio.removeAttribute('disabled');
        }
        const radioFpx = document.getElementById('radioFpx');
        if (radioFpx) radioFpx.setAttribute('disabled', 'true');
        const radioKad = document.getElementById('radioKad');
        if (radioKad) radioKad.setAttribute('disabled', 'true');

        // Kemaskini teks butang utama ringkasan
        const btnSahkanRingkasan = document.querySelector("button[onclick='bukaPopupSahkanBayaran()']");
        if (btnSahkanRingkasan) {
            btnSahkanRingkasan.innerHTML = `Sahkan Tempahan <i class="bi bi-arrow-right ms-1"></i>`;
        }
    } else {
        // Jika online, ikut apa yang dipilih dari borang awal
        modBayaranSemasa = (komitmenAwal === 'PENUH') ? 'FULL' : 'DEPOSIT';
    }

    // Kemaskini Visual Tab Pilihan Komitmen Aktif
    tukarModBayaran(modBayaranSemasa);
    binaUIUnsur();
});

/**
 * Melaras kuantiti pakaian (tambah atau tolak) terus dari halaman ringkasan invois
 */
function larasKuantitiCheckout(id, amaun) {
    let item = senaraiItems.find(i => i.id === id);
    if (item) {
        item.kuantiti += amaun;
        if (item.kuantiti <= 0) {
            buangItemCheckout(id);
            return;
        }
    }
    binaUIUnsur();
}

/**
 * Membuang item pakaian daripada senarai invois checkout
 */
function buangItemCheckout(id) {
    senaraiItems = senaraiItems.filter(i => i.id !== id);
    binaUIUnsur();
}

/**
 * Mengurus penukaran tab pilihan cara bayaran (Deposit 20% atau Bayaran Penuh)
 */
function tukarModBayaran(mod) {
    modBayaranSemasa = mod;

    const elJenisBayaran = document.getElementById('jenisBayaran');
    const elOptDeposit = document.getElementById('optDeposit');
    const elOptFull = document.getElementById('optFull');
    const elLblJenisBayaran = document.getElementById('lblJenisBayaran');

    if (elJenisBayaran) elJenisBayaran.value = (mod === 'DEPOSIT') ? 'DEPOSIT' : 'PENUH';
    if (elOptDeposit) elOptDeposit.classList.toggle('aktif', mod === 'DEPOSIT');
    if (elOptFull) elOptFull.classList.toggle('aktif', mod === 'FULL');

    if (elLblJenisBayaran) {
        elLblJenisBayaran.innerText = (mod === 'DEPOSIT') ? "Deposit Wajib Dibayar:" : "Jumlah Penuh Dibayar:";
    }
    kiraInvois();
}

/**
 * Membina elemen HTML senarai pakaian secara dinamik pada skrin kiri
 */
function binaUIUnsur() {
    const kontainer = document.getElementById('kontainerCheckout');
    const btnSubmit = document.querySelector("button[onclick='bukaPopupSahkanBayaran()']");

    if (!kontainer) return;

    if (!senaraiItems || senaraiItems.length === 0) {
        kontainer.innerHTML = `
            <div class="text-center py-5">
                <i class="bi bi-cart-x text-danger display-4"></i>
                <p class="text-muted fw-bold mt-2">Tiada item pakaian dalam senarai checkout.<br>Sila kembali ke halaman pilih perkhidmatan.</p>
            </div>`;

        if (btnSubmit) btnSubmit.setAttribute("disabled", "true");

        document.getElementById('txtKasar').innerText = "RM 0.00";
        document.getElementById('txtJumlahBersih').innerText = "RM 0.00";
        document.getElementById('txtNotaBaki').innerText = "";
        return;
    }

    if (btnSubmit) btnSubmit.removeAttribute("disabled");
    kontainer.innerHTML = '';

    senaraiItems.forEach(item => {
        let sub = item.harga * item.kuantiti;
        kontainer.innerHTML += `
            <div class="kad-item-checkout shadow-sm border-0">
                <div>
                    <h6 class="fw-bold m-0 text-dark fs-5">${item.nama}</h6>
                    <span class="text-purple small fw-semibold">RM ${item.harga.toFixed(2)} / helai</span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="input-group input-group-sm border rounded-3 overflow-hidden me-3 bg-white pengawal-kuantiti-checkout">
                        <button class="btn btn-link text-dark fw-bold border-0 text-decoration-none" type="button" onclick="larasKuantitiCheckout(${item.id}, -1)">-</button>
                        <input type="text" class="form-control text-center border-0 bg-white fw-bold px-0 text-dark" value="${item.kuantiti}" readonly>
                        <button class="btn btn-link text-dark fw-bold border-0 text-decoration-none" type="button" onclick="larasKuantitiCheckout(${item.id}, 1)">+</button>
                    </div>
                    <span class="fw-bold text-dark text-end me-3" style="min-width: 80px;">RM ${sub.toFixed(2)}</span>
                    <button type="button" class="btn btn-link text-danger p-0 m-0 border-0 text-decoration-none" onclick="buangItemCheckout(${item.id})">
                        <i class="bi bi-trash3 fs-5"></i>
                    </button>
                </div>
            </div>
        `;
    });
    kiraInvois();
}

/**
 * Melakukan pengiraan matematik invois (Kasar, Bersih, Deposit, Nota Baki)
 */
function kiraInvois() {
    let totalKasar = 0;
    senaraiItems.forEach(i => { totalKasar += (i.harga * i.kuantiti); });

    let jumlahBersih = 0;
    let notaBakiText = "";

    const kaedahBayarAwal = document.getElementById('pilihanKaedahBayarAwal') ? document.getElementById('pilihanKaedahBayarAwal').value : 'ONLINE';

    if (modBayaranSemasa === 'DEPOSIT') {
        jumlahBersih = totalKasar * 0.20; // Kadar deposit 20%
        let baki = totalKasar - jumlahBersih;
        notaBakiText = `Baki upah jahit (RM ${baki.toFixed(2)}) perlu dijelaskan semasa mengambil pakaian siap nanti.`;
    } else {
        jumlahBersih = totalKasar;
        if (kaedahBayarAwal === 'MANUAL_OFFLINE') {
            notaBakiText = "Bayaran penuh perlu dijelaskan secara tunai atau manual mengikut ketetapan kedai penjahit.";
        } else {
            notaBakiText = "Tiada baki tunggakan. Tempahan anda akan dibayar sepenuhnya secara atas talian.";
        }
    }

    // Suntik nilai ke paparan elemen skrin
    if(document.getElementById('txtKasar')) document.getElementById('txtKasar').innerText = 'RM ' + totalKasar.toFixed(2);
    if(document.getElementById('txtJumlahBersih')) document.getElementById('txtJumlahBersih').innerText = 'RM ' + jumlahBersih.toFixed(2);
    if(document.getElementById('txtNotaBaki')) document.getElementById('txtNotaBaki').innerText = notaBakiText;

    // Set input hidden untuk dihantar ke Controller Servlet Java seterusya
    if(document.getElementById('finalJsonItems')) document.getElementById('finalJsonItems').value = JSON.stringify(senaraiItems);
    if(document.getElementById('jumlahBayaranSebut')) document.getElementById('jumlahBayaranSebut').value = jumlahBersih.toFixed(2);

    // Segerakkan dengan sessionStorage utama sistem jualan
    sessionStorage.setItem("sewvana_troli", JSON.stringify(senaraiItems));
}

// =========================================================================
// LOGIK INTERAKTIF BARU KHAS UNTUK POPUP MODAL SAHKAN BAYARAN
// =========================================================================

/**
 * Fungsi mencetus dan memaparkan modal pembongkar invois akhir mengikut pilihan komitmen semasa
 */
function bukaPopupSahkanBayaran() {
    const kaedahBayarAwal = document.getElementById('pilihanKaedahBayarAwal') ? document.getElementById('pilihanKaedahBayarAwal').value : 'ONLINE';
    const nilaiBersihSkrin = document.getElementById('txtJumlahBersih').innerText;

    document.getElementById('txtJumlahPopup').innerText = nilaiBersihSkrin;

    const txtPelanPopup = document.getElementById('txtPelanPopup');
    const iconStatusPopup = document.getElementById('iconStatusPopup');
    const modalTitle = document.getElementById('modalPembayaranLabel');
    const modalSub = document.getElementById('modalSubTitle');
    const pelanSection = document.getElementById('modalPelanKomitmenSection');
    const saluranSection = document.getElementById('modalSaluranPaymentSection');
    const lblJumlah = document.getElementById('lblJumlahPopup');
    const btnText = document.getElementById('btnSubmitText');
    const btnIcon = document.getElementById('btnSubmitIcon');

    if (kaedahBayarAwal === 'MANUAL_OFFLINE') {
        if (modalTitle) modalTitle.innerText = "Sahkan Tempahan";
        if (modalSub) modalSub.innerText = "Sila sahkan butiran tempahan luar talian anda.";
        if (pelanSection) pelanSection.style.display = "none";
        if (saluranSection) saluranSection.style.display = "none";
        if (lblJumlah) lblJumlah.innerText = "Jumlah Anggaran Keseluruhan";
        if (btnText) btnText.innerText = "Sahkan Tempahan Sekarang";
        if (btnIcon) btnIcon.className = "bi bi-check-circle-fill me-2";
    } else {
        if (modalTitle) modalTitle.innerText = "Sahkan Bayaran";
        if (modalSub) modalSub.innerText = "Pilih saluran cagaran atau bayaran penuh baju anda";
        if (pelanSection) pelanSection.style.display = "block";
        if (saluranSection) saluranSection.style.display = "block";
        if (lblJumlah) lblJumlah.innerText = "Jumlah Perlu Dibayar Sekarang";
        if (btnText) btnText.innerText = "Bayar Sekarang Securely";
        if (btnIcon) btnIcon.className = "bi bi-lock-fill me-2";

        if (modBayaranSemasa === 'DEPOSIT') {
            if(txtPelanPopup) txtPelanPopup.innerText = "Deposit (RM " + parseFloat(document.getElementById('jumlahBayaranSebut').value).toFixed(0) + ")";
            if(iconStatusPopup) {
                iconStatusPopup.className = "bi bi-shield-lock-fill fs-4 me-2";
            }
        } else {
            if(txtPelanPopup) txtPelanPopup.innerText = "Penuh (RM " + parseFloat(document.getElementById('jumlahBayaranSebut').value).toFixed(0) + ")";
            if(iconStatusPopup) {
                iconStatusPopup.className = "bi bi-wallet2 fs-4 me-2";
            }
        }
    }

    const myModal = new bootstrap.Modal(document.getElementById('modalSahkanBayaran'));
    myModal.show();
}

/**
 * Menukar nilai input hidden saluran pembayaran elektronik (FPX atau CARD)
 */
function tukarSaluranBank(saluran) {
    const elSaluranHidden = document.getElementById('saluranPembayaranElektronik');
    if (elSaluranHidden) {
        elSaluranHidden.value = saluran;
        console.log("Saluran pembayaran ditukar kepada: " + saluran);
    }
}

/**
 * Melakukan proses akhir penghantaran (submit) borang data ke server
 */
function hantarTransaksiMuktamad() {
    const form = document.getElementById('formCheckoutUtama');
    if (form) {
        // Di sini borang dihantar dengan selamat ke /pelanggan/pembayaran beserta semua data hidden
        form.submit();
    }
}