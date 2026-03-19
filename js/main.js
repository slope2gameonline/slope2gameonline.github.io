// URL Normalization for All Pages
// Redirects .html, index.html, and redundant trailing slashes to clean URLs
(function() {
    const path = window.location.pathname; // e.g., '/drift-boss.html', '/about-us/index.html', '/404.html'
    let cleanPath = path;

    // 1. Remove index.html (leaves the trailing slash)
    if (cleanPath.endsWith('index.html')) {
        cleanPath = cleanPath.slice(0, -10); // '/about-us/index.html' -> '/about-us/'
        if (cleanPath === '') cleanPath = '/';
    }
    // 2. Remove .html for other files
    else if (cleanPath.endsWith('.html')) {
        cleanPath = cleanPath.slice(0, -5); // '/404.html' -> '/404'
    }

    // 3. Remove trailing slash ONLY if it matches a valid game slug
    // (We keep trailing slashes for directories like /about-us/ to avoid infinite 301 loops)
    if (cleanPath.length > 1 && cleanPath.endsWith('/')) {
        const potentialSlug = cleanPath.slice(0, -1);
        if (typeof ALL_GAMES !== 'undefined' && ALL_GAMES.includes(potentialSlug)) {
            cleanPath = potentialSlug;
        }
    }

    // 4. Redirect if the URL was cleaned
    if (cleanPath !== path) {
        const newUrl = window.location.origin + cleanPath + window.location.search + window.location.hash;
        window.location.replace(newUrl);
    }
})();

