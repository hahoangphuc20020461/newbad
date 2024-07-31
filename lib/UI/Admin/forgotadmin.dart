import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/UI/Admin/resetpasswordadmin.dart';

class ForgotPasswordAdminPage extends StatefulWidget {
  const ForgotPasswordAdminPage({super.key});

  @override
  State<ForgotPasswordAdminPage> createState() =>
      _ForgotPasswordAdminPageState();
}

class _ForgotPasswordAdminPageState extends State<ForgotPasswordAdminPage> {
  TextEditingController emailController = TextEditingController();
  //TextEditingController verifycodeController =TextEditingController();
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
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(
                'Gửi mã',
                style: TextStyle(color: Color(0xFFF1C93B)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF388E3C),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  if (isEmailValid(emailController.text)) {
                    guiMailXacThuc();
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
                          title: Text("Vui lòng nhập đầy đủ Email"),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  Future<void> guiMailXacThuc() async {
  //final String apiUrl = "http://your-api-url/gui-mail"; // Thay thế với URL của API backend
  try {
    final response = await http.post(
      Uri.parse(guimailAdmin),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailadmin': emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordAdminPage()));
      // Yêu cầu gửi mail thành công, xử lý kết quả tại đây
      print('Email verification sent: ${response.body}');
    } else {
      // Xử lý các lỗi từ phản hồi
      showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Email chưa được đăng kí hoặc sai địa chỉ email"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
      print('Failed to send email verification: ${response.statusCode}');
    }
  } catch (e) {
    // Xử lý lỗi khi không gửi được yêu cầu
    print('Error sending email verification request: $e');
  }
}
bool isEmailValid(String email) {
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  return emailRegExp.hasMatch(email);
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