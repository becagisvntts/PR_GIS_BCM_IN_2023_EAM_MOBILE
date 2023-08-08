class ClassAttribute {
  late String id;
  late String type;
  late String name;
  late String description;
  late bool showInGrid;
  late bool unique;
  late bool active;
  late int index;
  late String? defaultValue;
  late String group;
  late String groupDescription;

  ClassAttribute.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("_id")) {
      id = json["_id"];
    }
    if (json.containsKey("type")) {
      type = json["type"];
    }
    if (json.containsKey("name")) {
      name = json["name"];
    }
    if (json.containsKey("description")) {
      description = json["description"];
    }
    if (json.containsKey("showInGrid")) {
      showInGrid = json["showInGrid"];
    }
    if (json.containsKey("unique")) {
      unique = json["unique"];
    }
    if (json.containsKey("active")) {
      active = json["active"];
    }
    if (json.containsKey("index")) {
      index = json["index"];
    }
    if (json.containsKey("defaultValue")) {
      defaultValue = json["defaultValue"];
    }
    if (json.containsKey("group")) {
      group = json["group"];
    }
    if (json.containsKey("groupDescription")) {
      groupDescription = json["groupDescription"];
    }
  }
}
