sealed class OfflinePolicyAction {
  final String identifier;

  const OfflinePolicyAction(this.identifier);

  static const queue = QueuePolicyAction();
  static const useCache = UseCacheOfflinePolicyAction();
  static const throwError = ThrowErrorPolicyAction();

  static RetryPolicyAction retry(
      {required int retries, required Duration retryInterval}) =>
      RetryPolicyAction(retries: retries, retryInterval: retryInterval);

  static OfflinePolicyAction fromIdentifier(String identifier,
      {int? retries, Duration? retryInterval}) {
    return switch (identifier) {
      "QUEUE" => const QueuePolicyAction(),
      "USE_CACHE" => const UseCacheOfflinePolicyAction(),
      "RETRY" =>
          RetryPolicyAction(retries: retries ?? 1,
              retryInterval: retryInterval ?? Duration(milliseconds: 2000)),
      "THROW_ERROR" => const ThrowErrorPolicyAction(),
      _ => throw ArgumentError("Unknown offline policy: $identifier"),
    };
  }
}

class QueuePolicyAction extends OfflinePolicyAction {
  const QueuePolicyAction() : super("QUEUE");
}

class UseCacheOfflinePolicyAction extends OfflinePolicyAction {
  const UseCacheOfflinePolicyAction() : super("USE_CACHE");
}

class RetryPolicyAction extends OfflinePolicyAction {
  const RetryPolicyAction({required this.retries, required this.retryInterval})
      : super("RETRY");
  final int retries;
  final Duration retryInterval;
}

class ThrowErrorPolicyAction extends OfflinePolicyAction {
  const ThrowErrorPolicyAction() : super("THROW_ERROR");
}