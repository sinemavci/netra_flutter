# Netra Flutter Plugin

Built on top of a native Kotlin networking engine.
A powerful Flutter networking plugin with built-in caching, offline queueing, slow network strategies, circuit breaker support, multipart uploads, and event-driven observability.

Available Platforms

- ✅ Kotlin Android
- ✅ Flutter
- ✅ React Native
- 🚧 iOS

---

## ⚙️ Installation
```sh
flutter pub add netra_flutter
```

---

## Why Netra?

Netra focuses on real-world mobile networking problems:

- Unreliable connections
- Offline-first architecture
- Slow networks
- Cache consistency
- Request recovery
- Developer observability

Instead of only being an HTTP client, Netra aims to provide a resilient networking layer for modern Flutter applications.

## Netra vs Dio Ecosystem

Most Netra features can be implemented with Dio and additional packages.

The difference is that Netra provides them as a unified networking layer out of the box.

| Capability | Dio Ecosystem | Netra |
|------------|---------------|--------|
| HTTP Requests | Dio | Built-in |
| Multipart Upload | Dio | Built-in |
| Request Cancellation | Dio | Built-in |
| Caching | Dio + dio_cache_interceptor | Built-in |
| Offline Cache Fallback | Dio + dio_cache_interceptor configuration | Built-in |
| Offline Queue | Custom implementation | Built-in |
| Retry On Reconnect | offline_retry_interceptor + custom persistence | Built-in |
| Slow Network Policies | Custom implementation | Built-in |
| Circuit Breaker | Custom implementation | Built-in |
| Request Lifecycle Events | Custom interceptors | Built-in |
| Cache Events | Custom implementation | Built-in |
| Queue Events | Custom implementation | Built-in |
| Unified API | Multiple packages | Single SDK |

---

## Quick Example

```dart
final client = NetraClient(
  baseUrl: "https://api.example.com",
);

client.on(RequestEvent.requestExecuted((request) {
print("executing: ${request.url}");
}));

client.on(RequestEvent.requestSuccess((request, response) {
print("success: ${response.statusCode} data: ${response.data}");
}));

client.on(RequestEvent.requestFailed((request, response) {
print("failed: ${response?.statusCode}");
}));

final response = await client.get(
  requestOptions: RequestOptions(
    url: "/users",
    cacheOptions: CacheOptions(ttl: 60000),
    offlinePolicyAction: OfflinePolicyAction.queue,
    slowNetworkPolicyAction: SlowNetworkPolicyAction.useCache,
  ),
);
```

## Features

- ⚡ Simple async/await API
- 📦 GET, POST, PUT, PATCH, DELETE support
- 🧠 Smart cache system (memory + disk)
- 📡 Offline request handling (queue / retry / cache fallback)
- 🐢 Slow network strategies (wait / timeout / cache fallback)
- 👀 Event-driven observers (request, cache, queue, network)
- 🖼 Multipart file/image upload
- 📥 Streaming support for large responses
- 🔄 Automatic queued request restoration
- 🔥 Circuit breaker support
- 🧩 Converter support (Gson, KotlinX, Moshi)
- 🛑 Request cancellation on dispose
- 🧵 Fully async Dart API

---

## Create Client

```dart
final netraClient = NetraClient(
  baseUrl: "https://api.example.com",
  headers: {
    "Authorization": "Bearer token",
  },
  converterType: ConverterType.gson,
);
```

With circuit breaker:

```dart
final netraClient = NetraClient(
  baseUrl: "https://api.example.com",
  converterType: ConverterType.gson,
  circuitBreakerOptions: CircuitBreakerOptions(
    failureThreshold: 5,
    retryDelayMs: 1000,
  ),
);
```

---

## RequestOptions

All requests are configured via `RequestOptions`:

```dart
RequestOptions(
  url: "/users",                          // required
  body: null,                             // RequestBody?
  headers: {"X-Custom": "value"},         // per-request headers
  offlinePolicyAction: ...,               // OfflinePolicyAction?
  slowNetworkPolicyAction: ...,           // SlowNetworkPolicyAction?
  cacheOptions: CacheOptions(),           // cache config
  cancelOnDispose: true,                  // auto-cancel on widget dispose
)
```

---

## GET Request

```dart
final result = await netraClient.get(
  requestOptions: RequestOptions(
    url: "/users",
  ),
);

print(result?.statusCode);
print(result?.data);
```

---

## POST Request

