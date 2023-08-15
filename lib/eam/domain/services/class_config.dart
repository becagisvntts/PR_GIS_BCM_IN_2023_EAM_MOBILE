class ClassConfig {
  static const String menuTypeFolder = "folder";
  static const List<String> validatedMenuType = [
    "root",
    ClassConfig.menuTypeFolder,
    "class"
  ];

  static const String firstLoadClassName = "TLCInfraSitePOP";

  static const String defaultAttributeSortingByKey = "Description";
  static const String defaultDirectionSorting = "ASC";

  static const String classTypeByKey = "name";
  static const String classIdByKey = "_id";
  static const String classAttributeGroupsByKey = "attributeGroups";
  static const String classTitleByKey = "description";

  static const String attributeShowInGridByKey = "showInGrid";
  static const String attributeSortingEnableByKey = "sortingEnabled";
  static const String attributeNameByKey = "name";
  static const String attributeTitleByKey = "description";

  static const String cardClassTypeByKey = "_type";
  static const String cardIdByKey = "_id";
  static const String cardTitleByKey = "Description";

  static const String popRouteOnModifySuccess = "Modify success";
}
