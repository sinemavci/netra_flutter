import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:netra_flutter/common/dto/request_options_dto.dart';
import 'package:netra_flutter/common/dto/response_dto.dart';
import 'package:netra_flutter/common/observers/client_events.dart';
import 'package:netra_flutter/common/observers/client_event.dart';

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
    } else if (eventNameValue == ClientEvents.cacheMiss.value) {
      if (registeredEvent is CacheMiss) {
        final key = eventValue["key"] as String;
        registeredEvent.onCacheMiss?.call(key);
      }
    } else if (eventNameValue == ClientEvents.cacheHit.value) {
      if (registeredEvent is CacheHit) {
        final key = eventValue["key"] as String;
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        registeredEvent.onCacheHit?.call(key, ageMs, ttlMs);
      }
    } else if (eventNameValue == ClientEvents.cacheStored.value) {
      if (registeredEvent is CacheStored) {
        final key = eventValue["key"] as String;
        final ageMs = eventValue["ageMs"] as int;
        final sizeByte = eventValue["sizeByte"] as int;
        registeredEvent.onCacheStored?.call(key, ageMs, sizeByte);
      }
    } else if (eventNameValue == ClientEvents.cacheExpired.value) {
      if (registeredEvent is CacheExpired) {
        final key = eventValue["key"] as String;
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        final expiredByMs = eventValue["expiredByMs"] as int;
        registeredEvent.onCacheExpired?.call(key, ageMs, ttlMs, expiredByMs);
      }
    } else if (eventNameValue == ClientEvents.cacheStaleUsed.value) {
      if (registeredEvent is CacheStaleUsed) {
        final key = eventValue["key"] as String;
        final ageMs = eventValue["ageMs"] as int;
        final ttlMs = eventValue["ttlMs"] as int;
        final expiredByMs = eventValue["expiredByMs"] as int;
        registeredEvent.onCacheStaleUsed?.call(key, ageMs, ttlMs, expiredByMs);
      }
    } else if (eventNameValue == ClientEvents.requestQueued.value) {
      if (registeredEvent is RequestQueued) {
        final key = eventValue["key"] as String;
        final queueOrder = eventValue["queueOrder"] as int;
        final createdAt = eventValue["createdAt"] as int;
        registeredEvent.onRequestQueued?.call(key, queueOrder, createdAt);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestRestored.value) {
      if (registeredEvent is QueuedRequestRestored) {
        final key = eventValue["key"] as String;
        registeredEvent.onQueuedRequestRestored?.call(key);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestExecuted.value) {
      if (registeredEvent is QueuedRequestExecuted) {
        final key = eventValue["key"] as String;
        final responseJson = eventValue["response"] as Map<String, dynamic>;
        final response = ResponseDTO
            .fromJson(responseJson)
            .toDataModel();
        registeredEvent.onQueuedRequestExecuted?.call(key, response);
      }
    } else if (eventNameValue == ClientEvents.queuedRequestFailed.value) {
      if (registeredEvent is QueuedRequestFailed) {
        final key = eventValue["key"] as String;
        registeredEvent.onQueuedRequestFailed?.call(key);
      }
    } else if (eventNameValue == ClientEvents.responseReceived.value) {
      if (registeredEvent is ResponseReceived) {
        final responseJson = eventValue["response"] as Map<String, dynamic>;
        final response = ResponseDTO
            .fromJson(responseJson)
            .toDataModel();
        registeredEvent.onResponseReceived?.call(response);
      }
    } else if (eventNameValue == ClientEvents.requestExecuted.value) {
      if (registeredEvent is RequestExecuted) {
        final key = eventValue["key"] as String;
        final requestJson = eventValue["request"] as Map<String, dynamic>;
        final request = RequestOptionsDTO.fromJson(requestJson)
            .toDataModel();
        registeredEvent.onRequestExecuted?.call(key, request);
      }
    }
  }
}
