/**
 * pagination.js - Universal Client-Side Pagination Helper for Sewvana
 */

window.initPagination = function(options) {
    const container = document.querySelector(options.containerSelector);
    if (!container) return null;

    const itemSelector = options.itemSelector;
    const itemsPerPage = options.itemsPerPage || 10;
    const paginationContainer = document.querySelector(options.paginationContainerSelector);
    if (!paginationContainer) return null;

    let currentPage = 1;

    function render() {
        const items = Array.from(container.querySelectorAll(itemSelector));
        
        // Tapis item yang tidak di-hide oleh carian frontend
        const visibleItems = items.filter(item => {
            const isSearchHidden = item.getAttribute('data-search-hidden') === 'true';
            return !isSearchHidden;
        });

        const totalItems = visibleItems.length;
        const totalPages = Math.ceil(totalItems / itemsPerPage) || 1;

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        const start = (currentPage - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        items.forEach(item => {
            item.classList.remove('sw-paginated-item');
        });

        visibleItems.forEach((item, index) => {
            if (index >= start && index < end) {
                item.style.display = '';
                item.classList.add('sw-paginated-item');
            } else {
                item.style.display = 'none';
            }
        });

        // Kekalkan carian filter
        items.forEach(item => {
            if (item.getAttribute('data-search-hidden') === 'true') {
                item.style.display = 'none';
            }
        });

        // Bina element pengawal pagination
        paginationContainer.innerHTML = '';
        if (totalPages <= 1) {
            return;
        }

        const nav = document.createElement('nav');
        const ul = document.createElement('ul');
        ul.className = 'pagination pagination-sm justify-content-center m-0 mt-3';

        // Prev Link
        const prevLi = document.createElement('li');
        const isPrevDisabled = (currentPage === 1);
        prevLi.className = 'page-item ' + (isPrevDisabled ? 'disabled' : '');
        const prevA = document.createElement('a');
        prevA.className = 'page-link';
        prevA.href = '#';
        prevA.innerHTML = '&laquo;';
        prevA.style.color = isPrevDisabled ? '#ccc' : '#6B4E9B';
        prevA.style.pointerEvents = isPrevDisabled ? 'none' : '';
        prevA.style.borderRadius = '50%';
        prevA.style.margin = '0 3px';
        prevA.style.width = '30px';
        prevA.style.height = '30px';
        prevA.style.display = 'flex';
        prevA.style.alignItems = 'center';
        prevA.style.justifyContent = 'center';
        prevA.addEventListener('click', function(e) {
            e.preventDefault();
            if (currentPage > 1) {
                currentPage--;
                render();
            }
        });
        prevLi.appendChild(prevA);
        ul.appendChild(prevLi);

        // Page Links
        for (let i = 1; i <= totalPages; i++) {
            const li = document.createElement('li');
            li.className = 'page-item ' + (currentPage === i ? 'active' : '');
            const a = document.createElement('a');
            a.className = 'page-link';
            a.href = '#';
            a.innerText = i;
            a.style.borderRadius = '50%';
            a.style.margin = '0 3px';
            a.style.width = '30px';
            a.style.height = '30px';
            a.style.display = 'flex';
            a.style.alignItems = 'center';
            a.style.justifyContent = 'center';
            
            if (currentPage === i) {
                a.style.backgroundColor = '#6B4E9B';
                a.style.borderColor = '#6B4E9B';
                a.style.color = '#fff';
            } else {
                a.style.color = '#6B4E9B';
                a.style.backgroundColor = 'transparent';
                a.style.borderColor = 'transparent';
            }
            a.addEventListener('click', function(e) {
                e.preventDefault();
                currentPage = i;
                render();
            });
            li.appendChild(a);
            ul.appendChild(li);
        }

        // Next Link
        const nextLi = document.createElement('li');
        const isNextDisabled = (currentPage === totalPages);
        nextLi.className = 'page-item ' + (isNextDisabled ? 'disabled' : '');
        const nextA = document.createElement('a');
        nextA.className = 'page-link';
        nextA.href = '#';
        nextA.innerHTML = '&raquo;';
        nextA.style.color = isNextDisabled ? '#ccc' : '#6B4E9B';
        nextA.style.pointerEvents = isNextDisabled ? 'none' : '';
        nextA.style.borderRadius = '50%';
        nextA.style.margin = '0 3px';
        nextA.style.width = '30px';
        nextA.style.height = '30px';
        nextA.style.display = 'flex';
        nextA.style.alignItems = 'center';
        nextA.style.justifyContent = 'center';
        nextA.addEventListener('click', function(e) {
            e.preventDefault();
            if (currentPage < totalPages) {
                currentPage++;
                render();
            }
        });
        nextLi.appendChild(nextA);
        ul.appendChild(nextLi);

        nav.appendChild(ul);
        paginationContainer.appendChild(nav);
    }

    render();

    return {
        update: function() {
            render();
        },
        reset: function() {
            currentPage = 1;
            render();
        }
    };
};
