class DomainGetter {
  static const String directionDirect = "direct";
  static const String directionInverse = "inverse";

  static String getID(Map<String, dynamic> domain) {
    return domain["_id"];
  }

  static String getName(Map<String, dynamic> domain) {
    return domain["name"];
  }

  static String getSource(Map<String, dynamic> domain) {
    return domain["source"];
  }

  static String getDestination(Map<String, dynamic> domain) {
    return domain["destination"];
  }

  static String getDescription(Map<String, dynamic> domain) {
    return domain["description"];
  }

  static bool isDirect(Map<String, dynamic> domain) {
    return domain["sourceInline"];
  }

  static bool isInverse(Map<String, dynamic> domain) {
    return domain["destinationInline"];
  }

  static String getRelatedDescription(Map<String, dynamic> domain) {
    return isDirect(domain)
        ? domain["descriptionDirect"]
        : domain["descriptionInverse"];
  }

  static String getRelatedTargetClass(Map<String, dynamic> domain) {
    return isDirect(domain) ? domain["destination"] : domain["source"];
  }

  static bool getCollapseState(Map<String, dynamic> domain) {
    return isDirect(domain)
        ? domain["sourceDefaultClosed"]
        : domain["destinationDefaultClosed"];
  }

  static String getDirectionAsNumber(Map<String, dynamic> domain) {
    return isDirect(domain) ? "_2" : "_1";
  }

  static String getDirectionAsString(Map<String, dynamic> domain) {
    return isDirect(domain) ? directionDirect : directionInverse;
  }

  static bool haveMultipleDestinationTypes(Map<String, dynamic> domain) {
    ///Is direction direct
    return isDirect(domain) &&

        ///Have multiples destinations
        domain["destinations"].length > 1;
  }
}
