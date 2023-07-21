import 'package:flutter/material.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/widgets/app-text-form-field.dart';

import '../../data/urls.dart';
import '../utils/text-styles.dart';
import '../widgets/app-elevated-button.dart';
import '../widgets/app-text-button.dart';
import '../widgets/screen-Background-images.dart';
import 'loginScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const ResetPasswordScreen({Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Password',
                  style: screenTitleTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                    'Minimum length password 8 character with Letter & Number combination',
                    style: screenSubTitleStyle),
                const SizedBox(height: 24),
                AppTextFormFieldWidget(
                  hintText: 'Password',
                  controller: newPasswordController,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your new password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextFormFieldWidget(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || ((value ?? '') != newPasswordController.text)) {
                      return 'Password mismatch';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppElevatedButton(
                  child: const Text('Confirm'),
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      if (mounted) {
                        final response = await NetworkUtils()
                            .postMethod(Urls.resetPasswordUrl, body: {
                          "email": widget.email,
                          "OTP": widget.otp,
                          "password": newPasswordController.text
                        });
                        if (response != null && response['status'] == 'success') {
                          if (mounted) {
                            showSnackBarMessage(
                                context, 'Password reset success!');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          }
                        } else{
                          if(mounted){
                            showSnackBarMessage(context, 'Passoword reset failed. Try again!',true);
                          }
                        }
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                AppTextButton(
                  text1: "Have account?",
                  text2: 'Sign in',
                  ontap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
