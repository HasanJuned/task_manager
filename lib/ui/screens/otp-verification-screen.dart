import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/screens/loginScreen.dart';
import 'package:softbyhasan/ui/screens/reset-password-screen.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';

import '../../data/urls.dart';
import '../utils/text-styles.dart';
import '../widgets/app-elevated-button.dart';
import '../widgets/app-text-button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pin Verification',
                style: screenTitleTextStyle,
              ),
              const SizedBox(height: 8),
              Text(
                  'A 6 digits verification pin will be sent to your email address',
                  style: screenSubTitleStyle),
              const SizedBox(height: 24),
              PinCodeTextField(
                controller: otpController,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: Colors.green),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                onCompleted: (v) {
                  log("Completed");
                },
                onChanged: (value) {
                  log(value);
                  setState(() {});
                },
                beforeTextPaste: (text) {
                  log("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
              ),
              const SizedBox(
                height: 24,
              ),
              AppElevatedButton(
                child: const Text('Verify'),
                ontap: () async {
                  final response = await NetworkUtils().getMethod(
                      Urls.recoveryOtpUrl(
                          widget.email, otpController.text.trim()));

                  if (response != null && response['status'] == 'success') {
                    if (mounted) {
                      showSnackBarMessage(context, "OTP verification done!");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen(
                                    email: widget.email,
                                    otp: otpController.text,
                                  )));
                    }
                  } else {
                    if (mounted) {
                      showSnackBarMessage(context, "OTP verification failed. Check your OTP!", true);
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
      )),
    );
  }
}
