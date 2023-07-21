import 'package:flutter/material.dart';
import 'package:softbyhasan/ui/widgets/screen-Background-images.dart';

import '../../data/models/task-model.dart';
import '../../data/network-utils.dart';
import '../../data/urls.dart';
import '../utils/snackbar-message.dart';
import '../widgets/changeTaskStatus-show-bottom-sheet.dart';
import '../widgets/task-list-item.dart';
import 'add-new-task-screen.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  TaskModel completedTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    completedNewTasks();
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
            completedNewTasks();

          }, child: const Text('Yes')),
          OutlinedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('No')),

        ],

      );

    });

  }

  Future<void> completedNewTasks() async {
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(
        'https://task.teamrabbil.com/api/v1/listTaskByStatus/Completed');

    if (response != null) {
      completedTaskModel = TaskModel.fromJson(response);
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
                            completedNewTasks();
                          },
                          child: ListView.builder(
                              itemCount: completedTaskModel.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return TaskListItem(
                                  subject:
                                      completedTaskModel.data?[index].title ??
                                          'Unknown',
                                  description: completedTaskModel
                                          .data?[index].description ??
                                      'Unknown',
                                  date: completedTaskModel
                                          .data?[index].createdDate ??
                                      'Unknown',
                                  type: 'Completed',
                                  backgroundColor: Colors.green,
                                  onEdit: () {
                                    showChangedTaskStatus(
                                        'Completed',
                                        completedTaskModel.data?[index].sId ??
                                            '', () {
                                      completedNewTasks();
                                    });
                                  },
                                  onDelete: () {
                                    deleteTask(completedTaskModel.data?[index].sId);
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
