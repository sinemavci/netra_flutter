typedef OnClientChanged = void Function();

sealed class ClientObserverEvent {
  final String eventName;

  const ClientObserverEvent(this.eventName);

  factory ClientObserverEvent.offline(OnClientChanged? onClientChanged) => Offline(onClientChanged);

  factory ClientObserverEvent.slowNetwork(OnClientChanged? onClientChanged) => SlowNetwork(onClientChanged);

  factory ClientObserverEvent.connectionRestored(OnClientChanged? onClientChanged) => ConnectionRestored(onClientChanged);
}

class Offline extends ClientObserverEvent {
  OnClientChanged? onClientChanged;

  Offline(this.onClientChanged) : super('Offline');
}

class SlowNetwork extends ClientObserverEvent {
  OnClientChanged? onClientChanged;

  SlowNetwork(this.onClientChanged) : super('SlowNetwork');
}

class ConnectionRestored extends ClientObserverEvent {
  OnClientChanged? onClientChanged;

  ConnectionRestored(this.onClientChanged) : super('ConnectionRestored');
}
