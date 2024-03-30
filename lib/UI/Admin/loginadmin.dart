
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:newbad/Service/config.dart';
import 'package:newbad/UI/Admin/homepageadmin.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {

  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color(0xFF1A5D1A);

  PageController controller = PageController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passController =TextEditingController();
  late SharedPreferences preferences;

  // void loginAdmin() async{
  //   if (userNameController.text.isNotEmpty && passController.text.isNotEmpty) {
  //     var regBody = {
  //       "username" : userNameController.text,
  //       "password": passController.text
  //     };
  //     var response = await http.post(Uri.parse(loginadmin),
  //     body: jsonEncode(regBody),
  //     headers: {"Content-Type":"application/json"}
  //     );
  //     var jsonResponse = jsonDecode(response.body);
      
  //     if(jsonResponse['status']) {
  //       var myToken = jsonResponse['token'];
  //       preferences.setString('token', myToken);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeAdminPage(token: myToken,)));
  //     } else {
  //       print('sai roi');
  //     }
  //    }
    
  // }
  Future<void> loginAdmin(BuildContext context) async {
    try {
      var regBody = {
        "username": userNameController.text,
        "password": passController.text
      };

      var response = await http.post(
        Uri.parse(loginadmin), // Thay YOUR_LOGIN_ENDPOINT bằng endpoint của bạn
        body: jsonEncode(regBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var myToken = jsonResponse['accessToken'];

        // Kiểm tra xem token có tồn tại không
        if (myToken != null && myToken.isNotEmpty) {
          // Token hợp lệ, chuyển qua màn hình mới
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeAdminPage(token: myToken)),
          );
        } else {
          // Token không hợp lệ hoặc thiếu, hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$myToken'),//Invalid token or missing token
            
          ));
        }
      } else if (response.statusCode == 404) {
        print('Email is not found');
      } else if (response.statusCode == 403) {
        print('Password is incorrect');
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
//  void loginAdmin(BuildContext context) async {
//   if (userNameController.text.isNotEmpty && passController.text.isNotEmpty) {
//     var regBody = {
//       "username": userNameController.text,
//       "password": passController.text
//     };

//     try {
//       var response = await http.post(
//         Uri.parse(loginadmin), // Thay YOUR_API_ENDPOINT bằng endpoint của bạn
//         body: jsonEncode(regBody),
//         headers: {"Content-Type": "application/json"},
//       );

//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(response.body);
//         // Không cần kiểm tra jsonResponse['status'] nữa
//         var myToken = jsonResponse['token'];
//         await preferences.setString('token', myToken);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeAdminPage(token: myToken)),
//         );
//         print('Error message: ${response.body}');
//       } else {
//         print('Login failed with status code: ${response.statusCode}');
//          print('Token is missing from the response');
//         print('Error message: ${response.body}');
//         // Hiển thị thông báo lỗi cho người dùng
//       }
//     } catch (e) {
//       print('An error occurred: $e');
//       // Xử lý ngoại lệ khi không thể gửi request hoặc nhận response
//     }
//   } else {
//     print('Username or password is empty');
//     // Hiển thị thông báo yêu cầu nhập đầy đủ thông tin
//   }
// }
  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
    controller.initialPage;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8E1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30), // Adjust the space as per your design needs
              Text(
                'BadEasy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6F4E37), // Màu chữ phù hợp với ảnh
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
                            image: AssetImage('assets/logo.png'
                            ),
                            )
                        ),
                        margin: EdgeInsets.only(top: 40),
                        
                      ),
              SizedBox(height: 20),
              _inputField('Username Admin', userNameController),
              Divider(),
              SizedBox(height: 20),
              _inputField('Password', passController, isPassword: true),
              Divider(),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('Login', style: TextStyle(color: Color(0xFFF1C93B)),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C), // Màu nút đăng nhập
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  loginAdmin(context);
                  print(userNameController.text);
                  print(passController.text);
                  
                  //loginUser();
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Bạn không có tài khoản ?',
                      style: TextStyle(
                        color: Color(0xFF6F4E37), // Màu chữ
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 2)),
                ],
              ),
              // Social Buttons here
              //SizedBox(height: 20),

                TextButton(onPressed: () {}, child: RichText(text: TextSpan(
                          text: 'Đăng ký',
                          style: TextStyle(
                            color: Color(0xFF6F4E37), // Màu chữ
                            fontWeight: FontWeight.bold,
                          ),
                        ),)),
              TextButton(onPressed: () {}, child: RichText(text: TextSpan(
                          text: 'Quên mật khẩu',
                          style: TextStyle(
                            color: Color(0xFF6F4E37), // Màu chữ
                            fontWeight: FontWeight.bold,
                          ),
                        ),))
            ],
          ),
        ),
      ),
    );
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

