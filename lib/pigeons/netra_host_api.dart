
import 'package:pigeon/pigeon.dart';

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
  String? get(String path);
}