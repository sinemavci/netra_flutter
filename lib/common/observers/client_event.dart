import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/models/response.dart';

typedef OnCacheMiss = void Function(String key);
typedef OnCacheHit = void Function(String key, int ageMs, int ttlMs);
typedef OnCacheStored = void Function(String key, int ageMs, int sizeByte);
typedef OnCacheExpired = void Function(String key, int ageMs, int ttlMs, int expiredByMs);
typedef OnStaleCacheUsed = void Function(String key, int ageMs, int ttlMs, int expiredByMs);

typedef OnNetworkChanged = void Function();

typedef OnQueuedRequestFailed = void Function(String key);
typedef OnQueuedRequestRestored = void Function(String key);
typedef OnRequestQueued = void Function(String key, int queueOrder, int createdAt);
typedef OnQueuedRequestExecuted = void Function(String key, Response response);

typedef OnResponseReceived = void Function(Response response);
typedef OnRequestExecuted = void Function(RequestOptions request);

interface class ClientEvent {
  final String eventName;

  const ClientEvent(this.eventName);
}

sealed class NetworkEvent extends ClientEvent {
  final OnNetworkChanged? onChanged;

  const NetworkEvent(super.eventName, this.onChanged);

  factory NetworkEvent.offline(OnNetworkChanged? onChanged) = Offline;

  factory NetworkEvent.slowNetwork(OnNetworkChanged? onChanged) = SlowNetwork;

  factory NetworkEvent.connectionRestored(
      OnNetworkChanged? onChanged) = ConnectionRestored;
}

final class Offline extends NetworkEvent {
  const Offline(OnNetworkChanged? onChanged)
      : super('Offline', onChanged);
}

final class SlowNetwork extends NetworkEvent {
  const SlowNetwork(OnNetworkChanged? onChanged)
      : super('SlowNetwork', onChanged);
}

final class ConnectionRestored extends NetworkEvent {
  const ConnectionRestored(OnNetworkChanged? onChanged)
      : super('ConnectionRestored', onChanged);
}

sealed class CacheEvent extends ClientEvent {
  final OnCacheHit? onCacheHit;
  final OnCacheMiss? onCacheMiss;
  final OnCacheStored? onCacheStored;
  final OnCacheExpired? onCacheExpired;
  final OnStaleCacheUsed? onCacheStaleUsed;

  const CacheEvent(super.eventName, {
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
  const CacheHit(OnCacheHit? onCacheHit)
      : super('CacheHit', onCacheHit: onCacheHit);
}

final class CacheMiss extends CacheEvent {
  const CacheMiss(OnCacheMiss? onCacheMiss)
      : super('CacheMiss', onCacheMiss: onCacheMiss);
}

final class CacheStored extends CacheEvent {
  const CacheStored(OnCacheStored? onCacheStored)
      : super('CacheStored', onCacheStored: onCacheStored);
}

final class CacheExpired extends CacheEvent {
  const CacheExpired(OnCacheExpired? onCacheExpired)
      : super('CacheExpired', onCacheExpired: onCacheExpired);
}

final class CacheStaleUsed extends CacheEvent {
  const CacheStaleUsed(OnStaleCacheUsed? onStaleCacheUsed)
      : super('StaleCacheUsed', onCacheStaleUsed: onStaleCacheUsed);
}

sealed class RequestEvent extends ClientEvent {
  final OnRequestQueued? onRequestQueued;
  final OnQueuedRequestFailed? onQueuedRequestFailed;
  final OnQueuedRequestExecuted? onQueuedRequestExecuted;
  final OnQueuedRequestRestored? onQueuedRequestRestored;
  final OnRequestExecuted? onRequestExecuted;

  const RequestEvent(super.eventName, {
    this.onRequestQueued,
    this.onQueuedRequestFailed,
    this.onQueuedRequestExecuted,
    this.onQueuedRequestRestored,
    this.onRequestExecuted,
  });

  factory RequestEvent.requestQueued(
      OnRequestQueued? onRequestQueued) = RequestQueued;

  factory RequestEvent.queuedRequestFailed(
      OnQueuedRequestFailed? onQueuedRequestFailed) = QueuedRequestFailed;

  factory RequestEvent.queuedRequestExecuted(
      OnQueuedRequestExecuted? onQueuedRequestExecuted) = QueuedRequestExecuted;

  factory RequestEvent.queuedRequestRestored(
      OnQueuedRequestRestored? onQueuedRequestRestored) = QueuedRequestRestored;

  factory RequestEvent.onRequestExecuted(
      OnRequestExecuted? onRequestExecuted) = RequestExecuted;
}

final class RequestQueued extends RequestEvent {
  const RequestQueued(OnRequestQueued? onRequestQueued)
      : super('RequestQueued', onRequestQueued: onRequestQueued);
}

final class QueuedRequestFailed extends RequestEvent {
  const QueuedRequestFailed(OnQueuedRequestFailed? onQueuedRequestFailed)
      : super(
      'QueuedRequestFailed', onQueuedRequestFailed: onQueuedRequestFailed);
}

final class QueuedRequestExecuted extends RequestEvent {
  const QueuedRequestExecuted(OnQueuedRequestExecuted? onQueuedRequestExecuted)
      : super('QueuedRequestExecuted',
      onQueuedRequestExecuted: onQueuedRequestExecuted);
}

final class QueuedRequestRestored extends RequestEvent {
  const QueuedRequestRestored(OnQueuedRequestRestored? onQueuedRequestRestored)
      : super('QueuedRequestRestored',
      onQueuedRequestRestored: onQueuedRequestRestored);
}

final class RequestExecuted extends RequestEvent {
  const RequestExecuted(OnRequestExecuted? onRequestExecuted)
      : super('RequestExecuted',
      onRequestExecuted: onRequestExecuted);
}

sealed class ResponseEvent extends ClientEvent {
  final OnResponseReceived? onResponseReceived;

  const ResponseEvent(super.eventName, {
    this.onResponseReceived,
  });

  factory ResponseEvent.responseReceived(
      OnResponseReceived? onQueuedRequestFailed) = ResponseReceived;
}

final class ResponseReceived extends ResponseEvent {
  const ResponseReceived(OnResponseReceived? onResponseReceived)
      : super('ResponseReceived',
      onResponseReceived: onResponseReceived);
}


