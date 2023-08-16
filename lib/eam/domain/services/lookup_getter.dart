class LookupGetter {
  static int getID(Map<String, dynamic> lookup) {
    return lookup["_id"];
  }

  static String getDescription(Map<String, dynamic> lookup) {
    return lookup["description"];
  }

  static String getDescriptionTranslation(Map<String, dynamic> lookup) {
    return lookup["_description_translation"];
  }

  static String getCode(Map<String, dynamic> lookup) {
    return lookup["code"];
  }
}
