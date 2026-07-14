import 'package:netra_flutter/common/observers/client_event.dart';

sealed class NetworkEvent implements ClientEvent {
  final OnNetworkChanged? onChanged;

  const NetworkEvent(this.onChanged);

  factory NetworkEvent.offline(OnNetworkChanged? onChanged) = Offline;

  factory NetworkEvent.slowNetwork(OnNetworkChanged? onChanged) = SlowNetwork;

  factory NetworkEvent.connectionRestored(OnNetworkChanged? onChanged) =
      ConnectionRestored;
}

final class Offline extends NetworkEvent {
  const Offline(super.onChanged);

  @override
  String get eventName => 'Offline';
}

final class SlowNetwork extends NetworkEvent {
  const SlowNetwork(super.onChanged);

  @override
  String get eventName => 'SlowNetwork';
}

final class ConnectionRestored extends NetworkEvent {
  const ConnectionRestored(super.onChanged);

  @override
  String get eventName => 'ConnectionRestored';
}
