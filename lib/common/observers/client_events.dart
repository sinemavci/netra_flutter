enum ClientEvents {
  offline("Offline"),
  slowNetwork("SlowNetwork"),
  connectionRestored("ConnectionRestored");

  final String value;

  const ClientEvents(this.value);

  factory ClientEvents.fromValue(String value) {
    return ClientEvents.values.firstWhere(
          (element) => element.value == value,
    );
  }
}