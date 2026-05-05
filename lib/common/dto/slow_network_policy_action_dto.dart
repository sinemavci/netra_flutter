import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';

part 'slow_network_policy_action_dto.freezed.dart';
part 'slow_network_policy_action_dto.g.dart';

@freezed
abstract class SlowNetworkPolicyActionDTO with _$SlowNetworkPolicyActionDTO {
  const SlowNetworkPolicyActionDTO._();

  const factory SlowNetworkPolicyActionDTO({
    required String? identifier,
    int? delay,
    int? timeout,
  }) = _SlowNetworkPolicyActionDTO;

  factory SlowNetworkPolicyActionDTO.fromJson(Map<String, dynamic> json) =>
      _$SlowNetworkPolicyActionDTOFromJson(json);

  factory SlowNetworkPolicyActionDTO.fromDataModel(
      SlowNetworkPolicyAction model) {
    return SlowNetworkPolicyActionDTO(
      identifier: model.identifier,
      delay: model is WaitPolicyAction ? model.delay : null,
      timeout: model is TimeoutPolicyAction ? model.timeout : null,
    );
  }

  SlowNetworkPolicyAction toDataModel() {
    return SlowNetworkPolicyAction.fromIdentifier(
      identifier!, delay: delay, timeout: timeout,);
  }
}