document.addEventListener('DOMContentLoaded', () => {
    // console.log('Slope 2: Scripts initializing...');

    // 1. Mobile Menu Toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    if (menuToggle && navLinks) {
        menuToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            menuToggle.textContent = navLinks.classList.contains('active') ? '✕' : '☰';
        });
    }

    // 1b. Search dropdown (suggestions as you type — click game to go, no need to press Enter)
    try {
        const headerSearchForm = document.querySelector('.header-search');
        const headerSearchInput = headerSearchForm ? headerSearchForm.querySelector('input[name="q"]') : null;
        if (headerSearchForm && headerSearchInput && typeof ALL_GAMES !== 'undefined' && typeof GAME_TITLES !== 'undefined') {
            const wrapper = document.createElement('div');
            wrapper.className = 'search-dropdown-wrapper';
            headerSearchForm.parentNode.insertBefore(wrapper, headerSearchForm);
            wrapper.appendChild(headerSearchForm);

            const dropdown = document.createElement('div');
            dropdown.className = 'search-dropdown';
            dropdown.setAttribute('role', 'listbox');
            dropdown.setAttribute('aria-label', 'Game suggestions');
            wrapper.appendChild(dropdown);

            let hideTimeout = null;
            function updateDropdown() {
                const q = (headerSearchInput.value || '').trim().toLowerCase();
                dropdown.innerHTML = '';
                if (q.length < 1) {
                    dropdown.style.display = 'none';
                    return;
                }
                const matched = ALL_GAMES.filter(slug => (GAME_TITLES[slug] || '').toLowerCase().includes(q));
                const list = matched.slice(0, 10);
                list.forEach(slug => {
                    const title = GAME_TITLES[slug] || slug;
                    const a = document.createElement('a');
                    // Ensure slug starts with / for absolute navigation
                    const cleanSlug = slug.startsWith('/') ? slug : '/' + slug;
                    a.href = cleanSlug;
                    a.className = 'search-dropdown-item';
                    a.setAttribute('role', 'option');
                    
                    const thumbSlug = slug.replace(/\//g, '');
                    const img = document.createElement('img');
                    img.className = 'search-dropdown-thumb';
                    img.src = '/assets/' + thumbSlug + '-cover.webp';
                    img.alt = title;
                    img.loading = 'lazy';
                    img.onerror = function () { this.style.display = 'none'; };
                    a.appendChild(img);

                    const span = document.createElement('span');
                    span.className = 'search-dropdown-title';
                    span.textContent = title;
                    a.appendChild(span);
                    dropdown.appendChild(a);
                });
                dropdown.style.display = list.length ? 'block' : 'none';
            }

            headerSearchInput.addEventListener('input', () => updateDropdown());
            headerSearchInput.addEventListener('focus', () => { clearTimeout(hideTimeout); updateDropdown(); });
            headerSearchInput.addEventListener('blur', () => {
                hideTimeout = setTimeout(() => { dropdown.innerHTML = ''; dropdown.style.display = 'none'; }, 180);
            });
            dropdown.addEventListener('mousedown', (e) => e.preventDefault()); // keep focus so blur doesn't hide before click
        }
    } catch (err) { console.warn('Slope 2: Search dropdown init failed', err); }

    // 2. Dynamic Current Year
    const yearSpan = document.getElementById('current-year');
    if (yearSpan) yearSpan.textContent = new Date().getFullYear();

    // 3. Game Play Overlay
    const gameOverlay = document.getElementById('game-overlay');
    const playBtnLarge = document.getElementById('play-btn-large');
    const gameIframe = document.getElementById('game-iframe');
    const gameContainer = document.getElementById('game-container');

    // Blurred background layer (same cover image) — reference-style layout
    const gameCoverImg = document.querySelector('.game-overlay .game-cover');
    if (gameOverlay && gameCoverImg && !document.querySelector('.game-cover-bg')) {
        // Skip background image on small mobile screens to save memory/rendering
        if (window.innerWidth > 768) {
            const bg = document.createElement('img');
            bg.className = 'game-cover-bg';
            bg.src = gameCoverImg.src;
            bg.alt = '';
            bg.setAttribute('aria-hidden', 'true');
            gameOverlay.insertBefore(bg, gameOverlay.firstChild);
        } else {
            // Simple solid background for mobile
            gameOverlay.style.backgroundColor = 'rgba(0,0,0,0.8)';
        }
    }

    // Add "PLAY NOW" text to button if missing
    if (playBtnLarge && !playBtnLarge.querySelector('.play-btn-text')) {
        const span = document.createElement('span');
        span.className = 'play-btn-text';
        span.textContent = 'PLAY NOW';
        playBtnLarge.appendChild(span);
    }

    const startGame = () => {
        if (!gameIframe || !gameOverlay) return;
        const src = gameIframe.getAttribute('data-src');
        if (src) {
            gameIframe.setAttribute('src', src);
        }
        gameOverlay.classList.add('hidden');
        setTimeout(() => gameIframe.focus(), 300);
    };

    if (gameOverlay && playBtnLarge && gameIframe) {
        playBtnLarge.addEventListener('click', (e) => { e.stopPropagation(); startGame(); });
        gameOverlay.addEventListener('click', () => startGame());
    }

    // 4. Game Actions (Theater, Fullscreen, Favorite, Share)
    try {
        const btnTheater = document.getElementById('btn-theater');
        const btnFullscreen = document.getElementById('btn-fullscreen');
        const btnFavorite = document.getElementById('btn-favorite');
        const btnShare = document.getElementById('btn-share');
        const gameContainerForActions = document.getElementById('game-container');

        const toggleTheaterMode = (forceOff = false) => {
            if (!btnTheater || !gameContainerForActions) return;

            const isCurrentlyTheater = document.body.classList.contains('theater-mode');
            const shouldBeTheater = forceOff ? false : !isCurrentlyTheater;

            if (isCurrentlyTheater === shouldBeTheater) return;

            document.body.classList.toggle('theater-mode', shouldBeTheater);
            document.documentElement.classList.toggle('theater-mode', shouldBeTheater);

            const span = btnTheater.querySelector('span');
            if (span) {
                span.textContent = shouldBeTheater ? 'Shrink' : 'Expand';
                btnTheater.title = shouldBeTheater ? 'Exit Theater Mode' : 'Theater Mode';
            }

            if (!shouldBeTheater) {
                setTimeout(() => gameContainerForActions.scrollIntoView({ behavior: 'smooth', block: 'center' }), 50);
                if (gameContainerForActions) gameContainerForActions.style.transform = '';
            } else {
                if (gameContainerForActions) gameContainerForActions.style.transform = 'none';
            }
        };

        if (btnTheater && gameContainerForActions) {
            btnTheater.addEventListener('click', () => toggleTheaterMode());
        }

        if (btnFullscreen) {
            btnFullscreen.addEventListener('click', () => {
                const target = gameContainerForActions;
                if (!target) return;

                if (document.fullscreenElement || document.webkitFullscreenElement) {
                    if (document.exitFullscreen) document.exitFullscreen();
                    else if (document.webkitExitFullscreen) document.webkitExitFullscreen();
                    return;
                }

                try {
                    if (target.requestFullscreen) target.requestFullscreen();
                    else if (target.webkitRequestFullscreen) target.webkitRequestFullscreen();
                    else if (target.mozRequestFullScreen) target.mozRequestFullScreen();
                    else if (target.msRequestFullscreen) target.msRequestFullscreen();
                } catch (err) {
                    console.warn('Fullscreen request failed', err);
                }
            });
        }

        // Global Escape key listener
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                // Exit Theater Mode if active
                if (document.body.classList.contains('theater-mode')) {
                    toggleTheaterMode(true);
                }
                // Exit Fullscreen if active
                if (document.fullscreenElement || document.webkitFullscreenElement) {
                    if (document.exitFullscreen) document.exitFullscreen();
                    else if (document.webkitExitFullscreen) document.webkitExitFullscreen();
                }
            }
        });

        if (btnFavorite) {
            const svg = btnFavorite.querySelector('svg');
            const span = btnFavorite.querySelector('span');
            const getFavorites = () => {
                try { return JSON.parse(localStorage.getItem('slope_favorites')) || []; }
                catch (e) { return []; }
            };
            
            // Normalize path to prevent duplicates (remove trailing slash and index.html, ensure it starts with /)
            const normalizePath = (p) => {
                let normalized = p.replace(/\/index\.html$/, '').replace(/\/$/, '');
                if (!normalized.startsWith('/')) normalized = '/' + normalized;
                return normalized || '/';
            };
            const currentPath = normalizePath(window.location.pathname);
            
            let favorites = getFavorites();
            let isFavorited = favorites.some(g => normalizePath(g.url) === currentPath);

            const updateFavUI = () => {
                if (isFavorited) {
                    if (svg) svg.setAttribute('fill', 'currentColor');
                    if (span) span.textContent = 'Favorited';
                    btnFavorite.style.color = '#ff4d4d';
                    btnFavorite.style.borderColor = '#ff4d4d';
                } else {
                    if (svg) svg.setAttribute('fill', 'none');
                    if (span) span.textContent = 'Favorite';
                    btnFavorite.style.color = '';
                    btnFavorite.style.borderColor = '';
                }
            };
            updateFavUI();

            btnFavorite.addEventListener('click', () => {
                let favs = getFavorites();
                if (isFavorited) {
                    favs = favs.filter(g => normalizePath(g.url) !== currentPath);
                } else {
                    const title = document.querySelector('h1') ? document.querySelector('h1').textContent : 'Slope 2 Game';
                    const imgEl = document.querySelector('.game-cover');
                    const img = imgEl ? imgEl.src : '/favicon.webp';
                    favs.push({ title, url: window.location.pathname, img });
                }
                localStorage.setItem('slope_favorites', JSON.stringify(favs));
                isFavorited = !isFavorited;
                updateFavUI();
            });

            // Sync if changed in another tab
            window.addEventListener('storage', (e) => {
                if (e.key === 'slope_favorites') {
                    const newFavs = getFavorites();
                    isFavorited = newFavs.some(g => normalizePath(g.url) === currentPath);
                    updateFavUI();
                }
            });
        }

        if (btnShare) {
            btnShare.addEventListener('click', async () => {
                try {
                    await navigator.clipboard.writeText(window.location.href);
                    const span = btnShare.querySelector('span');
                    const originalText = span ? span.textContent : '';
                    if (span) span.textContent = 'Copied!';
                    setTimeout(() => { if (span) span.textContent = originalText; }, 2000);
                } catch (err) { console.error('Failed to copy: ', err); }
            });
        }
    } catch (err) { console.warn('Slope 2: Game actions init failed', err); }

    // 4b. How to Play popup — bên phải, song song màn hình chơi, chỉ Game Controls
    const btnHowTo = document.getElementById('btn-how-to');
    const howToPanel = document.getElementById('game-how-to-panel');
    const howToClose = document.querySelector('.game-how-to-close');
    const gameContainerForPanel = document.getElementById('game-container');
    if (btnHowTo && howToPanel) {
        function alignHowToPanelWithGame() {
            if (!howToPanel || !gameContainerForPanel) return;

            // Đưa popup ra khỏi các thẻ có position:relative để absolute hoạt động chính xác theo toàn trang
            if (howToPanel.parentElement !== document.body) {
                document.body.appendChild(howToPanel);
            }

            // In theater mode, we want the panel to be a fixed overlay, not shift the game
            if (document.body.classList.contains('theater-mode')) {
                howToPanel.style.position = 'fixed';
                if (gameContainerForPanel) gameContainerForPanel.style.transform = 'none';
                return;
            }

            howToPanel.style.position = 'absolute';
            gameContainerForPanel.style.transform = '';

            // Lấy tọa độ thực tế của game sau khi đã reset transform
            const rect = gameContainerForPanel.getBoundingClientRect();
            const scrollTop = window.scrollY || document.documentElement.scrollTop;
            const scrollLeft = window.scrollX || document.documentElement.scrollLeft;

            const panelW = 260;
            const gap = 10; // Cách khung game 10px
            const margin = 10; // Cách mép màn hình tối thiểu 10px

            howToPanel.style.top = (rect.top + scrollTop) + 'px';
            howToPanel.style.height = rect.height + 'px';

            let desiredLeft = rect.right + gap + scrollLeft;
            let shiftAmount = 0;
            const clientWidth = document.documentElement.clientWidth;

            // Nếu popup bị tràn ra mép phải
            if (rect.right + gap + panelW > clientWidth - margin) {
                shiftAmount = (rect.right + gap + panelW) - (clientWidth - margin);
                // Tránh đẩy container game tràn mép trái
                if (rect.left - shiftAmount < margin) {
                    shiftAmount = Math.max(0, rect.left - margin);
                }
            }

            if (howToPanel.classList.contains('open') && shiftAmount > 0) {
                gameContainerForPanel.style.transform = `translateX(-${shiftAmount}px)`;
                gameContainerForPanel.style.transition = 'transform 0.25s ease';
                desiredLeft -= shiftAmount;
            } else {
                gameContainerForPanel.style.transform = 'translateX(0)';
            }

            howToPanel.style.left = desiredLeft + 'px';
            howToPanel.style.right = 'auto';
        }
        if (gameContainerForPanel) {
            alignHowToPanelWithGame();
            window.addEventListener('resize', alignHowToPanelWithGame);
        }
        btnHowTo.addEventListener('click', () => {
            howToPanel.classList.toggle('open');
            alignHowToPanelWithGame();
        });
        if (howToClose) howToClose.addEventListener('click', () => {
            howToPanel.classList.remove('open');
            alignHowToPanelWithGame();
        });
    }

    // 5. Back to Top
    const backToTopBtn = document.getElementById('back-to-top');
    if (backToTopBtn) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) backToTopBtn.classList.add('show');
            else backToTopBtn.classList.remove('show');
        });
        backToTopBtn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
    }

    // 6. Theme Toggle (chạy chỉ cần nút; icon tìm trong nút để tránh nhầm)
    const themeToggleBtn = document.getElementById('theme-toggle');
    if (themeToggleBtn) {
        const iconMoon = themeToggleBtn.querySelector('.icon-moon');
        const iconSun = themeToggleBtn.querySelector('.icon-sun');
        if (localStorage.getItem('theme') === 'light') {
            document.documentElement.classList.add('light-mode');
            if (iconMoon) iconMoon.style.display = 'none';
            if (iconSun) iconSun.style.display = 'block';
        }
        themeToggleBtn.addEventListener('click', () => {
            document.documentElement.classList.toggle('light-mode');
            const isLight = document.documentElement.classList.contains('light-mode');
            localStorage.setItem('theme', isLight ? 'light' : 'dark');
            if (iconMoon) iconMoon.style.display = isLight ? 'none' : 'block';
            if (iconSun) iconSun.style.display = isLight ? 'block' : 'none';
        });
    }

    // 7. Cookie Banner - Only show on Home page once per day
    const cookieBanner = document.getElementById('cookie-banner');
    const btnAcceptCookies = document.getElementById('btn-accept-cookies');
    if (cookieBanner && btnAcceptCookies) {
        const isHomePage = window.location.pathname === '/' || window.location.pathname === '/index.html' || window.location.pathname === '';
        const today = new Date().toDateString();
        const lastShown = localStorage.getItem('slope_cookie_last_day');
        const hasAccepted = localStorage.getItem('slope_cookie_consent') === 'true';

        // Only show if on homepage AND hasn't been shown today AND hasn't been accepted yet
        if (isHomePage && lastShown !== today && !hasAccepted) {
            setTimeout(() => {
                cookieBanner.classList.add('show');
                localStorage.setItem('slope_cookie_last_day', today);
            }, 1500);
        } else {
            cookieBanner.style.display = 'none';
        }

        btnAcceptCookies.addEventListener('click', () => {
            localStorage.setItem('slope_cookie_consent', 'true');
            cookieBanner.classList.remove('show');
            setTimeout(() => cookieBanner.style.display = 'none', 500);
        });
    }

    // 8. Random Game (ALL_GAMES từ games_data.js; fallback về trang chủ hoặc all.games)
    const btnRandom = document.getElementById('btn-random');
    if (btnRandom) {
        btnRandom.addEventListener('click', (e) => {
            e.preventDefault();
            if (typeof ALL_GAMES !== 'undefined' && Array.isArray(ALL_GAMES) && ALL_GAMES.length > 0) {
                const randomUrl = ALL_GAMES[Math.floor(Math.random() * ALL_GAMES.length)];
                window.location.href = randomUrl;
            } else {
                window.location.href = '/all.games/' || '/';
            }
        });
    }

    // 9. Scroll Reveal — hiện ngay phần trong viewport, còn lại khi scroll; fail-safe 600ms
    const revealElements = document.querySelectorAll('.reveal');
    if (revealElements.length > 0) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('reveal-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.05, rootMargin: '0px 0px -20px 0px' });
        revealElements.forEach(el => observer.observe(el));

        // Hiện ngay mọi .reveal sau 600ms nếu observer chưa kịp (trang không trống)
        // setTimeout(() => { // Removed artificial delay
        //     revealElements.forEach(el => el.classList.add('reveal-visible'));
        // }, 600);
    }

    // 10. PWA Install Prompt (Enhanced)
    let deferredPrompt;
    const installBtn = document.createElement('button');
    installBtn.className = 'pwa-install-prompt';
    installBtn.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg><span>Install App</span>`;
    document.body.appendChild(installBtn);

    window.addEventListener('beforeinstallprompt', (e) => {
        // console.log('Slope 2: PWA Install available');
        e.preventDefault();
        deferredPrompt = e;
        installBtn.classList.add('show');
    });

    // Forcedfully show for testing
    // setTimeout(() => {
    //     installBtn.classList.add('show');
    // }, 100); // Removed artificial delay to free up main thread

    installBtn.addEventListener('click', () => {
        if (!deferredPrompt) return;
        installBtn.classList.remove('show');
        deferredPrompt.prompt();
        deferredPrompt.userChoice.then((choiceResult) => {
            // console.log('Slope 2: PWA Install choice:', choiceResult.outcome);
            deferredPrompt = null;
        });
    });

    // 11. Skeleton Removal (Forced visible time for demo/verification)
    const gameCards = document.querySelectorAll('.game-card');
    gameCards.forEach(card => {
        card.classList.add('skeleton');
        const img = card.querySelector('img');
        if (img) {
            const removeSkeleton = () => {
                card.classList.remove('skeleton');
            };
            if (img.complete) removeSkeleton();
            else {
                img.addEventListener('load', removeSkeleton);
                img.addEventListener('error', removeSkeleton);
            }
        } else {
            card.classList.remove('skeleton');
        }
    });

    // Check if already in standalone mode
    if (window.matchMedia('(display-mode: standalone)').matches) {
        // console.log('Slope 2: Running in PWA mode');
        installBtn.style.display = 'none';
    }
});

// --- Preloader: ẩn ngay khi DOM sẵn sàng, không chờ hết ảnh/font (tránh kẹt load) ---
const hidePreloader = () => {
    const preloader = document.getElementById('preloader');
    if (preloader) {
        preloader.style.opacity = '0';
        preloader.style.visibility = 'hidden';
        setTimeout(() => preloader.remove(), 200);
    }
};
const scheduleHide = () => setTimeout(hidePreloader, 50);
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', scheduleHide);
} else {
    scheduleHide();
}
window.addEventListener('load', scheduleHide);
setTimeout(hidePreloader, 600); // Reduced fallback

// --- SW Registration ---
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js').then(() => {
            // console.log('Slope 2: Service Worker Registered');
        }).catch(err => console.log('Slope 2: SW Registration failed: ', err));
    });
}
