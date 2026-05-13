import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/circuit_breaker_options.dart';

part 'circuit_breaker_options_dto.freezed.dart';
part 'circuit_breaker_options_dto.g.dart';

@freezed
abstract class CircuitBreakerOptionsDTO with _$CircuitBreakerOptionsDTO {
  const CircuitBreakerOptionsDTO._();

  const factory CircuitBreakerOptionsDTO({
    required int failureThreshold,
    required double retryDelayMs,
  }) = _CircuitBreakerOptionsDTO;

  factory CircuitBreakerOptionsDTO.fromJson(Map<String, dynamic> json) =>
      _$CircuitBreakerOptionsDTOFromJson(json);

  factory CircuitBreakerOptionsDTO.fromDataModel(CircuitBreakerOptions model) {
    return CircuitBreakerOptionsDTO(
      failureThreshold: model.failureThreshold!,
      retryDelayMs: model.retryDelayMs!,
    );
  }

  CircuitBreakerOptions toDataModel() {
    return CircuitBreakerOptions(
      retryDelayMs: retryDelayMs,
      failureThreshold: failureThreshold,
    );
  }
}
