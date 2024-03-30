import 'package:flutter/material.dart';
import 'package:newbad/UI/User/login.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //final token;
  const MyApp({super.key,});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(title: '',),//(JwtDecoder.isExpired(token)==false) ? HomePage(token: token, ): LoginPage(title: '')//
    );
  }
}