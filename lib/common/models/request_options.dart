import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';
import 'package:netra_flutter/common/models/cache_options.dart';
import 'package:uuid/uuid.dart';

class RequestOptions {
  String? id;

  String url;

  OfflinePolicyAction? offlinePolicyAction;

  SlowNetworkPolicyAction? slowNetworkPolicyAction;

  CacheOptions? cacheOptions = CacheOptions();

  Map<String, String?>? headers;

  bool? cancelOnDispose;

  RequestOptions({
    required this.url,
    this.offlinePolicyAction,
    this.slowNetworkPolicyAction,
    this.headers,
    this.cancelOnDispose,
    CacheOptions? cacheOptions,
  })
      : cacheOptions = cacheOptions ?? CacheOptions(),
        id = Uuid().v4();
}
