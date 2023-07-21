import 'package:flutter/material.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/data/urls.dart';
import 'package:softbyhasan/ui/screens/otp-verification-screen.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/utils/text-styles.dart';
import 'package:softbyhasan/ui/widgets/app-text-form-field.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';

import '../widgets/app-elevated-button.dart';
import '../widgets/app-text-button.dart';

class VerifyWithEmail extends StatefulWidget {
  const VerifyWithEmail({Key? key}) : super(key: key);

  @override
  State<VerifyWithEmail> createState() => _VerifyWithEmailState();
}

class _VerifyWithEmailState extends State<VerifyWithEmail> {
  bool inProgess = false;

  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Email Address',
                  style: screenTitleTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                    'A 6 digits verification pin will be sent to your email address',
                    style: screenSubTitleStyle),
                const SizedBox(height: 24),
                AppTextFormFieldWidget(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                    hintText: 'Email',
                    controller: emailController),
                const SizedBox(
                  height: 24,
                ),
                if (inProgess)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  AppElevatedButton(
                    child: const Icon(Icons.arrow_forward_ios),
                    ontap: () async {
                      if (formKey.currentState!.validate()) {
                        inProgess = true;
                        setState(() {});

                        final response = await NetworkUtils().getMethod(
                            Urls.recoveryEmailUrl(emailController.text.trim()));
                        if (response != null &&
                            response['status'] == 'success') {
                          if (mounted) {
                            showSnackBarMessage(
                                context, 'OTP sent to email address');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpVerificationScreen(
                                          email: emailController.text.trim(),
                                        )));
                          }
                        } else {
                          if (mounted) {
                            showSnackBarMessage(
                                context, 'OTP sent failed. Try again!', true);
                          }
                        }
                        inProgess = false;
                        setState(() {});
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
                    Navigator.pop(context);
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
