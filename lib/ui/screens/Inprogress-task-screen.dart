import 'package:flutter/material.dart';

import '../../data/models/task-model.dart';
import '../../data/network-utils.dart';
import '../../data/urls.dart';
import '../utils/snackbar-message.dart';
import '../widgets/changeTaskStatus-show-bottom-sheet.dart';
import '../widgets/screen-Background-images.dart';
import '../widgets/task-list-item.dart';
import 'add-new-task-screen.dart';

class InprogressTaskScreen extends StatefulWidget {
  const InprogressTaskScreen({Key? key}) : super(key: key);

  @override
  State<InprogressTaskScreen> createState() => _InprogressTaskScreenState();
}

class _InprogressTaskScreenState extends State<InprogressTaskScreen> {
  TaskModel inProgressTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    inProgressTasks();
  }

  Future<void> deleteTask(dynamic id) async {
    showDialog(context: context, builder: (context){

      return AlertDialog(
        title: const Text('Delete !'),
        content: const Text("Once delete, you won't be get it back"),
        actions: [
          OutlinedButton(onPressed: () async {
            Navigator.pop(context);
            inProgress = true;
            setState(() {});
            await NetworkUtils().deleteMethod(Urls.deleteTaskUrl(id));
            inProgress = false;
            setState(() {});
            inProgressTasks();

          }, child: const Text('Yes')),
          OutlinedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('No')),

        ],

      );

    });

  }

  Future<void> inProgressTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Progress');

    if (response != null) {
      inProgressTaskModel = TaskModel.fromJson(response);
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
                      inProgressTasks();
                    },
                    child: ListView.builder(
                        itemCount: inProgressTaskModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListItem(
                            subject:
                            inProgressTaskModel.data?[index].title ??
                                'Unknown',
                            description: inProgressTaskModel
                                .data?[index].description ??
                                'Unknown',
                            date: inProgressTaskModel
                                .data?[index].createdDate ??
                                'Unknown',
                            type: 'Progress',
                            backgroundColor: Colors.purple,
                            onEdit: () {
                              showChangedTaskStatus(
                                  'Progress',
                                  inProgressTaskModel.data?[index].sId ??
                                      '', () {
                                inProgressTasks();
                              });
                            },
                            onDelete: () {
                              deleteTask(inProgressTaskModel.data?[index].sId);
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
