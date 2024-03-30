import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:newbad/UI/start.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key, required this.title});

  final String title;


  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 250, 250, 250),
      body: EasySplashScreen(
        logo: Image.asset("assets/logofood-removebg-preview.png",),
        logoWidth: 200,
        // child: ,
        backgroundColor: Color.fromARGB(173, 202, 102, 19),
        showLoader: false,
        durationInSeconds: 2,
        //navigator: LoginPage(title: ''),
        navigator: StartPage(),
       )
    );
  }
}