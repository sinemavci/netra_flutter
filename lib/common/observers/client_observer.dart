import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:netra_flutter/common/observers/client_events.dart';
import 'package:netra_flutter/common/observers/network_event.dart';

class ClientObserver {
  final String clientId;

  ClientObserver({ required this.clientId }) {
    _startListening();
  }

  final StreamController<
      Map<String, dynamic>> _eventController = StreamController.broadcast();
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};
  StreamSubscription<dynamic>? _masterSubscription;

  late final EventChannel _shapeChangedEventChannel = EventChannel(
      "ClientListener$clientId");

  void _startListening() {
    if (_masterSubscription != null) return;

    _masterSubscription =
        _shapeChangedEventChannel.receiveBroadcastStream().listen((data) {
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
        // final parsed = eventValue as String;
        registeredEvent.onChanged?.call();
      }

      // CenterChanged
    } else if (eventNameValue == ClientEvents.slowNetwork.value) {
      if (registeredEvent is SlowNetwork) {
        // final coordinateDTO = CoordinateDTO.fromJson(
        //     eventValue as Map<String, dynamic>);
        // registeredEvent.s!();
        registeredEvent.onChanged?.call();
      }
    } else if (eventNameValue == ClientEvents.connectionRestored.value) {
      if (registeredEvent is ConnectionRestored) {
        // final coordinateDTO = CoordinateDTO.fromJson(
        //     eventValue as Map<String, dynamic>);
        registeredEvent.onChanged?.call();
      }
    }
  }
}
