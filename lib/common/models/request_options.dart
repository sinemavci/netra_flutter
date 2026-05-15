import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';
import 'package:netra_flutter/common/models/cache_options.dart';

class RequestOptions {
  OfflinePolicyAction? offlinePolicyAction;

  SlowNetworkPolicyAction? slowNetworkPolicyAction;

  CacheOptions? cacheOptions = CacheOptions();

  Map<String, String?>? headers;

  RequestOptions({
    this.offlinePolicyAction,
    this.slowNetworkPolicyAction,
    this.headers,
    CacheOptions? cacheOptions,
  }) : cacheOptions = cacheOptions ?? CacheOptions();
}
