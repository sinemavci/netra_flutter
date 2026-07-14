# Changelog

## 0.1.0-alpha

Initial alpha release.

### Features

- **HTTP Methods** — GET, POST, PUT, PATCH, DELETE support via a clean async/await API
- **Streaming** — `getStream` for chunk-by-chunk consumption of large responses (images, files, audio)
- **Multipart Upload** — file and binary upload support via `RequestBody.multipart`
- **Offline Policies** — configurable behavior when the device is offline:
    - `queue` — persist request to disk, retry automatically when connection is restored
    - `retry` — retry N times with configurable interval
    - `useCache` — serve cached response as fallback
    - `throwError` — immediately surface the network error
- **Slow Network Policies** — configurable behavior on degraded connections:
    - `timeout` — enforce a strict call timeout
    - `wait` — delay the request by a given duration
    - `useCache` — return cached response immediately
- **Smart Cache** — memory + disk cache with TTL support; reports hit, miss, stored, expired, and stale-used events
- **Offline Queue Restoration** — queued requests are automatically retried when connectivity is restored, powered by Room on the Android side
- **Event-Driven Observers** — subscribe to request, cache, queue, and network lifecycle events via `on()` / `off()`
- **Converter Support** — Gson, KotlinX Serialization, Moshi
- **Circuit Breaker** — configurable failure threshold and retry delay
- **Per-Request Headers** — headers can be set globally on the client or per request
- **Cancel on Dispose** — requests marked with `cancelOnDispose: true` are automatically cancelled when the widget is disposed

### Platform Support

| Platform | Support |
|---|---|
| Android | ✅ |
| iOS | 🔜 Planned |
