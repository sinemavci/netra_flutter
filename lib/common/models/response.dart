class Response {
  final Map<String, Object?>? data;
  final int statusCode;
  final String? statusMessage;

  Response({ required this.statusCode, this.data, this.statusMessage });
}
//todo:
// response.headers;        // Response headers (Headers object)
// response.requestOptions; // The original RequestOptions
// response.redirects;      // List of redirects followed
// response.isRedirect;     // Whether the response was redirected
// response.extra;