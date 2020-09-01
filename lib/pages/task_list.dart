import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/db_handler.dart';
import 'package:todo/db_provider/task_provider.dart';
import 'package:todo/widget/task.dart';
import 'package:todo/widget/totask.dart';


// ignore: must_be_immutable
class TaskList extends StatelessWidget {
  int _selectedIndex = 0;
  var dbHandler = DataBaseHandler();

  getTaskList(context, TaskProvider taskProvider) async {
    taskProvider.setTaskList = await dbHandler.selectAllTasks();
  
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    getTaskList(context, taskProvider);
    return Consumer<TaskProvider>(
        builder: (context, task, w) => task.taskLits.length == 0
            ? NoTask()
            : ListView.builder(
                itemCount: task.taskLits.length,
                itemBuilder: (_, int index) => ExpansionTile(
                      initiallyExpanded: true,
                      trailing: Text(''),
                      title: Text(task.taskLits[index]['date']),
                      children: task.taskLits[index]['data']
                          .map<Widget>((d) {
                            var dismissible = Dismissible(
                                onDismissed: (_) async {
                                  dbHandler.deleteTask(d['taskId']);
                                  task.taskLits[index]['data'].removeWhere(
                                      (t) => t['taskId'] == d['taskId']);
                                  getTaskList(context, taskProvider);
                                  taskProvider.setToDayTaskCount =
                                      await TaskProvider().todayCount();
                                },
                                background: dismissBackground(),
                                key: Key(d['taskId'].toString()),
                                child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Task(i: d, index: index, context: context, selectedIndex: _selectedIndex, dbHandler: dbHandler,taskProvider:taskProvider)),
                              );
                            return dismissible;
                          })
                          .toList(),
                    )));
  }

  Widget dismissBackground() {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 30,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

