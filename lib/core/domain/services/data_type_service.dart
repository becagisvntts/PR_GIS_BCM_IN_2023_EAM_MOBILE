class DataTypeService {
  static List<Map<String, dynamic>> listToListMapStringDynamic(
      List<dynamic> list) {
    return (list).map((e) => e as Map<String, dynamic>).toList();
  }
}
