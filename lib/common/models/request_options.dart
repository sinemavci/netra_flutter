import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';

class RequestOptions {
  final OfflinePolicyAction? offlinePolicyAction;

  final SlowNetworkPolicyAction? slowNetworkPolicyAction;

  final Map<String, String?>? headers;

  RequestOptions({
    this.offlinePolicyAction,
    this.slowNetworkPolicyAction,
    this.headers,});
}
