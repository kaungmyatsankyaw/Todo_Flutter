import 'package:flutter/material.dart';

class NoTask extends StatelessWidget {
  const NoTask({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/no_task.png'),
              SizedBox(height: 30),
              Text(
                'No Tasks',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'You have no task to do',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      );
  }
}

