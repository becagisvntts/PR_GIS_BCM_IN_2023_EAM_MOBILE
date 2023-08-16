class AttributeGetter {
  static String getId(Map<String, dynamic> attribute) {
    return attribute["_id"];
  }

  static bool getShowInGrid(Map<String, dynamic> attribute) {
    return attribute["showInGrid"];
  }

  static String getType(Map<String, dynamic> attribute) {
    return attribute["type"];
  }

  static bool getSortingEnabled(Map<String, dynamic> attribute) {
    return attribute["sortingEnabled"];
  }

  static String getName(Map<String, dynamic> attribute) {
    return attribute["name"];
  }

  static String getDescription(Map<String, dynamic> attribute) {
    return attribute["description"];
  }

  static String getDomain(Map<String, dynamic> attribute) {
    return attribute["domain"];
  }

  static String getDirection(Map<String, dynamic> attribute) {
    return attribute["direction"];
  }

  static String getTargetClass(Map<String, dynamic> attribute) {
    return attribute["targetClass"];
  }
}
