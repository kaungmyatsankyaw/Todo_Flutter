import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/task_table.dart';

class TaskService {
  Future taskList(tasks) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final template = DateFormat('h:mm a');
    var _dateInfo;

    Map _dbData;
    var _fList = List();

    groupBy(tasks, (key) => key['from_db']).forEach((key, value) {
      List _dbList = List();
      value.asMap().forEach((key, v) {
        var time = template
            .format(DateTime.fromMillisecondsSinceEpoch(v['miliseconds']));

        var dbDate = DateTime.fromMillisecondsSinceEpoch(v['miliseconds']);

        final checkDate = DateTime(dbDate.year, dbDate.month, dbDate.day);
        if (checkDate == today) {
          _dateInfo = 'Today';
        } else if (checkDate == tomorrow) {
          _dateInfo = 'Tomorrow';
        } else if (checkDate == yesterday) {
          _dateInfo = 'YesterDay';
        } else {
          _dateInfo = DateFormat('y-MM-d')
              .format(DateTime.fromMillisecondsSinceEpoch(v['miliseconds']));
        }

        Map _daTe = {
          'taskId': v['task_id'],
          'taskName': v['task_name'],
          'categoryName': v['category_name'],
          'color': v['color'],
          'time': time,
          'status': v['$TASK_FIELD_STATUS']
        };

        _dbList.add(_daTe);
      });

      _dbData = {'date': _dateInfo, 'data': _dbList};

      if (_dateInfo == 'Today') {
        _fList.insert(0, _dbData);
      }  else {
        _fList.add(_dbData);
      }
    });

    return _fList;
  }
}
