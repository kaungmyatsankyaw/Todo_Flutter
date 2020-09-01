import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/constants/task_table.dart';
import 'package:todo/models/task.dart';
import 'package:todo/service/task.dart';
import '../constants/category_table.dart';

import '../models/category.dart';

class DataBaseHandler {
  String DBNAME = 'todo';

  static Database _database;
  static DataBaseHandler dataBaseHandler;

  DataBaseHandler._createInstance();

  factory DataBaseHandler() {
    if (dataBaseHandler == null) {
      dataBaseHandler = DataBaseHandler._createInstance();
    }
    return dataBaseHandler;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<String> getDbPath() async {
    return await getDatabasesPath();
  }

  Future<Database> initDatabase() async {
    String dir = await getDbPath();
    String path = join(dir, DBNAME);
    return openDatabase(path, version: 1, onCreate: createDB);
  }

  void createDB(Database db, int version) {
    String categoryTableQuery =
        'CREATE TABLE $CATEGORY_TABLE_NAME($CATEGORY_FIElD_ID INTEGER PRIMARY KEY AUTOINCREMENT,$CATEGORY_FIELD_NAME TEXT,$CATEGORY_FIElD_COLOR TEXT,$CATEGORY_FIELD_IMAGE TEXT);';

    String categoryInsertQuery =
        "insert into $CATEGORY_TABLE_NAME($CATEGORY_FIELD_NAME,$CATEGORY_FIElD_COLOR,$CATEGORY_FIELD_IMAGE) values ('Personal', '#FFEE9B', 'user'),('Work', '#B5FF9B', 'work'),('Meeting', '#FF9BCD', 'business'),('Shopping', '#FFD09B', 'shopping'),('Party', '#9BFFF8', 'party'),('Study', '#F59BFF', 'study')";

    String taskTableQuery =
        "CREATE TABLE $TASK_TABLE($TASK_FIELD_ID INTEGER PRIMARY KEY AUTOINCREMENT,$TASK_FIELD_NAME TEXT,$TASK_FIELD_CATEGORY_ID INTEGER,$TASK_FIELD_DATETIME INTEGER,$TASK_FIELD_STATUS INTEGER default 0)";

    db.execute(categoryTableQuery);
    db.execute(categoryInsertQuery);
    db.execute(taskTableQuery);
  }

  Future<List<Category>> selectAllCategories() async {
    var db = await database;
    var result = await db.query(CATEGORY_TABLE_NAME);

    List<Category> categories = result.map((e) => Category.fromMap(e)).toList();
    return categories;
  }

  Future<void> insertTaskData(Task task) async {
    var db = await database;
    db.insert(TASK_TABLE, task.toMap());
  }

  Future selectAllTasks() async {
    var db = await database;
    List<Map> result = await db.rawQuery(
        "select $TASK_TABLE.$TASK_FIELD_ID as task_id,$TASK_TABLE.$TASK_FIELD_NAME as task_name,$TASK_FIELD_CATEGORY_ID,$CATEGORY_TABLE_NAME.$CATEGORY_FIELD_NAME as category_name,$CATEGORY_FIElD_COLOR,strftime('%Y-%m-%d', $TASK_TABLE.$TASK_FIELD_DATETIME / 1000, 'unixepoch','localtime') as from_db,$TASK_TABLE.$TASK_FIELD_DATETIME as miliseconds,$TASK_TABLE.$TASK_FIELD_STATUS from $TASK_TABLE join $CATEGORY_TABLE_NAME on $TASK_TABLE.$TASK_FIELD_CATEGORY_ID=$CATEGORY_TABLE_NAME.$CATEGORY_FIElD_ID order by from_db desc ");

    return TaskService().taskList(result);
  }

  Future<List<Map>> selectCurrentDateTask() async {
    var db = await database;
    List<Map> result = await db.rawQuery(
        "select $TASK_TABLE.$TASK_FIELD_NAME as taskName,$CATEGORY_TABLE_NAME.$CATEGORY_FIELD_NAME as categoryName,strftime('%Y-%m-%d', $TASK_TABLE.$TASK_FIELD_DATETIME / 1000, 'unixepoch','localtime') as from_db,$TASK_TABLE.$TASK_FIELD_DATETIME as dateTime from $TASK_TABLE join $CATEGORY_TABLE_NAME on $TASK_TABLE.$TASK_FIELD_CATEGORY_ID= $CATEGORY_TABLE_NAME.$CATEGORY_FIElD_ID where from_db = date('now') or from_db=date('now','+1 day','localtime') order by from_db asc;");
    return result;
  }

  Future<List<Map>> selectCurrentDateTaskCount() async {
    var db = await database;
    List<Map> result = await db.rawQuery(
        "select count(*) as taskCount,strftime('%Y-%m-%d', $TASK_TABLE.$TASK_FIELD_DATETIME / 1000, 'unixepoch','localtime') as from_db from $TASK_TABLE where from_db = date('now') group by from_db ");
    return result;
  }

  updateTask(int taskId, int status) async {
    int _updateStatus = status == 1 ? 0 : 1;
    var db = await database;
    Map<String, dynamic> row = {TASK_FIELD_STATUS: _updateStatus};
    db.update(TASK_TABLE, row, where: 'id=?', whereArgs: [taskId]);
  }

  Future deleteTask(int taskId) async {
    var db = await database;
    var result =
        db.rawQuery('delete from $TASK_TABLE where $TASK_FIELD_ID=?', [taskId]);
  }

  Future<List<Map>> dashBoardData() async {
    var db = await database;
    List<Map> result = await db.rawQuery(
        'select $CATEGORY_TABLE_NAME.$CATEGORY_FIElD_ID as category_id,$CATEGORY_TABLE_NAME.$CATEGORY_FIELD_NAME as category_name,$CATEGORY_TABLE_NAME.$CATEGORY_FIELD_IMAGE as image,$CATEGORY_TABLE_NAME.$CATEGORY_FIElD_COLOR as color,count($TASK_TABLE.$TASK_FIELD_ID) as task_count from $CATEGORY_TABLE_NAME left join $TASK_TABLE on $CATEGORY_TABLE_NAME.$CATEGORY_FIElD_ID=$TASK_TABLE.$TASK_FIELD_CATEGORY_ID group by $CATEGORY_TABLE_NAME.$CATEGORY_FIElD_ID');
    return result;
  }
}
