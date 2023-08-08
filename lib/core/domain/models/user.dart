class User {
  late String fullName;
  late String email;
  late String? avatar;
  late String username;
  late int userId;
  late String userDescription;
  late String role;
  late List<String> availableRoles;
  late bool multigroup;
  late Map<String, bool> rolePrivileges;
  late String beginDate;
  late String lastActive;
  late String device;
  late String sessionType;

  User(
      {this.fullName = "",
      this.email = "",
      this.userId = -1,
      this.avatar,
      this.username = "",
      this.userDescription = "",
      this.role = "",
      this.availableRoles = const [],
      this.multigroup = false,
      this.rolePrivileges = const {},
      this.lastActive = "",
      this.beginDate = "",
      this.device = "",
      this.sessionType = ""});

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "userId": userId,
      "avatar": avatar,
      "username": username,
      "userDescription": userDescription,
      "role": role,
      "availableRoles": availableRoles,
      "multigroup": multigroup,
      "rolePrivileges": rolePrivileges,
      "lastActive": lastActive,
      "beginDate": beginDate,
      "device": device,
      "sessionType": sessionType
    };
  }
}
