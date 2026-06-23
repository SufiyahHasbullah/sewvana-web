document.addEventListener('DOMContentLoaded', function() {

    // === 1. Inisialisasi AOS (Animate On Scroll) ===
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true,
        mirror: false
    });

    // === 2. Pertukaran Dinamik Navbar Semasa Scroll ===
    const navbar = document.querySelector('.navbar-custom');

    function checkScroll() {
        if (window.innerWidth > 991) { // Hanya aktif untuk paparan desktop sahaja
            if (window.scrollY > 60) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        } else {
            navbar.classList.add('scrolled');
        }
    }

    window.addEventListener('scroll', checkScroll);
    window.addEventListener('resize', checkScroll);
    checkScroll(); // Semakan awal sebaik sahaja halaman dimuatkan

    // === 3. Kesan Smooth Scroll Untuk Semua Pautan Menu ===
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const targetId = this.getAttribute('href');
            if (targetId !== '#') {
                e.preventDefault();
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    const offset = 80; // Mengimbangi ketinggian sticky navbar
                    const elementPosition = targetElement.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - offset;

                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            }
        });
    });

    // === 4. Animasi Count-Up untuk Bahagian Statistik ===
    const counterSection = document.querySelector('.counter-section');
    const counters = document.querySelectorAll('.counter-value');
    let started = false; // Memastikan fungsi hanya berjalan sekali sahaja

    function startCounting() {
        counters.forEach(counter => {
            const target = +counter.getAttribute('data-target');
            const speed = 200; // Kadar kelajuan nombor berpusing
            const increment = target / speed;

            const updateCount = () => {
                const count = +counter.innerText;
                if (count < target) {
                    counter.innerText = Math.ceil(count + increment);
                    setTimeout(updateCount, 1);
                } else {
                    counter.innerText = target + "+"; // Menambah simbol plus di akhir animasi
                }
            };
            updateCount();
        });
    }

    // Menggunakan Intersection Observer untuk mengesan bila skrin tiba di seksyen statistik
    if (counterSection) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !started) {
                    startCounting();
                    started = true;
                }
            });
        }, { threshold: 0.5 }); // Berjalan apabila 50% bahagian statistik muncul pada skrin

        observer.observe(counterSection);
    }
});