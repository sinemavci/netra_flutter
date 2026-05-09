import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/response.dart';

part 'response_dto.freezed.dart';
part 'response_dto.g.dart';

@freezed
abstract class ResponseDTO with _$ResponseDTO {
  const ResponseDTO._();

  const factory ResponseDTO({
    required Map<String, Object?>? data,
    required int statusCode,
    required String? statusMessage,
  }) = _ResponseDTO;

  factory ResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseDTOFromJson(json);

  factory ResponseDTO.fromDataModel(Response model) {
    return ResponseDTO(
        data: model.data, statusCode: model.statusCode, statusMessage: model.statusMessage);
  }

  Response toDataModel() {
    return Response(data: data, statusCode: statusCode, statusMessage: statusMessage);
  }
}
