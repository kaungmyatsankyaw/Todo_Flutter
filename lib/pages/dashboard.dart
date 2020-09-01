import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/database/db_handler.dart';

class Dashbaord extends StatefulWidget {
  @override
  _DashbaordState createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  @override
  Widget build(BuildContext context) {
    var dbHandler = DataBaseHandler();
    

    return FutureBuilder(
        future: dbHandler.dashBoardData(),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.done
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Projects'),
                        Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                children: snapshot.data.map<Widget>((e) {
                                  var image = e['image'];
                                  return Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Hexcolor(e['color']),
                                          child:
                                              Image.asset('images/$image.png'),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(e['category_name']),
                                        SizedBox(height: 10,),
                                        Text('${e['task_count']} count')
                                      ],
                                    ),
                                  );
                                }).toList())),
                      ])));
        });
  }
}
