/**
 * =========================================================================
 * SEWVANA JAVASCRIPT KAWALAN ANTARAMUKA (URUS SLOT)
 * =========================================================================
 */
document.addEventListener("DOMContentLoaded", function() {
    const inputTarikh = document.getElementById('inputTarikhSlot');
    const displayTarikh = document.getElementById('displayTarikhTerpilih');
    const selectKuota = document.getElementById('selectMaxTempahan');
    const selectStatus = document.getElementById('selectStatusSlot');
    const chkUlangi = document.getElementById('chkUlangi');
    const lblUlangi = document.getElementById('lblUlangi');
    
    const modalElement = document.getElementById('modalEditSlot');
    let modalInstance = null;
    if (modalElement) {
        modalInstance = new bootstrap.Modal(modalElement);
    }

    // Auto status change logic
    if (selectKuota && selectStatus) {
        selectKuota.addEventListener('change', function() {
            if (this.value === "0") {
                selectStatus.value = "TUTUP";
            } else {
                selectStatus.value = "BUKA";
            }
        });
    }

    // =========================================================================
    // LOGIK KALENDAR URUS SLOT PENJAHIT INTERAKTIF
    // =========================================================================
    const prevMonthBtn = document.getElementById('prevMonthBtn');
    const nextMonthBtn = document.getElementById('nextMonthBtn');
    const monthYearTitle = document.getElementById('monthYearTitle');
    const calendarDaysContainer = document.getElementById('calendarDaysContainer');

    if (calendarDaysContainer && monthYearTitle) {
        let currentDate = new Date();
        let displayYear = currentDate.getFullYear();
        let displayMonth = currentDate.getMonth(); // 0 - 11

        const namaBulan = [
            "Januari", "Februari", "Mac", "April", "Mei", "Jun", 
            "Julai", "Ogos", "September", "Oktober", "November", "Disember"
        ];

        function renderCalendar(year, month) {
            monthYearTitle.textContent = `${namaBulan[month]} ${year}`;
            calendarDaysContainer.innerHTML = '';

            const firstDayIndex = new Date(year, month, 1).getDay();
            const totalDays = new Date(year, month + 1, 0).getDate();

            for (let i = 0; i < firstDayIndex; i++) {
                const emptyCell = document.createElement('div');
                emptyCell.className = 'calendar-day-cell other-month';
                calendarDaysContainer.appendChild(emptyCell);
            }

            const today = new Date();
            today.setHours(0, 0, 0, 0);

            for (let dayNum = 1; dayNum <= totalDays; dayNum++) {
                const cellDate = new Date(year, month, dayNum);
                const cellDateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(dayNum).padStart(2, '0')}`;

                const cell = document.createElement('div');
                cell.className = 'calendar-day-cell';

                const isPastDay = cellDate < today;
                if (isPastDay) {
                    cell.classList.add('past-day');
                }

                const slotData = dataSlotsSediaAda.find(s => s.tarikh === cellDateStr);
                let badgeText = "Tiada";
                
                if (slotData) {
                    if (slotData.status_slot === 'TUTUP') {
                        cell.classList.add('day-slot-tutup');
                        badgeText = "Tutup";
                    } else if (slotData.max_tempahan === 0) {
                        cell.classList.add('day-slot-tutup');
                        badgeText = "Penuh";
                    } else {
                        cell.classList.add('day-slot-buka');
                        badgeText = `${slotData.max_tempahan} Baju`;
                    }
                }

                cell.innerHTML = `
                    <span class="day-num">${dayNum}</span>
                    <span class="day-badge">${badgeText}</span>
                `;

                if (!isPastDay) {
                    cell.addEventListener('click', function() {
                        document.querySelectorAll('.calendar-day-cell').forEach(c => c.classList.remove('selected'));
                        cell.classList.add('selected');

                        // Set values in the modal form
                        if (inputTarikh) {
                            inputTarikh.value = cellDateStr;
                        }
                        
                        const options = { weekday: 'long' };
                        const nameOfDay = cellDate.toLocaleDateString('ms-MY', options);
                        
                        if (displayTarikh) {
                            displayTarikh.textContent = `${cellDateStr} (${nameOfDay})`;
                        }
                        
                        if (lblUlangi) {
                            lblUlangi.textContent = `Ulangi tetapan ini untuk setiap hari ${nameOfDay} (8 minggu)`;
                        }

                        if (chkUlangi) {
                            chkUlangi.checked = false;
                        }

                        if (slotData) {
                            if (selectKuota) selectKuota.value = slotData.max_tempahan;
                            if (selectStatus) selectStatus.value = slotData.status_slot;
                        } else {
                            if (selectKuota) selectKuota.value = "5";
                            if (selectStatus) selectStatus.value = "BUKA";
                        }

                        // Open modal
                        if (modalInstance) {
                            modalInstance.show();
                        }
                    });
                }

                calendarDaysContainer.appendChild(cell);
            }
        }

        renderCalendar(displayYear, displayMonth);

        if (prevMonthBtn) {
            prevMonthBtn.addEventListener('click', function() {
                displayMonth--;
                if (displayMonth < 0) {
                    displayMonth = 11;
                    displayYear--;
                }
                renderCalendar(displayYear, displayMonth);
            });
        }

        if (nextMonthBtn) {
            nextMonthBtn.addEventListener('click', function() {
                displayMonth++;
                if (displayMonth > 11) {
                    displayMonth = 0;
                    displayYear++;
                }
                renderCalendar(displayYear, displayMonth);
            });
        }
    }
});

function sahkanPenjadualan() {
    return confirm("Adakah anda pasti untuk menyimpan tetapan kuota slot bagi tarikh yang dipilih?");
}