import 'package:flutter/material.dart';
import 'package:softbyhasan/data/models/task-model.dart';
import 'package:softbyhasan/data/network-utils.dart';
import 'package:softbyhasan/ui/screens/add-new-task-screen.dart';
import 'package:softbyhasan/ui/screens/update-profile-screen.dart';
import 'package:softbyhasan/ui/utils/snackbar-message.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';

import '../../data/urls.dart';
import '../widgets/changeTaskStatus-show-bottom-sheet.dart';
import '../widgets/dashboard.dart';
import '../widgets/task-list-item.dart';
class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  TaskModel newTaskModel = TaskModel();
  bool inProgress = false;
  dynamic count1;
  dynamic count2;
  dynamic count3;
  dynamic count4;

  @override
  void initState() {
    super.initState();
    getNewTasks();
    statusCount();
    setState(() {});
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete!'),
            content: const Text("Once delete, you won't be get it back"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    inProgress = true;
                    setState(() {});
                    await NetworkUtils().deleteMethod(Urls.deleteTaskUrl(id));
                    inProgress = false;
                    setState(() {});
                    getNewTasks();
                    statusCount();
                    statusCount();
                  },
                  child: const Text('Yes')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  Future<void> getNewTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/New');

    if (response != null) {
      newTaskModel = TaskModel.fromJson(response);
    } else {
      if (mounted) {
        showSnackBarMessage(context, 'Unable to fetch data. Try again!', true);
      }
    }
    inProgress = false;
    setState(() {});
  }

  Future<void> statusCount() async {
    final responseNewTask = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/New');
    final getNewTaskModel = TaskModel.fromJson(responseNewTask);

    setState(() {
      count1 = "${getNewTaskModel.data?.length ?? 0}";
    });

    final responseCancelTask = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/Cancelled');
    final getCaneTaskModel = TaskModel.fromJson(responseCancelTask);
    setState(() {
      count2 = "${getCaneTaskModel.data?.length?? 0}";
    });

    final responseCompletedTask = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/Completed');
    final getCompletedTaskModel = TaskModel.fromJson(responseCompletedTask);
    setState(() {
      count3 = "${getCompletedTaskModel.data?.length ?? 0}";
    });

    final responseProgressTask = await NetworkUtils()
        .getMethod('https://task.teamrabbil.com/api/v1/listTaskByStatus/Progress');
    final getProgressTaskModel = TaskModel.fromJson(responseProgressTask);
    setState(() {
      count4 = "${getProgressTaskModel.data?.length ?? 0}";
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScreenBackground(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DashboardItem(
                      typeOfTask: 'New',
                      numberOfTask: count1,
                    ),
                  ),
                  Expanded(
                    child: DashboardItem(
                      typeOfTask: 'Completed',
                      numberOfTask: count3,
                    ),
                  ),
                  Expanded(
                    child: DashboardItem(
                      typeOfTask: 'Cancelled',
                      numberOfTask: count2,
                    ),
                  ),
                  Expanded(
                    child: DashboardItem(
                      typeOfTask: 'In Progress',
                      numberOfTask: count4,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: inProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            getNewTasks();
                            statusCount();
                          },
                          child: ListView.builder(
                              itemCount: newTaskModel.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return TaskListItem(
                                  subject: newTaskModel.data?[index].title ??
                                      'Unknown',
                                  description:
                                      newTaskModel.data?[index].description ??
                                          'Unknown',
                                  date: newTaskModel.data?[index].createdDate ??
                                      'Unknown',
                                  type: 'New',
                                  backgroundColor: Colors.lightBlueAccent,
                                  onEdit: () {
                                    showChangedTaskStatus('New',
                                        newTaskModel.data?[index].sId ?? '',
                                        () {
                                      getNewTasks();
                                      statusCount();
                                      setState(() {});
                                    });
                                  },
                                  onDelete: () {
                                    deleteTask(newTaskModel.data?[index].sId);
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
