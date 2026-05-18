# Netra Flutter Plugin

A powerful Flutter networking plugin with built-in caching, offline queueing, slow network strategies, circuit breaker support, multipart uploads, and event-driven observability.

---

## Features

- ⚡ Simple async/await API
- 📡 Offline request handling (queue / retry / cache fallback)
- 🐢 Slow network strategies (wait / cache / fallback)
- 🧠 Smart cache system
- 👀 Event-driven observers (cache, queue, network)
- 🧩 JSON + binary + multipart support
- 🔄 Request retry mechanisms
- 🔥 Circuit breaker support
- 📦 Converter support (Gson, KotlinX, etc.)
- 🧵 Fully async Dart API

---

# Basic Usage

## Create Client

```dart
val client = await NetraClient.build(
   baseUrl: "https://api.example.com",
   headers: {
   "Authorization": "Bearer token"
   },
   convertedType: ConverterType.gson,
   circuitBreakerOptions: CircuitBreakerOptions(),
);
```

---

# GET Request

```dart
final result = await netraClient.get(
   url: "/users",
);
```

# POST Request

```dart
final result = await netraClient.post(
    url: "/users",
    body: RequestBody.createJson(
    jsonEncode({"name": "Sinem", "job": "developer"}),
   ),
);
```

---

# PUT Request

```dart
final result = await netraClient.put(
    url: "/users/1",
    body: RequestBody.createJson(
    jsonEncode({"name": "Sinem", "job": "mobile developer"}),
  ),
);
```

---

# PATCH Request

```dart
final result = await netraClient.patch(
    url: "/users/1",
    body: RequestBody.createJson(
    jsonEncode({"name": "Sinem"}),
  ),
);
```

---

# DELETE Request

```dart
final result = await netraClient.delete(
    url: "/users/1",
);
```

---

---

# Multipart Upload (Image)

```dart
final requestBodyPart = RequestBodyPart.file(
  name: "image",
  fileName: "exampleImage",
  bytes: bytes,
  contentType: "image/jpeg",
);

final requestBody = RequestBody.multipart([requestBodyPart]);

final result = await netraClient.post(
url: "/upload",
body: requestBody,
);
```

---
## Cache Events

Netra provides detailed cache lifecycle events to help developers monitor cache behavior and debug networking flows.

| Event | Description | Typical Scenario |
|---|---|---|
| `CacheHit` | Triggered when valid cached data is found and returned successfully. | User opens a screen and data is loaded directly from cache without a network request. |
| `CacheMiss` | Triggered when no cache entry exists for the requested resource. | First request to an endpoint before any cache has been stored. |
| `CacheStored` | Triggered after a successful network response is saved into cache storage. | Fresh API response is persisted for future offline or fast access usage. |
| `CacheExpired` | Triggered when cached data exists but its expiration time has passed. | SDK checks cache age and determines it is no longer valid. |
| `StaleCacheUsed` | Triggered when expired cache data is intentionally returned as a fallback strategy. | Network is slow/offline and SDK serves expired cache to improve UX. |

Example:

```dart
netraClient.on(CacheEvent.cacheExpired((key, ageMs, ttlMs, expiredByMs) {
   print("cache expired: $key");
}));

netraClient.on(CacheEvent.cacheMiss((key) {
   print("cache miss");
}));

netraClient.on(CacheEvent.cacheStored((key, ageMs, ttlMs) {
   print("cache stored");
}));

netraClient.on(CacheEvent.cacheStaleUsed((key, ageMs, ttlMs, expiredByMs) {
   print("stale cache used");
}));
```

---

# Offline Support

Netra can automatically queue requests while the device is offline.

```dart
requestOptions: RequestOptions(
   offlineNetworkPolicyAction: OfflinePolicyAction.USE_CACHE,
)

netraClient.on(QueueEvent.requestQueued((key, a, b) {
   print("queued request: $key");
}));

netraClient.on(QueueEvent.queuedRequestRestored((key) {
   print("queue restored: $key");
}));

netraClient.on(QueueEvent.queuedRequestExecuted((key, response) {
   print("executed: $key");
}));
```

Available offline actions:

| Action | Description |
|---|---|
| `QUEUE` | Stores request and retries later |
| `USE_CACHE` | Uses cached response |
| `THROW_ERROR` | Throws network error |

---

# Slow Network Strategies

```dart
requestOptions: RequestOptions(
   slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
)
```

Available actions:

| Action | Description |
|---|---|
| `USE_CACHE` | Returns cache immediately |
| `WAIT` | Waits for network response |
| `THROW_ERROR` | Throws timeout/network error |

---

# Queue Events

Netra exposes detailed queue lifecycle events.

Available events:

- `RequestQueued`
- `QueuedRequestRestored`
- `QueuedRequestExecuted`
- `QueuedRequestFailed`

Example:

```dart
netraClient.on(QueueEvent.requestQueued((key, a, b) {
   print("queued request: $key");
}));

netraClient.on(QueueEvent.queuedRequestRestored((key) {
   print("queue restored: $key");
}));

netraClient.on(QueueEvent.queuedRequestExecuted((key, response) {
   print("executed: $key");
}));
```

---

# Observers

Attach observers to monitor request lifecycle events.

```dart
final eventId = netraClient.on(
  CacheEvent.cacheStaleUsed((key, ageMs, ttlMs, expiredByMs) {
    print("stale cache used");
  }),
);

// remove listener
netraClient.off(eventId);
```

---

# Custom Headers

## Global Headers

```kotlin
val client = NetraClient.Builder(applicationContext)
    .addHeaders(
        mapOf(
            "Authorization" to "Bearer token"
        )
    )
    .build()
```

---

## Request Headers

```kotlin
client.get("/users")
    .addHeaders(
        mapOf(
            "Custom-Header" to "value"
        )
    )
```

---

# Converter Support

## Kotlinx Serialization

```kotlin
val client = NetraClient.Builder(applicationContext)
    .addConverterFactory(
        NetraKotlinxConverter()
    )
    .build()
```

---

# Circuit Breaker

```dart
final netraClient = await NetraClient.build(
   baseUrl: "https://api.example.com",
   circuitBreakerOptions: CircuitBreakerOptions(),
);
```

---

# Example Response

```kotlin
result?.statusCode
result?.statusMessage
result?.headers
result?.data
```

---

# Roadmap

- [ ] WebSocket support
- [ ] Logging interceptor
- [ ] Request deduplication
---

# Why Netra?

Netra focuses on real-world mobile networking problems:

- unreliable connections
- offline-first architecture
- slow networks
- cache consistency
- request recovery
- developer observability

Instead of only being an HTTP client, Netra aims to provide a resilient networking layer for modern Android applications.

---

# License

```text
MIT License
```
