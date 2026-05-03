import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/netra_response.dart';

part 'netra_response_dto.freezed.dart';
part 'netra_response_dto.g.dart';

@freezed
abstract class NetraResponseDTO with _$NetraResponseDTO {
  const NetraResponseDTO._();

  const factory NetraResponseDTO({
    required Map<String, Object?>? data,
    required int statusCode,
    required String? error,
  }) = _NetraResponseDTO;

  factory NetraResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$NetraResponseDTOFromJson(json);

  factory NetraResponseDTO.fromDataModel(NetraResponse model) {
    return NetraResponseDTO(
        data: model.data, statusCode: model.statusCode, error: model.error);
  }

  NetraResponse toDataModel() {
    return NetraResponse(data: data, statusCode: statusCode, error: error);
  }
}
