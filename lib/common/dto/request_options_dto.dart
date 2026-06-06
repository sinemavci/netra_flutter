import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/dto/cache_options_dto.dart';
import 'package:netra_flutter/common/dto/offline_policy_action_dto.dart';
import 'package:netra_flutter/common/dto/slow_network_policy_action_dto.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';
import 'package:netra_flutter/common/models/request_options.dart';

part 'request_options_dto.freezed.dart';
part 'request_options_dto.g.dart';

@freezed
abstract class RequestOptionsDTO with _$RequestOptionsDTO {
  const RequestOptionsDTO._();

  const factory RequestOptionsDTO({
    required String id,
    required String url,
    required OfflinePolicyActionDTO? offlinePolicyAction,
    required SlowNetworkPolicyActionDTO? slowNetworkPolicyAction,
    required CacheOptionsDTO? cacheOptions,
    required Map<String, String?>? headers,
    required bool? cancelOnDispose,
  }) = _RequestOptionsDTO;

  factory RequestOptionsDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestOptionsDTOFromJson(json);

  factory RequestOptionsDTO.fromDataModel(RequestOptions model) {
    return RequestOptionsDTO(
      id: model.id!,
      url: model.url,
      offlinePolicyAction: model.offlinePolicyAction != null
          ? OfflinePolicyActionDTO.fromDataModel(model.offlinePolicyAction!)
          : null,
      slowNetworkPolicyAction: model.slowNetworkPolicyAction != null
          ? SlowNetworkPolicyActionDTO.fromDataModel(
          model.slowNetworkPolicyAction!)
          : null,
      headers: model.headers,
      cancelOnDispose: model.cancelOnDispose,
      cacheOptions: model.cacheOptions != null
          ? CacheOptionsDTO.fromDataModel(model.cacheOptions!)
          : null,
    );
  }

  RequestOptions toDataModel() {
    return RequestOptions(
      url: url,
      offlinePolicyAction: offlinePolicyAction == null
          ? null
          : OfflinePolicyAction.fromIdentifier(offlinePolicyAction!.identifier!,
          retries: offlinePolicyAction!.retries),
      slowNetworkPolicyAction: slowNetworkPolicyAction == null
          ? null
          : SlowNetworkPolicyAction.fromIdentifier(
        slowNetworkPolicyAction!.identifier!,
        delay: slowNetworkPolicyAction!.delay,
        timeout: slowNetworkPolicyAction!.timeout,
      ),
      cacheOptions: cacheOptions?.toDataModel(),
      cancelOnDispose: cancelOnDispose,
      headers: headers,
    );
  }
}
