import 'dart:convert';

import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/models/user.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/connection_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/screens/login_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/actions/user_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String loginEndpoint =
      '${HttpService.apiUrl}sessions?scope=service&returnId=true';
  static String loginGoogleEndpoint =
      '${HttpService.apiUrl}users/login-google/';
  static String loginAppleEndpoint = '${HttpService.apiUrl}users/login-apple/';
  static String signupEndpoint = '${HttpService.apiUrl}users/signup/';
  static String forgotPasswordEndpoint =
      '${HttpService.apiUrl}users/forgot-password/';
  static String resetPasswordEndpoint =
      '${HttpService.apiUrl}users/reset-password/';
  static String changePasswordEndpoint =
      '${HttpService.apiUrl}users/change-password/';
  static String selfDeleteEndpoint = '${HttpService.apiUrl}users/self-delete/';
  static String refreshEndpoint = '${HttpService.apiUrl}token/refresh/';
  static String meEndpoint = '${HttpService.apiUrl}users/me/';
  static String accessTokenKey = 'accessToken';
  static String refreshTokenKey = 'refreshToken';
  static String sessionIdKey = 'sessionIdKey';
  static String userDataKey = 'userData';

  static Future<bool> checkAuthToken() async {
    bool isOnline = await ConnectionService.isOnline();
    if (isOnline) {
      String? accessToken = await getSessionId();
      if (accessToken != null) {
        return await getUserData(accessToken);
      }
    }
    return false;
  }

  static Future<bool> getUserData(String sessionId) async {
    var response =
        await HttpService.get(endpoint: meEndpoint, sessionId: sessionId);
    if (response.statusCode == 200) {
      Map<String, dynamic> userData =
          jsonDecode(utf8.decode(response.bodyBytes));
      return await saveUserData(userData);
    } else {
      return await refreshToken();
    }
  }

  static Future<bool> refreshToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      var refreshRes = await HttpService.post(
          endpoint: refreshEndpoint, body: {'refresh': refreshToken});
      if (refreshRes.statusCode == 200) {
        String accessToken = jsonDecode(refreshRes.body)['access'];
        saveSessionId(accessToken);
        return await getUserData(accessToken);
      }
    }

    clearUserDataAndRedirectToLogin();
    return false;
  }

  static void clearUserDataAndRedirectToLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(sessionIdKey);
    prefs.remove(userDataKey);

    NavigationHelper.pushReplacement(const LoginScreen());
  }

  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    User userModel = User(
        fullName: userData['username'],
        username: userData['username'],
        userId: userData['userId']!,
        userDescription: userData['userDescription'],
        role: userData['role'],
        availableRoles: (userData['availableRoles'] as List)
            .map((el) => el as String)
            .toList(),
        multigroup: userData['multigroup'],
        rolePrivileges: (userData['rolePrivileges'] as Map)
            .map((key, value) => MapEntry(key.toString(), value as bool)),
        beginDate: userData['beginDate'],
        lastActive: userData['lastActive'],
        sessionType: userData['sessionType'],
        device: userData['device']);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userDataKey, jsonEncode(userModel.toJson()));

    StateHelper.store.dispatch(UpdateUserDataAction(user: userModel));
    return true;
  }

  static Future<void> saveSessionId(String sessionId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionIdKey, sessionId);
  }

  static Future<String?> getSessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(sessionIdKey);
    return sessionId;
  }

  static Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString(refreshTokenKey);
    return refreshToken;
  }

  static Future<dynamic> signUp(Map<String, dynamic> formData) async {
    try {
      var response = await HttpService.post(
          endpoint: AuthService.signupEndpoint, body: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (ex) {
      return {'error': LocalizationService.translate.msg_no_internet};
    }
  }

  static Future<dynamic> login(Map<String, dynamic> formData) async {
    saveUserNameAndPassword(formData);
    var response = await HttpService.post(
        endpoint: AuthService.loginEndpoint, body: formData);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> userData = responseData['data'];
      saveSessionId(userData['_id']!);
      saveUserData(userData);
      return true;
    }
    return jsonDecode(utf8.decode(response.bodyBytes));

    // try {
    //
    // } catch (ex) {
    //   return {'error': LocalizationService.translate.msg_no_internet};
    // }
  }

  static void saveUserNameAndPassword(Map<String, dynamic> formData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", formData["username"]);
    prefs.setString("password", formData["password"]);
  }

  static Future<Map<String, dynamic>> getUserNameAndPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    String? password = prefs.getString("password");
    return {"username": username, "password": password};
  }

  static Future<dynamic> changePassword(Map<String, dynamic> formData) async {
    try {
      var response = await HttpService.postWithAuth(
          endpoint: AuthService.changePasswordEndpoint, body: formData);
      if (response.statusCode == 200) {
        return true;
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (ex) {
      return {'error': LocalizationService.translate.msg_no_internet};
    }
  }

  static Future<dynamic> selfDelete() async {
    try {
      var response = await HttpService.postWithAuth(
          endpoint: AuthService.selfDeleteEndpoint);
      if (response.statusCode == 200) {
        return true;
      } else {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (ex) {
      return {'error': LocalizationService.translate.msg_no_internet};
    }
  }

  static Future<dynamic> forgotPassword(Map<String, dynamic> formData) async {
    var response = await HttpService.post(
        endpoint: AuthService.forgotPasswordEndpoint, body: formData);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      return true;
    } else {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
  }

  static void logout() {
    clearUserDataAndRedirectToLogin();
    logoutGoogle();
  }

  static Future<dynamic> loginWithGoogle() async {
    // late GoogleSignIn googleSignIn;
    // if (Platform.isIOS) {
    //   googleSignIn = GoogleSignIn(
    //       clientId:
    //           "443827459636-qth9rh3rkos629lsh22sr7inrc0dcq39.apps.googleusercontent.com");
    // } else {
    //   googleSignIn = GoogleSignIn();
    // }
    //
    // final GoogleSignInAccount? googleSignInAccount =
    //     await googleSignIn.signIn();
    //
    // if (googleSignInAccount != null) {
    //   Map<String, dynamic> authData = {
    //     "email": googleSignInAccount.email,
    //     "name": googleSignInAccount.displayName,
    //     "provider": 'google',
    //     "uid": googleSignInAccount.id,
    //     "avatar_url": googleSignInAccount.photoUrl
    //   };
    //   // final GoogleSignInAuthentication googleSignInAuthentication =
    //   //     await googleSignInAccount.authentication;
    //
    //   try {
    //     var response = await HttpService.post(
    //         endpoint: AuthService.loginGoogleEndpoint, body: authData);
    //     if (response.statusCode == 200) {
    //       Map<String, dynamic> data =
    //           jsonDecode(utf8.decode(response.bodyBytes));
    //       saveAccessToken(data['access']!);
    //       saveRefreshToken(data['refresh']!);
    //       saveUserData(data);
    //       return true;
    //     } else {
    //       return jsonDecode(utf8.decode(response.bodyBytes));
    //     }
    //   } catch (ex) {
    //     return {'error': LocalizationService.translate.msg_no_internet};
    //   }
    // }
    //
    // return {'error': 'Không thể kết nối tới tài khoản google của bạn'};
  }

  static void logoutGoogle() async {
    // late GoogleSignIn googleSignIn;
    // if (Platform.isIOS) {
    //   googleSignIn = GoogleSignIn(
    //       clientId:
    //           "443827459636-qth9rh3rkos629lsh22sr7inrc0dcq39.apps.googleusercontent.com");
    // } else {
    //   googleSignIn = GoogleSignIn();
    // }
    // await googleSignIn.signOut();
  }

  static Future<dynamic> loginWithApple() async {
    // final credential = await SignInWithApple.getAppleIDCredential(scopes: [
    //   AppleIDAuthorizationScopes.email,
    //   AppleIDAuthorizationScopes.fullName
    // ]);
    //
    // String? fullName = credential.familyName;
    // if (credential.givenName != null) {
    //   fullName = "${fullName ?? ""} ${credential.givenName}";
    // }
    //
    // Map<String, dynamic> authData = {
    //   "email": credential.email,
    //   "name": fullName,
    //   "provider": 'apple',
    //   "uid": credential.userIdentifier,
    //   "avatar_url": ""
    // };
    //
    // try {
    //   var response = await HttpService.post(
    //       endpoint: AuthService.loginAppleEndpoint, body: authData);
    //   if (response.statusCode == 200) {
    //     Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    //     saveAccessToken(data['access']!);
    //     saveRefreshToken(data['refresh']!);
    //     saveUserData(data);
    //     return true;
    //   } else {
    //     return jsonDecode(utf8.decode(response.bodyBytes));
    //   }
    // } catch (ex) {
    //   return {'error': LocalizationService.translate.msg_no_internet};
    // }
  }
}
