import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';


class LaunchScreen extends StatefulWidget {

  LaunchScreen();
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              WebViewExample(),
        ),
      );
      //  widget._appState.route = route;
    });
  }
bool isTablet=false;
  @override
  Widget build(BuildContext context) {

    isTablet=MediaQuery.of(context).size.width>600;
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/images/logoEnglishLaunch.png',height: 100,width: 180,)),
              Text('Reliable & Fast',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'pop',
                    fontWeight: FontWeight.w600,
                    fontSize: 12
                ),) ,
              //logoArabicLaunch
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset('assets/images/launchVector.png',fit: BoxFit.fill,))
        ],

      ),
    );
  }
}
