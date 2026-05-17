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
  cacheStaleUsed("StaleCacheUsed");


  final String value;

  const ClientEvents(this.value);

  factory ClientEvents.fromValue(String value) {
    return ClientEvents.values.firstWhere(
          (element) => element.value == value,
    );
  }
}