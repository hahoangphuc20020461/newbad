import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/UI/User/signup.dart';
import 'package:newbad/UI/navigator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color(0xFF1A5D1A);
  bool isclick = false;
  Duration get loginTime => Duration(milliseconds: 2250);
  PageController controller = PageController();


  TextEditingController userNameController = TextEditingController();
  TextEditingController passController =TextEditingController();

  late double _progress;
  late SharedPreferences preferences;


  // void loginUser() async{
  //   if (userNameController.text.isNotEmpty && passController.text.isNotEmpty) {
  //     var regBody = {
  //       "username" : userNameController.text,
  //       "password": passController.text
  //     };
  //     var response = await http.post(Uri.parse(login),
  //     body: jsonEncode(regBody),
  //     headers: {"Content-Type":"application/json"}
  //     );
  //     var jsonResponse = jsonDecode(response.body);
  //     if(jsonResponse['status']) {
  //       var myToken = jsonResponse['token'];
  //       preferences.setString('token', myToken);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => NavigatePage(token: myToken,)));
  //     } else {
  //       print('sai roi');
  //     }
  //   }
  // }
  Future<void> loginUser(BuildContext context) async {
    try {
      var regBody = {
        "username": userNameController.text,
        "password": passController.text
      };

      var response = await http.post(
        Uri.parse(login), // Thay YOUR_LOGIN_ENDPOINT bằng endpoint của bạn
        body: jsonEncode(regBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var myToken = jsonResponse['accessToken'];
        
        
        await LoginService.saveUserId(myToken);

        // Kiểm tra xem token có tồn tại không
        if (myToken != null && myToken.isNotEmpty) {
          //var userId = jsonResponse['_id'];
          // Token hợp lệ, chuyển qua màn hình mới
          //await LoginService.saveUserId(userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigatePage(token: myToken)),
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
  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
  }
  Future<void> saveUserId(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
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
              _inputField('Username', userNameController),
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
                  //loginUser();
                  loginUser(context);
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

                TextButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignupPage(title: '')));
                }, child: RichText(text: TextSpan(
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