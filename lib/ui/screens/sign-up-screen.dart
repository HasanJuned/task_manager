import 'package:flutter/material.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/screens/loginScreen.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/utils/text-styles.dart';
import 'package:softbyhasan/ui/widgets/app-elevated-button.dart';
import 'package:softbyhasan/ui/widgets/app-text-button.dart';
import 'package:softbyhasan/ui/widgets/app-text-form-field.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Join With Us',
                      style: screenTitleTextStyle,
                    ),
                    const SizedBox(height: 24),
                    AppTextFormFieldWidget(
                      hintText: 'Email',
                      controller: emailTextController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppTextFormFieldWidget(
                      hintText: 'First Name',
                      controller: firstNameTextController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppTextFormFieldWidget(
                      hintText: 'Last Name',
                      controller: lastNameTextController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppTextFormFieldWidget(
                      hintText: 'Mobile',
                      controller: mobileTextController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppTextFormFieldWidget(
                      hintText: 'Password',
                      controller: passwordTextController,
                      validator: (value) {
                        if ((value?.isEmpty ?? true) &&
                            (value?.length ?? 0) < 6) {
                          return 'Enter your password more than 6 letter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (inProgress)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      AppElevatedButton(
                          child: const Icon(Icons.arrow_forward_ios),
                          ontap: () async {
                            if (formKey.currentState!.validate()) {
                              inProgress = true;
                              setState(() {});
                              final result = await NetworkUtils().postMethod(
                                  'https://task.teamrabbil.com/api/v1/registration',
                                  body: {
                                    'email': emailTextController.text.trim(),
                                    'mobile': mobileTextController.text.trim(),
                                    'password': passwordTextController.text,
                                    'firstName':
                                        firstNameTextController.text.trim(),
                                    'lastName':
                                        lastNameTextController.text.trim(),
                                  });

                              inProgress = false;
                              setState(() {});
                              if (result != null && result['status'] == 'success') {
                                emailTextController.clear();
                                mobileTextController.clear();
                                passwordTextController.clear();
                                firstNameTextController.clear();
                                lastNameTextController.clear();

                                if (mounted) {
                                  showSnackBarMessage(context, 'Registration Successfull !');
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (context) => const LoginScreen()), (
                                          route) => false);
                                }
                              } else {
                                if (mounted) {
                                  showSnackBarMessage(
                                      context, 'Registration Failed !', true);
                                }
                              }
                            }
                          }),
                    const SizedBox(height: 16),
                    AppTextButton(
                      text1: 'Have account?',
                      text2: 'Sign in',
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
