import 'package:netra_flutter/common/models/cache_options.dart';
import 'package:netra_flutter/netra_flutter_plugin.dart';
import 'package:uuid/uuid.dart';

class RequestOptions {
  String? id;

  String url;

  OfflinePolicyAction? offlinePolicyAction;

  SlowNetworkPolicyAction? slowNetworkPolicyAction;

  CacheOptions? cacheOptions = CacheOptions();

  Map<String, String?>? headers;

  bool? cancelOnDispose;

  RequestBody? body;

  RequestOptions({
    required this.url,
    this.offlinePolicyAction,
    this.slowNetworkPolicyAction,
    this.headers,
    this.cancelOnDispose,
    this.body,
    CacheOptions? cacheOptions,
  })
      : cacheOptions = cacheOptions ?? CacheOptions(),
        id = Uuid().v4();
}
