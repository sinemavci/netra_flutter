import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/cache_options.dart';

part 'cache_options_dto.freezed.dart';
part 'cache_options_dto.g.dart';

@freezed
abstract class CacheOptionsDTO with _$CacheOptionsDTO {
  const CacheOptionsDTO._();

  const factory CacheOptionsDTO({
    required num? ttl,
  }) = _CacheOptionsDTO;

  factory CacheOptionsDTO.fromJson(Map<String, dynamic> json) =>
      _$CacheOptionsDTOFromJson(json);

  factory CacheOptionsDTO.fromDataModel(CacheOptions model) {
    return CacheOptionsDTO(
      ttl: model.ttl,
    );
  }

  CacheOptions toDataModel() {
    return CacheOptions(
      ttl: ttl,
    );
  }
}