```dart
final result = await netraClient.post(
  requestOptions: RequestOptions(
    url: "/users",
    body: RequestBody.createJson(
      jsonEncode({"name": "Sinem", "job": "developer"}),
    ),
  ),
);
```

---

## PUT Request

```dart
final result = await netraClient.put(
  requestOptions: RequestOptions(
    url: "/users/1",
    body: RequestBody.createJson(
      jsonEncode({"name": "Sinem", "job": "mobile developer"}),
    ),
  ),
);
```

---

## PATCH Request

```dart
final result = await netraClient.patch(
  requestOptions: RequestOptions(
    url: "/users/1",
    body: RequestBody.createJson(
      jsonEncode({"name": "Sinem"}),
    ),
  ),
);
```

---

## DELETE Request

```dart
final result = await netraClient.delete(
  requestOptions: RequestOptions(
    url: "/users/1",
  ),
);
```

---

## Example Response

```dart
result?.statusCode      // int
result?.statusMessage   // String?
result?.headers         // Map<String, String?>?
result?.data            // dynamic
result?.isCache         // bool — true if served from cache
```

---

## Request Body Types

### JSON

```dart
RequestBody.createJson(jsonEncode({"name": "Sinem"}))
```

### Bytes

```dart
RequestBody.createBytes(
  Uint8List.fromList(utf8.encode(jsonEncode({"name": "Sinem"}))),
)
```

### Multipart

```dart
final part = RequestBodyPart.file(
  name: "image",
  fileName: "photo.jpg",
  bytes: bytes,
  contentType: "image/jpeg",
);

RequestBody.multipart([part])
```

---

## Multipart Upload

```dart
final XFile? file = await picker.pickImage(source: ImageSource.gallery);
if (file != null) {
  final bytes = await file.readAsBytes();

  final result = await netraClient.post(
    requestOptions: RequestOptions(
      url: "/upload",
      body: RequestBody.multipart([
        RequestBodyPart.file(
          name: "image",
          fileName: file.name,
          bytes: bytes,
          contentType: "image/jpeg",
        ),
      ]),
    ),
  );

  print(result?.statusCode);
}
```

---

## Streaming

For large responses (images, files, audio), use `getStream` to consume data chunk by chunk.

```dart
final stream = await netraClient.getStream(
  requestOptions: RequestOptions(
    url: "/image",
    cancelOnDispose: true,
  ),
);

final List<int> imageBytes = [];

stream.listen(
  (data) {
    imageBytes.addAll(data);
  },
  onDone: () {
    final bytes = Uint8List.fromList(imageBytes);
    // use bytes
  },
  onError: (e) {
    print("stream error: $e");
  },
);
```

---

## Cache Support

```dart
final result = await netraClient.get(
  requestOptions: RequestOptions(
    url: "/users",
    cacheOptions: CacheOptions(),
  ),
);

print(result?.isCache);  // true if served from cache
```

Custom TTL:

```dart
cacheOptions: CacheOptions(ttl: 60000)  // 1 minute in ms
```

---

## Offline Support

```dart
final result = await netraClient.get(
  requestOptions: RequestOptions(
    url: "/users",
    offlinePolicyAction: OfflinePolicyAction.queue,
  ),
);
```

Available offline actions:

| Action | Description |
|---|---|
| `OfflinePolicyAction.queue` | Stores request, retries automatically when connection is restored |
| `OfflinePolicyAction.useCache` | Returns cached response if available |
| `OfflinePolicyAction.retry(retries, retryInterval)` | Retries N times with given interval |
| `OfflinePolicyAction.throwError` | Immediately throws a network error |

### RETRY example:

```dart
offlinePolicyAction: OfflinePolicyAction.retry(
  retries: 3,
  retryInterval: Duration(seconds: 2),
),
```

---

## Slow Network Strategies

```dart
final result = await netraClient.get(
  requestOptions: RequestOptions(
    url: "/users",
    slowNetworkPolicyAction: SlowNetworkPolicyAction.useCache,
  ),
);
```

Available actions:

| Action | Description |
|---|---|
| `SlowNetworkPolicyAction.useCache` | Returns cached response immediately |
| `SlowNetworkPolicyAction.wait(delay)` | Waits given duration before sending request |
| `SlowNetworkPolicyAction.timeout(timeout)` | Throws error if request exceeds duration |

### WAIT example:

```dart
slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(
  delay: Duration(seconds: 2),
),
```

### TIMEOUT example:

