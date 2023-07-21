import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/utils/text-styles.dart';
import 'package:softbyhasan/ui/widgets/app-elevated-button.dart';
import 'package:softbyhasan/ui/widgets/app-text-form-field.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';
import 'package:softbyhasan/ui/widgets/user-profile-widget.dart';

import 'main-bottom-navbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool inProgress = false;

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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Task',
                          style: screenTitleTextStyle,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AppTextFormFieldWidget(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Add Subject';
                              }
                              return null;
                            },
                            hintText: 'Subject',
                            controller: subjectController
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        AppTextFormFieldWidget(
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Add subject description';
                              }
                              return null;
                            },
                            maxLine: 6,
                            hintText: 'Description',
                            controller: descriptionController
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (inProgress)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          AppElevatedButton(
                              child:
                                  const Icon(Icons.arrow_circle_right_outlined),
                              ontap: () async {
                                if (formKey.currentState!.validate()) {
                                  inProgress = true;
                                  setState(() {});

                                  final result = await NetworkUtils().postMethod(
                                      'https://task.teamrabbil.com/api/v1/createTask',
                                      //token: AuthUtils.token,
                                      body: {
                                        "title": subjectController.text.trim(),
                                        "description": descriptionController.text.trim(),
                                        "status": "New"
                                      });
                                  inProgress = false;
                                  setState(() {});
                                  //log(result);

                                  if(result != null && result['status'] == 'success'){
                                     subjectController.clear();
                                     descriptionController.clear();
                                       if (mounted) {
                                         showSnackBarMessage(context, 'Task added successfully!');
                                         Navigator.pushAndRemoveUntil(context,
                                           MaterialPageRoute(builder: (
                                               context) => const MainBottomNavBar()), (
                                               route) => false);
                                       }

                                  } else{
                                    if (mounted) {
                                      showSnackBarMessage(context, 'Task adding failed! Try again',true);
                                    }
                                  }
                                }
                              })
                      ],
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
}
