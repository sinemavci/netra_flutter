typedef OnNetworkChanged = void Function();

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