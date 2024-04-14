import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:newbad/UI/Admin/loginadmin.dart';
import 'package:newbad/UI/User/login.dart';
import 'package:newbad/UI/start.dart';
import 'package:newbad/sv.dart';
import 'package:newbad/test.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51P0KVJP8OZat8l3pcW84SuqKo8dZnk46UkYYk2HFfceH4hO73VUCKtneNQ8ffWC24YqI5smCi7uE5yPfNHJ9d57400kWEbPlT1";
  //NotificationService().initNotification();
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
      home: StartPage(),//(JwtDecoder.isExpired(token)==false) ? HomePage(token: token, ): LoginPage(title: '')//
    );
  }
}