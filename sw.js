const CACHE_NAME = 'slope2game-v1';
const ASSETS = [
    '/',
    '/index.html',
    '/css/style.css',
    '/js/main.js',
    '/favicon.png',
    '/manifest.json'
];

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(ASSETS))
    );
});

self.addEventListener('fetch', event => {
    // Basic Network-First strategy: try network, fallback to cache
    event.respondWith(
        fetch(event.request)
            .then(networkResponse => {
                // If it's a valid response, clone it and update the cache
                if (networkResponse && networkResponse.status === 200) {
                    const responseClone = networkResponse.clone();
                    caches.open(CACHE_NAME).then(cache => {
                        cache.put(event.request, responseClone);
                    });
                }
                return networkResponse;
            })
            .catch(() => {
                // If network fails, try the cache
                return caches.match(event.request);
            })
    );
});

