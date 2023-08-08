import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/auth_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/screens/register_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/auth_header_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/future_button.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/preload_eam_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormBuilderState>();
  late bool obscureText = true;
  late String usernameSaved = "";
  late String passwordSaved = "";

  @override
  void initState() {
    super.initState();
    loadUserNameAndPasswordFromStorage();
  }

  void loadUserNameAndPasswordFromStorage() async {
    Map<String, dynamic> data = await AuthService.getUserNameAndPassword();
    loginFormKey.currentState?.patchValue(data);
  }

  void togglePassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void handleLogin() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      Map<String, dynamic> formData = loginFormKey.currentState!.value;
      dynamic response = await AuthService.login(formData);
      if (response == true) {
        NavigationHelper.pushReplacement(const PreloadEamScreen());
      } else {
        List errors = response["messages"] as List;
        NotifyService.showErrorMessage(jsonEncode(errors));
      }
    }
  }

  // void handleLoginWithGoogle() async {
  //   dynamic response = await AuthService.loginWithGoogle();
  //   if (response == true) {
  //     NavigationHelper.pushReplacement(const ClassesListScreen());
  //   } else {
  //     Map<String, dynamic> errors = response as Map<String, dynamic>;
  //     for (String key in errors.keys) {
  //       NotifyService.showErrorMessage(
  //           errors[key].runtimeType is List ? errors[key][0] : errors[key]);
  //     }
  //   }
  // }
  //
  // void handleLoginWithApple() async {
  //   dynamic response = await AuthService.loginWithApple();
  //   if (response == true) {
  //     NavigationHelper.pushReplacement(const ClassesListScreen());
  //   } else {
  //     Map<String, dynamic> errors = response as Map<String, dynamic>;
  //     for (String key in errors.keys) {
  //       NotifyService.showErrorMessage(
  //           errors[key].runtimeType is List ? errors[key][0] : errors[key]);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: PageContent(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
              AuthHeaderWidget(
                  pageTitle: LocalizationService.translate.user_login),
              FormBuilder(
                  key: loginFormKey,
                  child: Column(children: [
                    FormControl(
                        child: FormBuilderTextField(
                            key: const ValueKey("username"),
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: FormInputDecoration(
                                    placeholder: LocalizationService
                                        .translate.user_username)
                                .copyWith(
                                    prefixIcon: const Icon(
                                        Icons.supervisor_account_rounded,
                                        color: ThemeConfig.appColor)),
                            name: 'username',
                            initialValue: usernameSaved,
                            keyboardType: TextInputType.text,
                            // textInputAction: TextInputAction.next,
                            validator: (val) {
                              if ((val == null || val.trim().isEmpty)) {
                                return LocalizationService.translate
                                    .msg_field_required(LocalizationService
                                        .translate.user_username);
                              }
                              return null;
                            })),
                    FormControl(
                        child: FormBuilderTextField(
                            key: const ValueKey("password"),
                            decoration: FormInputDecoration(
                                    placeholder: LocalizationService
                                        .translate.user_password)
                                .copyWith(
                                    prefixIcon: const Icon(Icons.lock_rounded,
                                        color: ThemeConfig.appColor),
                                    suffix: IconButton(
                                        onPressed: togglePassword,
                                        icon: obscureText
                                            ? const Icon(CupertinoIcons.eye,
                                                color: ThemeConfig.appColor)
                                            : const Icon(
                                                CupertinoIcons.eye_slash,
                                                color: ThemeConfig.appColor))),
                            name: 'password',
                            initialValue: passwordSaved,
                            obscureText: obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (val) {
                              if ((val == null || val.trim().isEmpty)) {
                                return LocalizationService.translate
                                    .msg_field_required(LocalizationService
                                        .translate.user_password);
                              }
                              return null;
                            })),
                    PaddingWrapper(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Expanded(
                              child: FormBuilderCheckbox(
                                  key: const ValueKey("rememberMe"),
                                  name: "rememberMe",
                                  initialValue: true,
                                  title: Text(
                                      LocalizationService
                                          .translate.user_login_remember_me,
                                      style: const TextStyle(
                                          color: ThemeConfig.appColor)))),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                  "${LocalizationService.translate.user_forgot_password}?"))
                        ])),
                    PaddingWrapper(
                        child: FutureButton(
                            btnName: LocalizationService.translate.user_login,
                            onPressed: handleLogin,
                            iconData: Icons.login_rounded),
                        top: 20,
                        bottom: 20)
                  ])),
              FormControl(
                  child: TextButton(
                      onPressed: () => NavigationHelper.pushReplacement(
                          const RegisterScreen()),
                      child: Text(
                          LocalizationService.translate.user_have_not_account,
                          style: const TextStyle(fontWeight: FontWeight.bold))))
              // dividerWithText(LocalizationService.translate.user_login_with,
              //     Colors.black38),
              // paddingWrapper(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         if (Platform.isIOS)
              //           IconButton(
              //               onPressed: handleLoginWithApple,
              //               icon: Image.asset("assets/images/ios_login.png",
              //                   width: 42, height: 42)),
              //         IconButton(
              //             onPressed: handleLoginWithGoogle,
              //             icon: Image.asset("assets/images/google_login.png",
              //                 width: 42, height: 42))
              //       ],
              //     ),
              //     top: 16)
            ])))));
  }
}
