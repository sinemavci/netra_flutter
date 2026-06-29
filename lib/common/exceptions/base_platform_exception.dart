part './netra_timeout_exception.dart';
part './netra_connection_exception.dart';
part './netra_dns_exception.dart';
part './netra_ssl_exception.dart';
part './netra_socket_exception.dart';
part './netra_network_exception.dart';

class BasePlatformException implements Exception {
  final String? message;
  final String? code;

  BasePlatformException(this.code, this.message);

  @override
  String toString() {
    return '$runtimeType(message: "$message")';
  }
}
