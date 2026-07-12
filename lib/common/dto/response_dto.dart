import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/response.dart';

part 'response_dto.freezed.dart';
part 'response_dto.g.dart';

@freezed
abstract class ResponseDTO with _$ResponseDTO {
  const ResponseDTO._();

  const factory ResponseDTO({
    required Object? data,
    required int statusCode,
    required String? statusMessage,
    required Map<String, String?>? headers,
  }) = _ResponseDTO;

  factory ResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseDTOFromJson(json);

  factory ResponseDTO.fromDataModel(Response model) {
    return ResponseDTO(
      data: model.data,
      statusCode: model.statusCode,
      statusMessage: model.statusMessage,
      headers: model.headers,
    );
  }

  Response toDataModel() {
    return Response(
      data: data,
      statusCode: statusCode,
      statusMessage: statusMessage,
      headers: headers,
    );
  }
}
