enum ExecutionMode {
  direct('DIRECT'),
  guaranteed('GUARANTEED');

  final String identifier;

  const ExecutionMode(this.identifier);

  factory ExecutionMode.fromIdentifier(String identifier) {
    return ExecutionMode.values.firstWhere(
      (element) => element.identifier == identifier,
      orElse: () => ExecutionMode.direct,
    );
  }
}