```dart
slowNetworkPolicyAction: SlowNetworkPolicyAction.timeout(
  timeout: Duration(milliseconds: 2000),
),
```

---

## Per-Request Headers

```dart
requestOptions: RequestOptions(
  url: "/users",
  headers: {
    "X-Custom-Header": "value",
  },
),
```

---

## Cancel on Dispose

Requests marked with `cancelOnDispose: true` are automatically cancelled when the widget is disposed.

```dart
requestOptions: RequestOptions(
  url: "/users",
  cancelOnDispose: true,
),
```

---

## Converter Support

| Converter | Enum |
|---|---|
| Gson | `ConverterType.gson` |
| Kotlinx Serialization | `ConverterType.kotlinX` |
| Moshi | `ConverterType.moshi` |

```dart
final netraClient = NetraClient(
  baseUrl: "https://api.example.com",
  converterType: ConverterType.kotlinX,
);
```

---

## Observers

Netra uses an event-driven system. Attach listeners with `on()` and detach with `off()`.

```dart
// attach — returns an eventId
final eventId = netraClient.on(
  CacheEvent.cacheStaleUsed((request, ageMs, ttlMs, expiredByMs) {
    print("stale cache used: ${request.url}");
  }),
);

// detach
netraClient.off(eventId);
```

### Request Events

```dart
netraClient.on(RequestEvent.requestExecuted((request) {
  print("executing: ${request.url}");
}));

netraClient.on(RequestEvent.requestSuccess((request, response) {
  print("success: ${response.statusCode} data: ${response.data}");
}));

netraClient.on(RequestEvent.requestFailed((request, response) {
  print("failed: ${response?.statusCode}");
}));
```

### Cache Events

```dart
netraClient.on(CacheEvent.cacheHit((request, ageMs, ttlMs) {
  print("cache hit: ${request.url}");
}));

netraClient.on(CacheEvent.cacheMiss((request) {
  print("cache miss: ${request.url}");
}));

netraClient.on(CacheEvent.cacheStored((request, ageMs, ttlMs) {
  print("cache stored: ${request.url}");
}));

netraClient.on(CacheEvent.cacheExpired((request, ageMs, ttlMs, expiredByMs) {
  print("cache expired: ${request.url}");
}));

netraClient.on(CacheEvent.cacheStaleUsed((request, ageMs, ttlMs, expiredByMs) {
  print("stale cache used: ${request.url}");
}));
```

| Event | Description |
|---|---|
| `cacheHit` | Valid cached data found and returned |
| `cacheMiss` | No cache entry exists |
| `cacheStored` | Response saved to cache |
| `cacheExpired` | Cache exists but TTL has passed |
| `cacheStaleUsed` | Expired cache returned as fallback |

### Queue Events

```dart
netraClient.on(QueueEvent.requestQueued((url, queueOrder, createdAt) {
  print("queued: $url order: $queueOrder");
}));

netraClient.on(QueueEvent.queuedRequestRestored((url) {
  print("restored: $url");
}));

netraClient.on(QueueEvent.queuedRequestExecuted((url, response) {
  print("executed: $url status: ${response.statusCode}");
}));

netraClient.on(QueueEvent.queuedRequestFailed((url) {
  print("queue failed: $url");
}));
```

| Event | Description |
|---|---|
| `requestQueued` | Request stored in offline queue |
| `queuedRequestRestored` | Connection restored, queue processing started |
| `queuedRequestExecuted` | Queued request succeeded |
| `queuedRequestFailed` | Queued request failed on retry |

### Network Events

```dart
netraClient.on(NetworkEvent.offline(() {
  print("offline");
}));

netraClient.on(NetworkEvent.slowNetwork(() {
  print("slow network");
}));

netraClient.on(NetworkEvent.connectionRestored(() {
  print("connection restored");
}));
```

| Event | Description |
|---|---|
| `offline` | Device lost internet connection |
| `slowNetwork` | Network is congested or degraded |
| `connectionRestored` | Internet connection is back |

---

## Circuit Breaker

Automatically stops sending requests after a threshold of consecutive failures.

```dart
final netraClient = NetraClient(
  baseUrl: "https://api.example.com",
  circuitBreakerOptions: CircuitBreakerOptions(
    failureThreshold: 5,
    retryDelayMs: 1000,
  ),
);
```

---

## Roadmap

- [ ] iOS support
- [ ] WebSocket support
- [ ] Request deduplication
- [ ] Logging interceptor

## License

```
MIT License
```