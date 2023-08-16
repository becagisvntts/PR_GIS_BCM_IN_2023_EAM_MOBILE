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

  static const String popRouteOnModifySuccess = "Modify success";

  static const int displayedAttributeOnShortModeCounter = 3;
}
