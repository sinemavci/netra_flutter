enum ConverterType {
  gson('GSON'),
  moshi('MOSHI'),
  kotlinX('KOTLINX');

  final String identifier;

  const ConverterType(this.identifier);

  factory ConverterType.fromIdentifier(String identifier) {
    return ConverterType.values.firstWhere(
          (element) => element.identifier == identifier,
      orElse: () => ConverterType.kotlinX,
    );
  }
}