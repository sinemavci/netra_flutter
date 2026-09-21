sealed class Response {
  const Response();
}

final class ResponseReceived extends Response {
  final Object? data;
  final int statusCode;
  final String? statusMessage;
  final Map<String, String?>? headers;

  const ResponseReceived({
    required this.statusCode,
    this.data,
    this.statusMessage,
    this.headers,
  });
}

final class ResponseQueued extends Response {
  final int queueOrder;

  const ResponseQueued({required this.queueOrder});
}

//todo:
// response.requestOptions; // The original RequestOptions
// response.redirects;      // List of redirects followed
// response.isRedirect;     // Whether the response was redirected
// response.extra;
