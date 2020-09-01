import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.2,
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: -130,
              // bottom: 20,
              child: ClipOval(
                child: Container(
                  color: Colors.red,
                  width: 200,
                  height: size.height * 0.1,
                ),
              )),
          Positioned(
            top: 20,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText('Hello Brenda'),
                    buildText('You have no task ')
                  ],
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 17, color: Colors.white),
    );
  }
}
