import 'package:netra_flutter/common/observers/client_event.dart';

sealed class CacheEvent implements ClientEvent {
  final OnCacheHit? onCacheHit;
  final OnCacheMiss? onCacheMiss;
  final OnCacheStored? onCacheStored;
  final OnCacheExpired? onCacheExpired;
  final OnStaleCacheUsed? onCacheStaleUsed;

  const CacheEvent({
    this.onCacheHit,
    this.onCacheMiss,
    this.onCacheStored,
    this.onCacheExpired,
    this.onCacheStaleUsed,
  });

  factory CacheEvent.cacheHit(OnCacheHit? onCacheHit) = CacheHit;

  factory CacheEvent.cacheMiss(OnCacheMiss? onCacheMiss) = CacheMiss;

  factory CacheEvent.cacheStored(OnCacheStored? onCacheStored) = CacheStored;

  factory CacheEvent.cacheExpired(
      OnCacheExpired? onCacheExpired) = CacheExpired;

  factory CacheEvent.cacheStaleUsed(
      OnStaleCacheUsed? onStaleCacheUsed) = CacheStaleUsed;
}

final class CacheHit extends CacheEvent {
  const CacheHit(OnCacheHit? onCacheHit) : super(onCacheHit: onCacheHit);

  @override
  String get eventName => 'CacheHit';
}

final class CacheMiss extends CacheEvent {
  const CacheMiss(OnCacheMiss? onCacheMiss): super(onCacheMiss: onCacheMiss);

  @override
  String get eventName => 'CacheMiss';
}

final class CacheStored extends CacheEvent {
  const CacheStored(OnCacheStored? onCacheStored)
      : super(onCacheStored: onCacheStored);

  @override
  String get eventName => 'CacheStored';
}

final class CacheExpired extends CacheEvent {
  const CacheExpired(OnCacheExpired? onCacheExpired)
      : super(onCacheExpired: onCacheExpired);

  @override
  String get eventName => 'CacheExpired';
}

final class CacheStaleUsed extends CacheEvent {
  const CacheStaleUsed(OnStaleCacheUsed? onStaleCacheUsed)
      : super(onCacheStaleUsed: onStaleCacheUsed);

  @override
  String get eventName => 'StaleCacheUsed';
}