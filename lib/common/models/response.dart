class Response {
  final Map<String, Object?>? data;
  final int statusCode;
  final String? statusMessage;
  final Map<String, String?>? headers;

  Response({
    required this.statusCode,
    this.data,
    this.statusMessage,
    this.headers,
  });
}
//todo:
// response.requestOptions; // The original RequestOptions
// response.redirects;      // List of redirects followed
// response.isRedirect;     // Whether the response was redirected
// response.extra;