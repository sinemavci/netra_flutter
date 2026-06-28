import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';

part 'offline_policy_action_dto.freezed.dart';
part 'offline_policy_action_dto.g.dart';

@freezed
abstract class OfflinePolicyActionDTO with _$OfflinePolicyActionDTO {
  const OfflinePolicyActionDTO._();

  const factory OfflinePolicyActionDTO({
    required String? identifier,
    int? retries,
    int? retryDuration,
    String? retryUnit,
  }) = _OfflinePolicyActionDTO;

  factory OfflinePolicyActionDTO.fromJson(Map<String, dynamic> json) =>
      _$OfflinePolicyActionDTOFromJson(json);

  factory OfflinePolicyActionDTO.fromDataModel(OfflinePolicyAction model) {
    return OfflinePolicyActionDTO(
      identifier: model.identifier,
      retries: model is RetryPolicyAction ? model.retries : null,
      retryDuration: model is RetryPolicyAction ? model.retryInterval
          .inMilliseconds : null,
      retryUnit: model is RetryPolicyAction ? "MILLISECONDS" : null,
    );
  }

  OfflinePolicyAction toDataModel() {
    return OfflinePolicyAction.fromIdentifier(
      identifier!,
      retries: retries,
      retryInterval: retryDuration != null ? Duration(
          milliseconds: retryDuration!) : null,
    );
  }
}
