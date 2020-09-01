import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/db_provider/task_provider.dart';

// ignore: must_be_immutable
class Task extends StatelessWidget {
  Task(
      {Key key,
      @required this.i,
      @required this.index,
      @required this.context,
      @required selectedIndex,
      @required this.dbHandler,
      @required this.taskProvider})
      : _selectedIndex = selectedIndex,
        super(key: key);

  var i;
  final int index;
  final BuildContext context;
  var _selectedIndex;
  var dbHandler;
  var taskProvider;

   getTaskList(context, TaskProvider taskProvider) async {
    taskProvider.setTaskList = await dbHandler.selectAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(left: 12.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 8.5,
              offset: Offset(4, 6.5),
              spreadRadius: 0.2)
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Hexcolor(i['color']),
      ),
      height: MediaQuery.of(context).size.height * 0.095,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Radio(
                  value: i['taskId'],
                  groupValue: i['status'] == 1 ? 1 : 0,
                  onChanged: (value) {
                    // _selectedIndex = value;
                    dbHandler.updateTask(value, i['status']);
                    // setState(() {});
                  }),

              Text(
                i['time'].toString(),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                // width: MediaQuery.of(context).size.width * 0.5,
                child: Expanded(
                  child: Text(
                    i['taskName'].toString(),
                    style: TextStyle(
                        decoration: i['status'] == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ),

              Expanded(child: Icon(Icons.notifications)),
              // ),
            ],
          )),
    );
  }
}
