import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/response.dart';

part 'response_received_dto.freezed.dart';
part 'response_received_dto.g.dart';

@freezed
abstract class ResponseReceivedDTO with _$ResponseReceivedDTO {
  const ResponseReceivedDTO._();

  const factory ResponseReceivedDTO({
    required Object? data,
    required int statusCode,
    required String? statusMessage,
    required Map<String, String?>? headers,
  }) = _ResponseReceivedDTO;

  factory ResponseReceivedDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseReceivedDTOFromJson(json);

  factory ResponseReceivedDTO.fromDataModel(ResponseReceived model) {
    return ResponseReceivedDTO(
      data: model.data,
      statusCode: model.statusCode,
      statusMessage: model.statusMessage,
      headers: model.headers,
    );
  }

  ResponseReceived toDataModel() {
    return ResponseReceived(
      data: data,
      statusCode: statusCode,
      statusMessage: statusMessage,
      headers: headers,
    );
  }
}
