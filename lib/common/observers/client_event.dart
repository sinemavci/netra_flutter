import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/models/response.dart';

typedef OnCacheMiss = void Function(RequestOptions request);
typedef OnCacheHit = void Function(RequestOptions request, int ageMs, int ttlMs);
typedef OnCacheStored = void Function(RequestOptions request, int ageMs, int sizeByte);
typedef OnCacheExpired = void Function(RequestOptions request, int ageMs, int ttlMs, int expiredByMs);
typedef OnStaleCacheUsed = void Function(RequestOptions request, int ageMs, int ttlMs, int expiredByMs);

typedef OnNetworkChanged = void Function();

typedef OnQueuedRequestFailed = void Function(String url);
typedef OnQueuedRequestRestored = void Function(String url);
typedef OnRequestQueued = void Function(String url, int queueOrder, int createdAt);
typedef OnQueuedRequestExecuted = void Function(String url, Response response);

typedef OnRequestExecuted = void Function(RequestOptions request);
typedef OnRequestSuccess = void Function(RequestOptions request, Response response);
typedef OnRequestFailed = void Function(RequestOptions request, Response response);

interface class ClientEvent {
  final String eventName;

  const ClientEvent(this.eventName);
}


