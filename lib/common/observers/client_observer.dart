import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:netra_flutter/common/dto/request_options_dto.dart';
import 'package:netra_flutter/common/dto/response_dto.dart';
import 'package:netra_flutter/common/observers/cache_event.dart';
import 'package:netra_flutter/common/observers/client_events.dart';
import 'package:netra_flutter/common/observers/client_event.dart';
import 'package:netra_flutter/common/observers/network_event.dart';
import 'package:netra_flutter/common/observers/queue_event.dart';
import 'package:netra_flutter/common/observers/request_event.dart';

class ClientObserver {
  final String clientId;

  ClientObserver({ required this.clientId }) {
    _startListening();
  }

  final StreamController<
      Map<String, dynamic>> _eventController = StreamController.broadcast();
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};
  StreamSubscription<dynamic>? _masterSubscription;

  late final EventChannel _clientEventChannel = EventChannel(
      "ClientListener$clientId");

  void _startListening() {
    if (_masterSubscription != null) return;

    _masterSubscription =
        _clientEventChannel.receiveBroadcastStream().listen((data) {
          try {
            final Map<String, dynamic> event = jsonDecode(data);
            _eventController.add(event);
          } catch (e) {
            print('Error decoding map event from platform: $e');
          }
        }, onError: (error) => print('MapListener Stream Error: $error'));
  }

  void on(ClientEvent clientEvent, String eventId) {
    if (_masterSubscription == null || _eventController.isClosed);

    final subscription =
    _eventController.stream.where((event) =>
    event["EventName"] == clientEvent.eventName).listen((event) {
      _dispatchEvent(event, clientEvent);
    });

    _subscriptions[eventId] = subscription;
  }

  void off(String eventId) {
    final subscription = _subscriptions.remove(eventId);
    subscription?.cancel();
  }

  void dispose() {
    for (var sub in _subscriptions.entries) {
      sub.value.cancel();
    }
    _subscriptions.clear();

    _masterSubscription?.cancel();
    _masterSubscription = null;

    _eventController.close();
  }

  void _dispatchEvent(Map<String, dynamic> event, ClientEvent registeredEvent) {
    final eventNameValue = event["EventName"];
    final eventValue = event["Value"];

    /// network events
    if (eventNameValue == ClientEvents.offline.value) {
      if (registeredEvent is Offline) {
        registeredEvent.onChanged?.call();
      }
    } else if (eventNameValue == ClientEvents.slowNetwork.value) {
      if (registeredEvent is SlowNetwork) {
        registeredEvent.onChanged?.call();
      }
    } else if (eventNameValue == ClientEvents.connectionRestored.value) {
      if (registeredEvent is ConnectionRestored) {
        registeredEvent.onChanged?.call();
      }
    }

    /// cache events
    else if (eventNameValue == ClientEvents.cacheMiss.value) {
      if (registeredEvent is CacheMiss) {
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onCacheMiss?.call(request);
      }
    } else if (eventNameValue == ClientEvents.cacheHit.value) {
      if (registeredEvent is CacheHit) {
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onCacheHit?.call(request, ageMs, ttlMs);
      }
    } else if (eventNameValue == ClientEvents.cacheStored.value) {
      if (registeredEvent is CacheStored) {
        final ageMs = eventValue["ageMs"] as int;
        final sizeByte = eventValue["sizeByte"] as int;
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onCacheStored?.call(request, ageMs, sizeByte);
      }
    } else if (eventNameValue == ClientEvents.cacheExpired.value) {
      if (registeredEvent is CacheExpired) {
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        final expiredByMs = eventValue["expiredByMs"] as int;
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onCacheExpired?.call(
            request, ageMs, ttlMs, expiredByMs);
      }
    } else if (eventNameValue == ClientEvents.cacheStaleUsed.value) {
      if (registeredEvent is CacheStaleUsed) {
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        final expiredByMs = eventValue["expiredByMs"] as int;
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onCacheStaleUsed?.call(
            request, ageMs, ttlMs, expiredByMs);
      }
    }

    /// queue events
    else if (eventNameValue == ClientEvents.requestQueued.value) {
      if (registeredEvent is RequestQueued) {
        final url = eventValue["url"] as String;
        final queueOrder = eventValue["queueOrder"] as int;
        final createdAt = eventValue["createdAt"] as int;
        registeredEvent.onRequestQueued?.call(url, queueOrder, createdAt);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestExecuted.value) {
      if (registeredEvent is QueuedRequestExecuted) {
        final url = eventValue["url"] as String;
        registeredEvent.onQueuedRequestExecuted?.call(url);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestSuccess.value) {
      if (registeredEvent is QueuedRequestSuccess) {
        final url = eventValue["url"] as String;
        final responseJson = eventValue["response"] as Map<String, dynamic>;
        final response = ResponseDTO
            .fromJson(responseJson)
            .toDataModel();
        registeredEvent.onQueuedRequestSuccess?.call(url, response);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestFailed.value) {
      if (registeredEvent is QueuedRequestFailed) {
        final url = eventValue["url"] as String;
        final responseJson = eventValue["response"] as Map<String, dynamic>?;
        final response = responseJson != null ? ResponseDTO
            .fromJson(responseJson)
            .toDataModel() : null;
        registeredEvent.onQueuedRequestFailed?.call(url, response);
      }
    }
    // request events
    else if (eventNameValue == ClientEvents.requestExecuted.value) {
      if (registeredEvent is RequestExecuted) {
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onRequestExecuted?.call(request);
      }
    }
    else if (eventNameValue == ClientEvents.requestSuccess.value) {
      if (registeredEvent is RequestSuccess) {
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        final responseJson = eventValue["response"] as Map<String, dynamic>;
        final response = ResponseDTO.fromJson(responseJson)
            .toDataModel();
        registeredEvent.onRequestSuccess?.call(request, response);
      }
    }
    else if (eventNameValue == ClientEvents.requestFailed.value) {
      if (registeredEvent is RequestFailed) {
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        final responseJson = eventValue["response"] as Map<String, dynamic>?;
        final response = responseJson != null ? ResponseDTO.fromJson(
            responseJson)
            .toDataModel() : null;
        registeredEvent.onRequestFailed?.call(request, response);
      }
    }
  }
}
