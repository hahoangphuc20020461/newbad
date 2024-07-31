import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/UI/User/reset_password.dart';
import 'package:newbad/UI/User/signup.dart';
import 'package:newbad/UI/navigator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key,});

  
  

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color(0xFF1A5D1A);
  bool isclick = false;
  Duration get loginTime => Duration(milliseconds: 2250);
  PageController controller = PageController();


  TextEditingController emailController = TextEditingController();
  TextEditingController verifycodeController =TextEditingController();


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
              
              SizedBox(height: 30),
              ElevatedButton(child: Text('Gửi mã', style: TextStyle(color: Color(0xFFF1C93B)),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C), // Màu nút đăng nhập
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    if (isEmailValid(emailController.text)) {
                       guiMailXacThuc();
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
                                title: Text("Vui lòng nhập đầy đủ Email"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                  } 
                  
                },
              ),
              SizedBox(height: 20),
              
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
  Future<void> guiMailXacThuc() async {
  //final String apiUrl = "http://your-api-url/gui-mail"; // Thay thế với URL của API backend
  try {
    final response = await http.post(
      Uri.parse(guimail),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
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