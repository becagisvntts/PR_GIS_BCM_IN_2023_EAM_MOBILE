class DataListMeta {
  late int total;
  late int pageSize;
  late int page;
  late int totalPages;

  DataListMeta(
      {this.total = 0, this.pageSize = 0, this.page = 1, this.totalPages = 1});

  DataListMeta.fromJson(Map<String, dynamic> json) {
    total = json.containsKey("total") ? json["total"] : 0;
    pageSize = json.containsKey("pageSize") ? json["pageSize"] : 0;
    page = json.containsKey("page") ? json["page"] : 1;
    totalPages = json.containsKey("totalPages") ? json["totalPages"] : 1;
  }
}
