import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/db_handler.dart';
import 'package:todo/db_provider/task_provider.dart';
import 'package:todo/pages/dashboard.dart';
import 'package:todo/pages/task_list.dart';
import 'package:todo/widget/appbar.dart';
import 'package:todo/widget/customFloating.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pages = [
    {'page': TaskList()},
    {'page': Dashbaord()}
  ];

  int _currentIndex = 0;
  int _toDayCount = 0;
  var dbHandler = DataBaseHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TaskProvider().todayCount();
  }

  getTodayCount() async {
    var result = await dbHandler.selectCurrentDateTaskCount();
    _toDayCount = result[0]['taskCount'];
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: CustomAppBar(size: size),
        body: pages[_currentIndex]['page'],
        bottomNavigationBar: BottomAppBar(
          elevation: 4.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildInkWell(Icons.home, 'Home', 0, size.width * 0.3),
                buildInkWell(Icons.dashboard, 'Task', 1, size.width * 0.3)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: customFloating(size: size));
  }

  InkWell buildInkWell(IconData icon, String text, int index, var width) {
    return InkWell(
      onTap: () {
        _currentIndex = index;
        setState(() {});
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.blueGrey,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.blueGrey),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final Size preferredSize;
  CustomAppBar({
    Key key,
    this.size,
  })  : preferredSize = Size.fromHeight(150.0),
        super(key: key);

  final Size size;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  var dbHandler = DataBaseHandler();

  getTodayCount(context) async {
    var taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.setToDayTaskCount = await TaskProvider().todayCount();
    // print('to');
  }

  @override
  Widget build(BuildContext context) {
    getTodayCount(context);
    return AppBar(
      backgroundColor: Colors.black,
      toolbarHeight: widget.size.height * 0.1,
      title: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Brenda !'),
                Consumer<TaskProvider>(
                    builder: (context, task, w) =>
                        Text('${task.toDayTaskCount.toString()}'))
              ],
            ),
            CircleAvatar(
              backgroundImage: AssetImage('images/avatar.png'),
            )
          ],
        ),
      ),
      // bottom: PreferredSize(
      //       child: Container(
      //         margin: EdgeInsets.all(10),
      //         width: size.width,
      //         height: 80,
      //         color: Colors.black,
      //         child: Center(child: Container(
      //           color: Colors.red,
      //           width: size.width * 0.92,
      //           height: 200,
      //         )),
      //       ),
      //       preferredSize: Size.fromHeight(size.height * 0.1)
      //       ),
    );
  }
}
