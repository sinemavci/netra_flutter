import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/models/response.dart';

abstract class Interceptor {
  Future<RequestOptions> onRequest(RequestOptions request);

  Future<Response> onResponse(Response response);
}