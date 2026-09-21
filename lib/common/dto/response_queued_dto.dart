import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/response.dart';

part 'response_queued_dto.freezed.dart';
part 'response_queued_dto.g.dart';

@freezed
abstract class ResponseQueuedDTO with _$ResponseQueuedDTO {
  const ResponseQueuedDTO._();

  const factory ResponseQueuedDTO({
    required int queueOrder,
  }) = _ResponseQueuedDTO;

  factory ResponseQueuedDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseQueuedDTOFromJson(json);

  factory ResponseQueuedDTO.fromDataModel(ResponseQueued model) {
    return ResponseQueuedDTO(
      queueOrder: model.queueOrder,
    );
  }

  ResponseQueued toDataModel() {
    return ResponseQueued(
      queueOrder: queueOrder,
    );
  }
}
