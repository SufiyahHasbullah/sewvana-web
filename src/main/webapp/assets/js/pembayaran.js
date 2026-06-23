/**
 * Sewvana - Modul Urus Validasi Pembayaran
 */
document.addEventListener("DOMContentLoaded", function() {
    const borang = document.getElementById("formSahkanBayar");

    if (borang) {
        borang.addEventListener("submit", function(e) {
            // Beri maklum balas mesra warga emas sebelum melompat ke bank
            const pilihanBank = document.querySelector('input[name="kaedahBayaran"]:checked').value;
            const amaun = document.getElementById("txtJumlah").value;

            const pengesahan = confirm("Anda akan dialihkan ke gerbang selamat " + pilihanBank + " bagi transaksi bernilai RM " + amaun + ". Teruskan?");

            if (!pengesahan) {
                e.preventDefault();
            }
        });
    }
});