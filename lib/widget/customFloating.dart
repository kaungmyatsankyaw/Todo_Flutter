import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/db_handler.dart';
import 'package:todo/db_provider/task_provider.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';
import 'package:todo/pages/dashboard.dart';
import 'package:todo/service/notification.dart';

class customFloating extends StatefulWidget {
  Size size;
  customFloating({@required this.size});

  @override
  _customFloatingState createState() => _customFloatingState();
}

class _customFloatingState extends State<customFloating> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController _taskName = TextEditingController();

  // String _selectDate;
  DateTime selectedDate = DateTime.now();

  String formattedDate = DateFormat.yMEd().add_jms().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await showModalBottomSheet(
            // backgroundColor: Colors.red,
            isScrollControlled: true,
            context: context,
            builder: (context) => bottomContainer(
                widget: widget,
                formKey: _formKey,
                taskName: _taskName,
                selectedDate: selectedDate,
                formattedDate: formattedDate));
      },
      tooltip: 'Increment',
      child: Icon(
        Icons.add,
        size: 40,
      ),
      elevation: 2.0,
    );
  }
}

class bottomContainer extends StatefulWidget {
  bottomContainer(
      {Key key,
      @required this.widget,
      @required GlobalKey<FormState> formKey,
      @required TextEditingController taskName,
      @required this.selectedDate,
      @required this.formattedDate})
      : _formKey = formKey,
        _taskName = taskName,
        super(key: key);

  final customFloating widget;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _taskName;
  var selectedDate;
  var formattedDate;
  var _timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  _bottomContainerState createState() => _bottomContainerState();
}

class _bottomContainerState extends State<bottomContainer> {
  var dbHandler = DataBaseHandler();

  List data;
  List<Category> categoryList = List();
  List _categories;
  int _selectedCategory = 1;

  int index;
  var _category;
  // ignore: missing_return
  Future<List<Category>> fetchData() async {
    _categories = await dbHandler.selectAllCategories();
    _categories.forEach((element) {
      categoryList.add(element);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Container(
        height: widget.widget.size.height * 0.8,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(Icons.error),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add A Task',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildForm(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 30,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length,
                          itemBuilder: (context, int index) {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                _category = categoryList.firstWhere(
                                    (c) => c.id == categoryList[index].id);

                                _category.id = categoryList[index].id;
                                _category.name = categoryList[index].name;
                                _category.color = categoryList[index].color;
                                _category.type = 'squre';

                                _selectedCategory = _category.id;

                                var _unSelectcategory = categoryList
                                    .where(
                                        (c) => c.id != categoryList[index].id)
                                    .toList();

                                _unSelectcategory.map((e) {
                                  e.setType = null;
                                }).toList();

                                setState(() {});
                              },
                              child: categoryList[index].type == null
                                  ? Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Hexcolor(
                                              categoryList[index].color),
                                        ),
                                        Text(categoryList[index].name)
                                      ],
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.all(8),
                                      height: 30,
                                      color:
                                          Hexcolor(categoryList[index].color),
                                      child: Row(
                                        children: [
                                          Text(categoryList[index].name)
                                        ],
                                      ),
                                    ),
                            ));
                            // }))
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    buildFlatButton(context),
                    Text("${widget.formattedDate}"),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: FlatButton(
                                  onPressed: () async {
                                    if (widget._formKey.currentState
                                        .validate()) {
                                      if (widget._taskName.text != null) {
                                        await dbHandler
                                            .insertTaskData(Task.withOutId(
                                          widget._taskName.text,
                                          _selectedCategory,
                                          widget._timeStamp,
                                        ));

                                        taskProvider.setToDayTaskCount =
                                            await TaskProvider().todayCount();
                                        taskProvider.setTaskList =
                                            await dbHandler.selectAllTasks();

                                        await NotificationService().setNoti(
                                            widget._taskName.text,
                                            widget._timeStamp,
                                            _category);
                                        widget._taskName.text = '';

                                        Navigator.pop(context);
                                        return;
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Add Task',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
        key: widget._formKey,
        child: Container(
          child: TextFormField(
            controller: widget._taskName,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter Task Name';
              }
              return null;
            },
            onFieldSubmitted: (value) => widget._taskName.text = value,
            decoration: InputDecoration(labelText: 'Enter Task Name'),
          ),
        ));
  }

  FlatButton buildFlatButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            maxTime: DateTime(2200, 6, 7),
            onConfirm: (date) {
              widget.formattedDate = DateFormat.yMEd().add_jms().format(date);
              widget._timeStamp = date.millisecondsSinceEpoch;
              setState(() {});
            },
          );
        },
        child: Text(
          'Choose Date',
          style: TextStyle(color: Colors.blue),
        ));
  }
}
