import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/UI/Admin/loginadmin.dart';

class ResetPasswordAdminPage extends StatefulWidget {
  const ResetPasswordAdminPage({super.key});

  @override
  State<ResetPasswordAdminPage> createState() => _ResetPasswordAdminPageState();
}

class _ResetPasswordAdminPageState extends State<ResetPasswordAdminPage> {
   TextEditingController newpassController = TextEditingController();
  TextEditingController verifycodeController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              'BadEasy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6F4E37),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 235,
              height: 153,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/logo.png'),
                  )),
              margin: EdgeInsets.only(top: 40),
            ),
            SizedBox(height: 20),
            _inputField('Email', emailController),
            Divider(),
            SizedBox(height: 20),
            _inputField('New Password', newpassController),
            Divider(),
            SizedBox(height: 20),
            _inputField('Verify Code', verifycodeController, isPassword: true),
            Divider(),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(
                'Quên mật khẩu',
                style: TextStyle(color: Color(0xFFF1C93B)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF388E3C),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    newpassController.text.isNotEmpty &&
                    verifycodeController.text.isNotEmpty) {
                  if (isEmailValid(emailController.text)) {
                    resetPassword();
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: Text("Vui lòng nhập đúng Email"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Đóng"))
                            ],
                          );
                        }));
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text("Vui lòng nhập các thông tin"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Đóng"))
                          ],
                        );
                      }));
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
  bool isEmailValid(String email) {
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  return emailRegExp.hasMatch(email);
}
 
Future<void> resetPassword() async {
 try{
  final response = await http.post(
    Uri.parse(resetpassAdmin),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'emailadmin': emailController.text,
      'verifycodeadmin': verifycodeController.text,
      'password': newpassController.text,
    }),
  );
  if (response.statusCode == 200) {
    showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Đã tạo lại mật khẩu mới"),
                                actions: [TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAdminPage()));
                                  }, child: Text("Đóng"))],
                              );
                            }));
    print('Reset mật khẩu thành công: ${response.body}');
  } else {
    showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Lỗi khi thay đổi mật khẩu"),
                                actions: [TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  }, child: Text("Đóng"))],
                              );
                            }));
    print('Lỗi reset mật khẩu: ${response.statusCode}');
  } 
 } catch (e) {
  print('Error: $e');
 }
  
}
}

Widget _inputField(String hinttext, TextEditingController textEditingController, {isPassword = false}) {
  const Color kbackgroundColor = Color(0xFFf1f1f1);
  const Color kbackgroundAppbar = Color.fromARGB(255, 42, 218, 100);
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide.none//BorderSide(color: Colors.black)
  );
  return TextField(
    style: TextStyle(
      color: Colors.black,
    ),
    controller: textEditingController,
    decoration: InputDecoration(
      //filled: true,
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.black),
      enabledBorder: border,
      focusedBorder: border,
      
    ),
    obscureText: isPassword,
    
  );
}