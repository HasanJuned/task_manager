import 'package:flutter/material.dart';
import 'package:softbyhasan/data/urls.dart';

import '../../data/models/task-model.dart';
import '../../data/network-utils.dart';
import '../utils/snackbar-message.dart';
import '../widgets/changeTaskStatus-show-bottom-sheet.dart';
import '../widgets/screen-Background-images.dart';
import '../widgets/task-list-item.dart';
import 'add-new-task-screen.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  TaskModel cancelledTaskModel = TaskModel();
  bool inProgress = false;
  dynamic count2;

  @override
  void initState() {
    super.initState();
    cancelTasks();
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(context: context, builder: (context){

      return AlertDialog(
        title: const Text('Delete!'),
        content: const Text("Once delete, you won't be get it back"),
        actions: [
          OutlinedButton(onPressed: () async {
            Navigator.pop(context);
            inProgress = true;
            setState(() {});
            await NetworkUtils().deleteMethod(Urls.deleteTaskUrl(id));
            inProgress = false;
            setState(() {});
            cancelTasks();

          }, child: const Text('Yes')),
          OutlinedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('No')),
        ],
      );
    });
  }

  Future<void> cancelTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Cancelled');

    if (response != null) {
      cancelledTaskModel = TaskModel.fromJson(response);
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Unable to fetch data. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Column(
            children: [
              Expanded(
                  child: inProgress
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : RefreshIndicator(
                    onRefresh: () async {
                      cancelTasks();
                    },
                    child: ListView.builder(
                        itemCount: cancelledTaskModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListItem(
                            subject:
                            cancelledTaskModel.data?[index].title ??
                                'Unknown',
                            description: cancelledTaskModel
                                .data?[index].description ??
                                'Unknown',
                            date: cancelledTaskModel
                                .data?[index].createdDate ??
                                'Unknown',
                            type: 'Cancelled',
                            backgroundColor: Colors.purple,
                            onEdit: () {
                              showChangedTaskStatus(
                                  'Cancelled',
                                  cancelledTaskModel.data?[index].sId ??
                                      '', () {
                                cancelTasks();
                              });
                            },
                            onDelete: () {
                              deleteTask(cancelledTaskModel.data?[index].sId);
                            },
                          );
                        }),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
