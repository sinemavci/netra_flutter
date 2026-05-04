sealed class OfflinePolicyAction {
  final String identifier;

  const OfflinePolicyAction(this.identifier);

  static const queue      = QueuePolicyAction();
  static const useCache   = UseCachePolicyAction();
  static const throwError = ThrowErrorPolicyAction();
  static RetryPolicyAction retry({required int retries}) =>
      RetryPolicyAction(retries: retries);

  static OfflinePolicyAction fromIdentifier(String identifier, {int? retries}) {
    return switch (identifier) {
      "QUEUE"       => const QueuePolicyAction(),
      "USE_CACHE"   => const UseCachePolicyAction(),
      "RETRY"       => RetryPolicyAction(retries: retries ?? 1),
      "THROW_ERROR" => const ThrowErrorPolicyAction(),
      _             => throw ArgumentError("Unknown offline policy: $identifier"),
    };
  }
}

class QueuePolicyAction extends OfflinePolicyAction {
  const QueuePolicyAction() : super("QUEUE");
}

class UseCachePolicyAction extends OfflinePolicyAction {
  const UseCachePolicyAction() : super("USE_CACHE");
}

class RetryPolicyAction extends OfflinePolicyAction {
  const RetryPolicyAction({required this.retries}) : super("RETRY");
  final int retries;
}

class ThrowErrorPolicyAction extends OfflinePolicyAction {
  const ThrowErrorPolicyAction() : super("THROW_ERROR");
}