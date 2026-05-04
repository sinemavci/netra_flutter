import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/dto/offline_policy_action_dto.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/models/request_options.dart';

part 'request_options_dto.freezed.dart';
part 'request_options_dto.g.dart';

@freezed
abstract class RequestOptionsDTO with _$RequestOptionsDTO {
  const RequestOptionsDTO._();

  const factory RequestOptionsDTO({
    required OfflinePolicyActionDTO? offlinePolicyAction,
  }) = _RequestOptionsDTO;

  factory RequestOptionsDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestOptionsDTOFromJson(json);

  factory RequestOptionsDTO.fromDataModel(RequestOptions model) {
    return RequestOptionsDTO(
      offlinePolicyAction: model.offlinePolicyAction != null
          ? OfflinePolicyActionDTO.fromDataModel(model.offlinePolicyAction!)
          : null,
    );
  }

  RequestOptions toDataModel() {
    return RequestOptions(
      offlinePolicyAction: offlinePolicyAction == null
          ? null
          : OfflinePolicyAction.fromIdentifier(offlinePolicyAction!.identifier!,
          retries: offlinePolicyAction!.retries),
    );
  }
}
