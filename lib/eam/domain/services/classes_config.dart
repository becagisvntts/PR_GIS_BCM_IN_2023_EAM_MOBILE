class ClassesConfig {
  static const String menuTypeFolder = "folder";
  static const List<String> validatedMenuType = [
    "root",
    ClassesConfig.menuTypeFolder,
    "class"
  ];

  static const String classNameByKey = "_id";
  static const String firstLoadClassName = "TLCInfraSitePOP";
  static const String classTitleByKey = "description";
  static const String attributeShowInGridByKey = "showInGrid";
  static const String attributeSortingEnableByKey = "sortingEnabled";
  static const String attributeNameByKey = "name";
  static const String attributeTitleByKey = "description";
  static const String defaultAttributeSortingByKey = "Description";
  static const String defaultDirectionSorting = "ASC";
}
