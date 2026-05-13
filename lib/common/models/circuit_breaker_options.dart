class CircuitBreakerOptions {
  final int? failureThreshold;

  final double? retryDelayMs;

  CircuitBreakerOptions({
    this.failureThreshold = 5,
    this.retryDelayMs = 1000,
  });
}
