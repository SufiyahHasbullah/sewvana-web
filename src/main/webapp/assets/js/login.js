document.addEventListener('DOMContentLoaded', function() {
     const loginForm = document.getElementById('loginForm');
     const clientErrorAlert = document.getElementById('clientErrorAlert');
     const clientErrorMsg = document.getElementById('clientErrorMsg');
     const serverErrorAlert = document.getElementById('errorAlert');

     const emailInput = document.getElementById('email');
     const passwordInput = document.getElementById('password');

     // Mengendalikan pengesahan borang pada bahagian klien (Client-side validation)
     if (loginForm) {
         loginForm.addEventListener('submit', function(e) {
             // Sembunyikan sebarang amaran lama
             clientErrorAlert.classList.add('d-none');
             if (serverErrorAlert) {
                 serverErrorAlert.classList.add('d-none');
             }

             let errorMessages = [];

             // 1. Validasi Emel tidak kosong
             const emailValue = emailInput.value.trim();
             if (emailValue === "") {
                 errorMessages.push("Sila masukkan alamat emel anda.");
             }

             // 2. Validasi Kata Laluan minimum 6 aksara
             const passwordValue = passwordInput.value;
             if (passwordValue.length < 6) {
                 errorMessages.push("Kata laluan mestilah sekurang-kurangnya 6 aksara.");
             }

             // Jika ralat dikesan, sekat form daripada dipos ke servlet
             if (errorMessages.length > 0) {
                 e.preventDefault();

                 // Paparkan mesej ralat pertama pada kotak amaran
                 clientErrorMsg.textContent = errorMessages[0];
                 clientErrorAlert.classList.remove('d-none');

                 // Cetus animasi gegaran (shake alert)
                 clientErrorAlert.style.animation = 'none';
                 clientErrorAlert.offsetHeight; /* Mencetuskan reflow */
                 clientErrorAlert.style.animation = null;

                 // Skrol ke atas secara lancar
                 window.scrollTo({
                     top: 0,
                     behavior: 'smooth'
                 });
             }
         });
     }

     // === INTEGRASI INTEGRITY GOOGLE SIGN-IN ===
     // Fungsi callback global untuk mengendalikan maklum balas token JWT daripada Google
     window.handleGoogleCredentialResponse = function(response) {
         // Bersihkan amaran ralat lama
         clientErrorAlert.classList.add('d-none');
         if (serverErrorAlert) {
             serverErrorAlert.classList.add('d-none');
         }

         // Cipta form dinamik untuk diposkan ke LoginServlet
         const dynamicForm = document.createElement('form');
         dynamicForm.method = 'POST';
         dynamicForm.action = loginForm.action; // Menghala ke LoginServlet yang sama

         // Masukkan Token Google Credential (JWT)
         const credentialInput = document.createElement('input');
         credentialInput.type = 'hidden';
         credentialInput.name = 'googleToken';
         credentialInput.value = response.credential;

         // Masukkan penanda log masuk menerusi Google
         const isGoogleInput = document.createElement('input');
         isGoogleInput.type = 'hidden';
         isGoogleInput.name = 'aksi';
         isGoogleInput.value = 'google';

         dynamicForm.appendChild(credentialInput);
         dynamicForm.appendChild(isGoogleInput);

         document.body.appendChild(dynamicForm);

         // Hantar form ke servlet
         dynamicForm.submit();
     };
 });