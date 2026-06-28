enum ClientEvents {
  // network events
  offline("Offline"),
  slowNetwork("SlowNetwork"),
  connectionRestored("ConnectionRestored"),

  //cache events
  cacheHit("CacheHit"),
  cacheMiss("CacheMiss"),
  cacheStored("CacheStored"),
  cacheExpired("CacheExpired"),
  cacheStaleUsed("StaleCacheUsed"),

  // request events
  requestQueued("RequestQueued"),
  queuedRequestExecuted("QueuedRequestExecuted"),
  queuedRequestSuccess("QueuedRequestSuccess"),
  queuedRequestFailed("QueuedRequestFailed"),

  // request events
  requestExecuted("RequestExecuted"),
  requestSuccess("RequestSuccess"),
  requestFailed("RequestFailed");

  final String value;

  const ClientEvents(this.value);

  factory ClientEvents.fromValue(String value) {
    return ClientEvents.values.firstWhere(
          (element) => element.value == value,
    );
  }
}