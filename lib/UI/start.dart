import 'package:flutter/material.dart';
import 'package:newbad/UI/Admin/loginadmin.dart';
import 'package:newbad/UI/User/login.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color(0xFF1A5D1A);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text(
            'BadEasy',
            style: TextStyle(
              color: Colors.black,
              fontSize: 64,
              fontFamily: 'flutterfonts',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: 103,
            height: 106,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 50,),
          Text(
            'Bạn là ...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              //fontFamily: 'Ibarra Real Nova',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          SizedBox(height: 50,),
          Container(
            width: 249,
            height: 45,
            child: ElevatedButton.icon(onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
            } ,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(kbackgroundAppbar)
            ), icon: Icon(Icons.person,
            color: Colors.amberAccent,
            ),
             label: Text('Người thuê',
            style: TextStyle(
                    color: Color(0xFFF1C93B),
                    fontSize: 20,
                    //fontFamily: 'Ibarra Real Nova',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
            ),)
          ),
          SizedBox(height: 20,),
          Container(
            width: 249,
            height: 45,
            child: ElevatedButton.icon(onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAdminPage()));
            } ,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(kbackgroundAppbar)
            ), icon: Icon(Icons.business,
            color: Colors.amberAccent
            ),
            label: Text('Chủ sân',
            style: TextStyle(
                    color: Color(0xFFF1C93B),
                    fontSize: 20,
                    //fontFamily: 'Ibarra Real Nova',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
            ),)
          ),
          ],
        ),
      ),
    );
  }
}