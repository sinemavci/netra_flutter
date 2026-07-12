sealed class SlowNetworkPolicyAction {
  final String identifier;

  const SlowNetworkPolicyAction(this.identifier);

  static const useCache = UseCachePolicyAction();

  static WaitPolicyAction wait({required Duration delay}) =>
      WaitPolicyAction(delay: delay);

  static TimeoutPolicyAction timeout({required Duration timeout}) =>
      TimeoutPolicyAction(timeout: timeout);

  static SlowNetworkPolicyAction fromIdentifier(String identifier,
      {Duration? delay, Duration? timeout}) {
    return switch (identifier) {
      "USE_CACHE" => const UseCachePolicyAction(),
      "WAIT" => WaitPolicyAction(delay: delay ?? Duration(milliseconds: 1000)),
      "TIMEOUT" => TimeoutPolicyAction(timeout: timeout ?? Duration(milliseconds: 1000)),
      _ => throw ArgumentError("Unknown offline policy: $identifier"),
    };
  }
}

class UseCachePolicyAction extends SlowNetworkPolicyAction {
  const UseCachePolicyAction() : super("USE_CACHE");
}

class WaitPolicyAction extends SlowNetworkPolicyAction {
  const WaitPolicyAction({required this.delay}) : super("WAIT");
  final Duration delay;
}

class TimeoutPolicyAction extends SlowNetworkPolicyAction {
  const TimeoutPolicyAction({required this.timeout}) : super("TIMEOUT");
  final Duration timeout;
}