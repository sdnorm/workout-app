const CACHE_NAME = "rp-trainer-v1"
const CACHED_URLS = [
  "/",
  "/workouts",
  "/runs",
  "/mesocycles",
  "/profile"
]

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(CACHED_URLS))
  )
})

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      )
    })
  )
})

self.addEventListener("fetch", (event) => {
  // Network-first strategy for API/dynamic content
  if (event.request.method !== "GET") return

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Cache successful responses
        if (response.ok) {
          const responseClone = response.clone()
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, responseClone))
        }
        return response
      })
      .catch(() => {
        // Fall back to cache when offline
        return caches.match(event.request)
      })
  )
})
