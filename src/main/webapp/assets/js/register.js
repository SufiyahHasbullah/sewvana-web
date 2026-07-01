document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    const clientErrorAlert = document.getElementById('clientErrorAlert');
    const clientErrorMsg = document.getElementById('clientErrorMsg');
    const serverErrorAlert = document.getElementById('errorAlert');

    const namaInput = document.getElementById('nama');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const roleSelect = document.getElementById('role');

    // Mengendalikan penghantaran borang manual dan penapisan ralat (Client-side Validation)
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            // Menyembunyikan amaran sedia ada
            clientErrorAlert.classList.add('d-none');
            if (serverErrorAlert) {
                serverErrorAlert.classList.add('d-none');
            }

            let errorMessages = [];

            // 1. Validasi Nama Penuh (Tidak kurang 3 aksara)
            const namaValue = namaInput.value.trim();
            if (namaValue.length < 3) {
                errorMessages.push("Nama penuh mestilah sekurang-kurangnya 3 aksara.");
            }

            // 2. Validasi Kata Laluan (Minimum 6 aksara)
            const passwordValue = passwordInput.value;
            if (passwordValue.length < 6) {
                errorMessages.push("Kata laluan mestilah sekurang-kurangnya 6 aksara.");
            }

            // 3. Validasi Padanan Kata Laluan
            const confirmPasswordValue = confirmPasswordInput.value;
            if (passwordValue !== confirmPasswordValue) {
                errorMessages.push("Kata laluan dan pengesahan kata laluan tidak sepadan.");
            }

            // 4. Validasi Pemilihan Peranan (Role) - hanya untuk pendaftaran manual
            if (roleSelect && roleSelect.value === "") {
                errorMessages.push("Sila pilih peranan anda sebagai Pelanggan atau Penjahit.");
            }

            // Jika ada ralat dikesan, sekat form daripada dihantar dan paparkan amaran
            if (errorMessages.length > 0) {
                e.preventDefault(); // Menghalang proses penghantaran form ke servlet

                // Paparkan ralat pertama yang ditemui
                clientErrorMsg.textContent = errorMessages[0];
                clientErrorAlert.classList.remove('d-none');

                // Jalankan animasi gegaran (shake) pada kotak amaran
                clientErrorAlert.style.animation = 'none';
                clientErrorAlert.offsetHeight; /* Mencetuskan reflow */
                clientErrorAlert.style.animation = null;

                // Skrol ke atas kotak form secara lancar
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }
        });
    }

    // === INTEGRASI PENDAFTARAN MENGGUNAKAN GOOGLE (GOOGLE SIGN-IN) ===
    // Pendaftaran Google adalah automatik - tiada perlu isi borang atau pilih peranan
    // Peranan ditetapkan automatik sebagai PELANGGAN oleh sistem
    window.handleGoogleCredentialResponse = function(response) {
        // Bersihkan amaran ralat lama
        if (clientErrorAlert) clientErrorAlert.classList.add('d-none');
        if (serverErrorAlert) serverErrorAlert.classList.add('d-none');

        // Cipta form maya secara dinamik untuk diposkan ke RegisterServlet
        const dynamicForm = document.createElement('form');
        dynamicForm.method = 'POST';
        dynamicForm.action = registerForm.action;

        // Token Google JWT
        const credentialInput = document.createElement('input');
        credentialInput.type = 'hidden';
        credentialInput.name = 'googleToken';
        credentialInput.value = response.credential;
        dynamicForm.appendChild(credentialInput);

        // Penanda Google sign-in
        const aksiInput = document.createElement('input');
        aksiInput.type = 'hidden';
        aksiInput.name = 'aksi';
        aksiInput.value = 'google';
        dynamicForm.appendChild(aksiInput);

        document.body.appendChild(dynamicForm);
        dynamicForm.submit();
    };
});