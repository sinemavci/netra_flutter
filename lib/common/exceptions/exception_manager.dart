import 'package:flutter/services.dart';
import 'package:netra_flutter/common/exceptions/base_platform_exception.dart';

class ExceptionManager {
  static const String timeoutException = 'NetraTimeoutException';
  static const String connectionException = 'NetraConnectionException';
  static const String dnsException = 'NetraDnsException';
  static const String sslException = 'NetraSslException';
  static const String socketException = 'NetraSocketException';
  static const String networkException = 'NetraNetworkException';

  static Exception parse(PlatformException error) {
    switch (error.code) {
      case timeoutException:
        return NetraTimeoutException(error.code, error.message);

      case connectionException:
        return NetraConnectionException(error.code, error.message);

      case dnsException:
        return NetraDnsException(error.code, error.message);

      case sslException:
        return NetraSslException(error.code, error.message);

      case socketException:
        return NetraSocketException(error.code, error.message);

      case networkException:
        return NetraNetworkException(error.code, error.message);

      default:
        return error;
    }
  }
}
