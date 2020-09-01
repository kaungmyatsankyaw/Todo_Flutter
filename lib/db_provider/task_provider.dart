import 'package:flutter/foundation.dart';
import 'package:todo/constants/task_table.dart';
import '../database/db_handler.dart';

class TaskProvider extends ChangeNotifier {
  int _toDayTaskCount = 0;
  List _taskList = List();

  get toDayTaskCount => _toDayTaskCount;

  get taskLits => _taskList;

  set setTaskList(dynamic tasks) {
    _taskList = tasks;
    notifyListeners();
  }

  set setToDayTaskCount(int count) {
    _toDayTaskCount = count;
    notifyListeners();
  }

  Future<int> todayCount() async {
    var db = await DataBaseHandler().database;
    List<Map> result = await db.rawQuery(
        "select count(*) as taskCount,strftime('%Y-%m-%d', $TASK_TABLE.$TASK_FIELD_DATETIME / 1000, 'unixepoch','localtime') as from_db from $TASK_TABLE where from_db = date('now') group by from_db ");
    if (result.length != 0) {
      setToDayTaskCount = result[0]['taskCount'];
      return result[0]['taskCount'];
    } else {
      return 0;
    }
  }
}
