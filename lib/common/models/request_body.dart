class RequestBody {
  final dynamic content;
  final String contentType;
  final bool isMultipart;

  const RequestBody._({
    required this.content,
    this.contentType = "application/json; charset=utf-8",
    this.isMultipart = false,
  });

  factory RequestBody.createJson(String json, {
    String contentType = "application/json; charset=utf-8",
  }) {
    return RequestBody._(
      content: json,
      contentType: contentType,
    );
  }

  factory RequestBody.createBytes(List<int> bytes, {
    String contentType = "application/json; charset=utf-8",
  }) {
    return RequestBody._(
      content: bytes,
      contentType: contentType,
    );
  }

  factory RequestBody.createMap(Map<String, dynamic> map,) {
    return RequestBody._(
      content: map,
    );
  }

// factory NetraRequestBody.multipart(
//     List<NetraPart> parts,
//     ) {
//   return NetraRequestBody._(
//     content: parts,
//     contentType: "multipart/form-data",
//     isMultipart: true,
//   );
// }
}
