import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/utils/auth-utils.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import '../utils/text-styles.dart';
import '../widgets/app-elevated-button.dart';
import '../widgets/app-text-form-field.dart';
import '../widgets/screen-Background-images.dart';
import '../widgets/user-profile-widget.dart';
import 'main-bottom-navbar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? pickedImage;
  static String? base64Image;
  bool inProgress = false;


  Future<void>updateProfile() async {
    inProgress = true;
    setState(() {});
    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      //print(imageBytes);
      base64Image = base64Encode(imageBytes);
      //log(base64Image!);
    }

    Map<String, String> bodyParams = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'mobile': mobileController.text.trim(),
      'password': passwordController.text,
      'photo': base64Image ?? ''
    };

    if (passwordController.text.isNotEmpty) {
      bodyParams['password'] = passwordController.text;
    }

    final result = await NetworkUtils().postMethod(
        'https://task.teamrabbil.com/api/v1/profileUpdate',
        body: bodyParams);
    if (result != null && result['status'] == 'success') {
      // firstNameController.clear();
      // lastNameController.clear();
      // mobileController.clear();
      // passwordController.clear();
      if (mounted) {
        showSnackBarMessage(context, 'Profile Updated');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainBottomNavBar()), (route) => false);
      }
      setState(() {});
      AuthUtils.saveUserData(
          result['data']['firstName'] = firstNameController.text.trim(),
          result['data']['lastName'] = lastNameController.text.trim(),
          result['token'] = AuthUtils.token ?? '',
          result['data']['photo'] = base64Image ?? '',
          result['data']['mobile'] = mobileController.text.trim(),
          result['data']['email'] = emailController.text.trim());
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Update failed. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    emailController.text = AuthUtils.email ?? '';
    firstNameController.text = AuthUtils.firstName ?? '';
    lastNameController.text = AuthUtils.lastName ?? '';
    mobileController.text = AuthUtils.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileWidget(),
            Expanded(
              child: ScreenBackground(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Profile',
                            style: screenTitleTextStyle,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () async {
                              imagePickerFunction();
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8))),
                                  child: const Text('Photos'),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8))),
                                    child: Text(
                                      pickedImage?.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          AppTextFormFieldWidget(
                            hintText: 'Email',
                            controller: emailController,
                            readOnly: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextFormFieldWidget(
                            hintText: 'First Name',
                            controller: firstNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter first name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextFormFieldWidget(
                            hintText: 'Last Name',
                            controller: lastNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter last name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextFormFieldWidget(
                            hintText: 'Mobile',
                            controller: mobileController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextFormFieldWidget(
                            obscureText: true,
                            hintText: 'Password',
                            controller: passwordController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          if (inProgress)
                            const Center(
                              child: CircularProgressIndicator(),
                            )
                          else
                            AppElevatedButton(
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined),
                                ontap: () {
                                  if (formKey.currentState!.validate()) {
                                    updateProfile();
                                  }
                                })
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> imagePickerFunction() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick Image from'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image),
                  onTap: () async {
                    pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(Icons.camera_alt_outlined),
                  onTap: () async {
                    pickedImage = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      setState(() {});
                    }
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        });
  }
}
