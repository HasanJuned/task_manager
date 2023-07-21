import 'package:flutter/material.dart';
import 'package:softbyhasan/main.dart';

import '../../data/network-utils.dart';
import '../../data/urls.dart';
import '../utils/snackbar-message.dart';
import 'app-elevated-button.dart';

showChangedTaskStatus(String currentStatus, String taskId, VoidCallback onChangeTaskStatus) {
  String statusValue = currentStatus;

  showModalBottomSheet(
      context: TaskManager.globalKey.currentContext!,
      builder: (context) {
        return StatefulBuilder(builder: (context, changeState) {
          return Column(
            children: [
              RadioListTile(
                  value: 'New',
                  title: const Text('New'),
                  groupValue: statusValue,
                  onChanged: (state) {
                    statusValue = state!;
                    changeState(() {});
                  }),
              RadioListTile(
                  value: 'Completed',
                  title: const Text('Completed'),
                  groupValue: statusValue,
                  onChanged: (state) {
                    statusValue = state!;
                    changeState(() {});
                  }),
              RadioListTile(
                  value: 'Cancelled',
                  title: const Text('Cancelled'),
                  groupValue: statusValue,
                  onChanged: (state) {
                    statusValue = state!;
                    changeState(() {});
                  }),
              RadioListTile(
                  value: 'Progress',
                  title: const Text('Progress'),
                  groupValue: statusValue,
                  onChanged: (state) {
                    statusValue = state!;
                    changeState(() {});
                  }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppElevatedButton(
                    child: const Text('Change Status'),
                    ontap: () async {
                      final response = await NetworkUtils().getMethod(Urls.changeTaskUrl(taskId, statusValue));
                      if (response != null) {
                        onChangeTaskStatus();
                        Navigator.pop(context);
                      } else {
                        showSnackBarMessage(
                            context, 'Status change failed. Try again!', true);
                      }
                    }),
              )
            ],
          );
        });
      });
}
