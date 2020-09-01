import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/db_handler.dart';
import 'package:todo/db_provider/task_provider.dart';
import 'package:todo/service/notification.dart';
import './pages/home.dart';

void main() => runApp(ToDo());

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo',
        home: Welcome(),
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WelcomePage(size: size),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  initState() {
    super.initState();
    showNoti();
  }

  void showNoti() async {
    var noti = NotificationService();
    await noti.showToDayTomorrow();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('images/welcome.png'),
          SizedBox(
            height: 40,
          ),
          Text(
            'Reminder Made Simple',
            style: TextStyle(
                fontSize: 22, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 40),
            width: widget.size.width * 0.55,
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris pellentesque erat in blandit luctus.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              width: widget.size.width * 0.55,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(19))),
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )))
        ],
      ),
    );
  }
}
