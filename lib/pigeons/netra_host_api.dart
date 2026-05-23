import 'package:pigeon/pigeon.dart';

//flutter pub run pigeon --input lib/pigeons/netra_host_api.dart
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeons/netra_host_api.g.dart',
  kotlinOut: 'android/src/main/kotlin/com/example/netra_flutter/pigeons/NetraControllerPigeon.kt',
  kotlinOptions: KotlinOptions(
    package: "com.example.netra_flutter.NetraControllerPigeon"
  )
))
@HostApi()
abstract class NetraHostApi {
  @async
  String? build(String baseUrl, String? convertedType, Map<String, String>? headers, String? circuitBreakerOptions);

  @async
  String? get(String clientId, String requestOptions);

  @async
  String? post(String clientId, String? data, String requestOptions);

  @async
  String? put(String clientId, String? data, String requestOptions);

  @async
  String? patch(String clientId, String? data, String requestOptions);

  @async
  String? delete(String clientId, String? data, String requestOptions);

  @async
  void stream(String clientId, String requestOptions);

  @async
  bool registerStream(String requestId);

  @async
  bool on(String clientId, String eventName, String eventId);

  @async
  bool off(String clientId, String eventId);
}