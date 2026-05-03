class NetraResponse {
  final Map<String, Object?>? data;
  final int statusCode;
  final String? error;

  NetraResponse({ required this.statusCode, this.data, this.error });
}
