import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/UI/User/login.dart';
import 'package:newbad/UI/User/signup.dart';
import 'package:newbad/UI/navigator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key,});

  
  

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color(0xFF1A5D1A);
  bool isclick = false;
  Duration get loginTime => Duration(milliseconds: 2250);
  PageController controller = PageController();


  TextEditingController newpassController = TextEditingController();
  TextEditingController verifycodeController =TextEditingController();
  TextEditingController emailController =TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        //backgroundColor: Color(0xFFFFF8E1),
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
              _inputField('Email', emailController),
              Divider(),
              SizedBox(height: 20),
              _inputField('New Password', newpassController),
              Divider(),
              SizedBox(height: 20),
              _inputField('Verify Code', verifycodeController, isPassword: true),
              Divider(),
              SizedBox(height: 30),
              ElevatedButton(child: Text('Quên mật khẩu', style: TextStyle(color: Color(0xFFF1C93B)),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C), // Màu nút đăng nhập
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (emailController.text.isNotEmpty && newpassController.text.isNotEmpty && verifycodeController.text.isNotEmpty) {
                    if (isEmailValid(emailController.text)) {
                       resetPassword();
                    } else {
                      showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Vui lòng nhập đúng Email"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                  } 
                   
                  } else {
                    showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Vui lòng nhập các thông tin"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                  } 
                  
                  
                },
              ),
             
            ],
          ),
        ),
          // child: Column(
          //   children: [
          //           Center(
          //             child: Container(
          //               width: 235,
          //               height: 153,
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                   fit: BoxFit.cover,
          //                   image: AssetImage('assets/logo.png'
          //                   ),
          //                   )
          //               ),
          //               margin: EdgeInsets.only(top: 90),
                        
          //             ),
          //           ),
          //           Padding(padding: EdgeInsets.all(8)),
                  
          //         Padding(padding: EdgeInsets.all(8)),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Hãy đăng nhập để sử dụng nhé',
          //             style: TextStyle(
          //               fontFamily: 'Schyler',
          //               fontSize: 17,
          //               color: Colors.black//kbackgroundColor
          //             ),
          //             ),
          //             Padding(padding: EdgeInsets.all(3)),
          //             
                      
          //           ],
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 8,right: 8),
          //           child: Column(
          //             children: [
          //               Text("Đăng nhập",
          //               style: TextStyle(
          //                 fontFamily: 'Schyler',
          //                 fontSize: 17,
          //                 color: Colors.black//kbackgroundAppbar
          //               ),),
          //               Padding(padding: EdgeInsets.all(12)),
          //               _inputField('Username', userNameController),
          //               Padding(padding: EdgeInsets.all(8)),
          //               _inputField('Password', passController, isPassword: true),
          //               Padding(padding: EdgeInsets.all(12)),
          //               Row(
          //                 children: [
          //                   Container(
          //             width: MediaQuery.of(context).size.width/2 -15,
          //             child: ElevatedButton.icon(onPressed: (){
          //               loginUser();
          //               //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(title: '')), (route) => false);
                        
          //             },
          //             style: ButtonStyle(
          //                   backgroundColor: MaterialStatePropertyAll(kbackgroundColor)
          //             ),
          //             icon: Icon(Icons.login_outlined, color: kbackgroundAppbar,),
          //             label: Text('Đăng nhập', style: TextStyle(color: Colors.black)))),
          //             Padding(padding: EdgeInsets.all(5)),
          //             Container(
          //             width: MediaQuery.of(context).size.width/2 -15,
          //             child: ElevatedButton.icon(onPressed: (){
          //               print(userNameController.text);
          //               print(passController.text);
          //                   //Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage(title: '',)));
          //             },
          //             style: ButtonStyle(
          //                   backgroundColor: MaterialStatePropertyAll(kbackgroundColor)
          //             ),
          //             icon: Icon(Icons.add_box_outlined, color: kbackgroundAppbar,),
          //             label: Text('Đăng Ký', style: TextStyle(color: Colors.black))))
          //                 ],
          //               ),
          //             Padding(padding: EdgeInsets.all(8)),
          //             Text('Hoặc',
          //             style: TextStyle(
          //               fontFamily: 'Schyler',
          //               fontSize: 17,
          //               color: Colors.black
          //             ),
          //             )
          //             ],
          //           ),
          //         ),
          //     //Padding(padding: EdgeInsets.all(12)),
              
          //     Padding(padding: EdgeInsets.all(8)),
          //     TextButton(onPressed: (){}, child: Text('Bạn không thể đăng nhập?',
          //     style: TextStyle(
          //       fontFamily: 'Schyler',
          //               fontSize: 17,
          //               color: Colors.black),
          //     )),
          //   ],
          // ),
        )
        );
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
    Uri.parse(resetpass),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': emailController.text,
      'verifycode': verifycodeController.text,
      'password': newpassController.text,
    }),
  );
  if (response.statusCode == 200) {
    showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Đã tạo lại mật khẩu mới"),
                                actions: [TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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

// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final bool isPassword;

//   CustomTextField({required this.hintText, this.isPassword = false});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: Color(0xFF6F4E37)), // Màu chữ gợi ý
//         filled: true,
//         fillColor: Color(0xFFFFF8E1), // Màu nền của TextField
//         border: UnderlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       ),
//       style: TextStyle(color: Color(0xFF6F4E37)), // Màu chữ nhập
//       cursorColor: Color(0xFF6F4E37), // Màu con trỏ
//     );
//   }
// }

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