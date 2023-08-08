import 'dart:convert';

class RequestPayload {
  late int page;
  late int start;
  late int limit;
  late Map<String, dynamic>? filter;
  late List<Map<String, dynamic>> sort;

  RequestPayload(
      {this.page = 1,
      this.start = 0,
      this.limit = 50,
      this.filter,
      this.sort = const [
        {"property": "Description", "direction": "ASC"}
      ]});

//   RequestPayload copyWith({int}) {
//     return RequestPayload()
// }

  String toPath() {
    String payloadToPath =
        "page=$page&start=$start&limit=$limit&sort=${jsonEncode(sort)}";
    if (filter != null) {
      payloadToPath += "&filter=${jsonEncode(filter)}";
    }

    return payloadToPath;
  }
}
