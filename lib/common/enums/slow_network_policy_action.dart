sealed class SlowNetworkPolicyAction {
  final String identifier;

  const SlowNetworkPolicyAction(this.identifier);

  static const useCache = UseCachePolicyAction();

  static WaitPolicyAction wait({required int delay}) =>
      WaitPolicyAction(delay: delay);

  static TimeoutPolicyAction timeout({required int timeout}) =>
      TimeoutPolicyAction(timeout: timeout);

  static SlowNetworkPolicyAction fromIdentifier(String identifier,
      {int? delay, int? timeout}) {
    return switch (identifier) {
      "USE_CACHE" => const UseCachePolicyAction(),
      "WAIT" => WaitPolicyAction(delay: delay ?? 1),
      "TIMEOUT" => TimeoutPolicyAction(timeout: timeout ?? 1),
      _ => throw ArgumentError("Unknown offline policy: $identifier"),
    };
  }
}

class UseCachePolicyAction extends SlowNetworkPolicyAction {
  const UseCachePolicyAction() : super("USE_CACHE");
}

class WaitPolicyAction extends SlowNetworkPolicyAction {
  const WaitPolicyAction({required this.delay}) : super("WAIT");
  final int delay;
}

class TimeoutPolicyAction extends SlowNetworkPolicyAction {
  const TimeoutPolicyAction({required this.timeout}) : super("TIMEOUT");
  final int timeout;
}