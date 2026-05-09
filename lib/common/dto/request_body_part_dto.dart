import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/dto/request_body_dto.dart';
import 'package:netra_flutter/common/models/request_body_part.dart';

part 'request_body_part_dto.freezed.dart';
part 'request_body_part_dto.g.dart';

@freezed
abstract class RequestBodyPartDTO with _$RequestBodyPartDTO {
  const RequestBodyPartDTO._();

  const factory RequestBodyPartDTO({
    required String name,
    required String? filename,
    required RequestBodyDTO body,
  }) = _RequestBodyPartDTO;

  factory RequestBodyPartDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyPartDTOFromJson(json);

  factory RequestBodyPartDTO.fromDataModel(RequestBodyPart model) {
    return RequestBodyPartDTO(
      name: model.name,
      filename: model.fileName,
      body: RequestBodyDTO.fromDataModel(model.requestBody),
    );
  }
}
