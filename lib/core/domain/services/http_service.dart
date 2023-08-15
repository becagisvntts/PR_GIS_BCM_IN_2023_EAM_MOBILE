import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/auth_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/connection_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/screens/login_screen.dart';

class HttpService {
  static const apiUrl =
      'https://becamaint.becagis.vn/cmdbuild/services/rest/v3/';
  static const serverUrl = 'https://becamaint.becagis.vn/';

  static Future<http.Response> post(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? sessionId}) async {
    bool isOnline = await checkConnection();
    if (isOnline) {
      var response = await http.post(Uri.parse(endpoint),
          headers: getHeaders(sessionId), body: jsonEncode(body));

      checkAuthorizationResponseAndRedirect(response);
      return response;
    }
    throw Exception(["No internet"]);
  }

  static Future<http.Response> postWithAuth(
      {required String endpoint, Map<String, dynamic>? body}) async {
    String? sessionId = await AuthService.getSessionId();
    return await post(endpoint: endpoint, sessionId: sessionId, body: body);
  }

  static Future<http.Response> get(
      {required String endpoint, String? sessionId}) async {
    bool isOnline = await checkConnection();
    if (isOnline) {
      var response =
          await http.get(Uri.parse(endpoint), headers: getHeaders(sessionId));
      checkAuthorizationResponseAndRedirect(response);
      return response;
    }
    throw Exception();
  }

  static Future<http.Response> getWithAuth({required String endpoint}) async {
    String? sessionId = await AuthService.getSessionId();
    return await get(endpoint: endpoint, sessionId: sessionId);
  }

  static Future<http.Response> put(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? sessionId}) async {
    bool isOnline = await checkConnection();
    if (isOnline) {
      var response = await http.put(
        Uri.parse(endpoint),
        headers: getHeaders(sessionId),
        body: jsonEncode(body),
      );
      checkAuthorizationResponseAndRedirect(response);
      return response;
    }

    throw Exception();
  }

  static Future<http.Response> putWithAuth(
      {required String endpoint, Map<String, dynamic>? body}) async {
    String? sessionId = await AuthService.getSessionId();
    return await put(endpoint: endpoint, body: body, sessionId: sessionId);
  }

  static Future<http.Response> delete(
      {required String endpoint,
      Map<String, dynamic>? body,
      String? sessionId}) async {
    bool isOnline = await checkConnection();
    if (isOnline) {
      var response = await http.delete(
        Uri.parse(endpoint),
        headers: getHeaders(sessionId),
        body: jsonEncode(body),
      );
      checkAuthorizationResponseAndRedirect(response);
      return response;
    }

    throw Exception();
  }

  static Future<http.Response> deleteWithAuth(
      {required String endpoint, Map<String, dynamic>? body}) async {
    String? sessionId = await AuthService.getSessionId();
    return await delete(endpoint: endpoint, body: body, sessionId: sessionId);
  }

  static Future<http.StreamedResponse> uploadFile(
      {required String endpoint,
      required String filePath,
      String? sessionId}) async {
    bool isOnline = await checkConnection();
    if (isOnline) {
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.headers.addAll({'Cmdbuild-authorization': sessionId ?? ""});
      var response = await request.send();
      return response;
    }

    throw Exception();
  }

  static Future<http.StreamedResponse> uploadFileWithAuth(
      {required String endpoint, required String filePath}) async {
    String? sessionId = await AuthService.getSessionId();
    return uploadFile(
        endpoint: endpoint, filePath: filePath, sessionId: sessionId);
  }

  static Map<String, String> getHeaders(String? sessionId) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (sessionId != null) {
      headers['Cmdbuild-authorization'] = sessionId;
    }

    return headers;
  }

  static Future<bool> checkConnection() async {
    bool isOnline = await ConnectionService.isOnline();
    if (!isOnline) {
      NotifyService.showErrorMessage(
          LocalizationService.translate.msg_no_internet);
      return false;
    }
    return true;
  }

  static void checkAuthorizationResponseAndRedirect(http.Response response) {
    if (response.statusCode == 401) {
      NavigationHelper.push(const LoginScreen());
    }
  }
}
