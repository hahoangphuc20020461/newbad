import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:newbad/Service/config.dart';
import 'package:newbad/UI/User/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  final String title;
  

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  bool isnotValidate = false;


  TextEditingController userNameController = TextEditingController();
  TextEditingController passController =TextEditingController();

  void registerUser() async {
    if (userNameController.text.isNotEmpty && passController.text.isNotEmpty) {
      var regBody = {
        "username" : userNameController.text,
        "password": passController.text
      };
      var response = await http.post(Uri.parse(registration),
      body: jsonEncode(regBody),
      headers: {"Content-Type":"application/json"}
      );
      var jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status']) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
      } else {
        print('loi roi');
      }
    } else {
      setState(() {
        isnotValidate = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              _inputField('Username', userNameController),
              Divider(),
              SizedBox(height: 20),
              _inputField('Password', passController, isPassword: true),
              Divider(),
              SizedBox(height: 20),
              _inputField('Nhập lại Password', passController, isPassword: true),
              Divider(),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Đăng ký', style: TextStyle(color: Color(0xFFF1C93B)),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF388E3C), // Màu nút đăng nhập
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  registerUser();
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Đăng nhập với tư cách',
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
                          text: 'Admin',
                          style: TextStyle(
                            color: Color(0xFF6F4E37), // Màu chữ
                            fontWeight: FontWeight.bold,
                          ),
                        ),)),
              
                
              
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
                    
                  
          //         Padding(padding: EdgeInsets.all(8)),
          //         Text('Đăng ký tài khoản của bạn',
          //         style: TextStyle(
          //           fontFamily: 'Schyler',
          //           fontSize: 17,
          //           color: kbackgroundColor
          //         ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 8,right: 8),
          //           child: Column(
          //             children: [
          //               _inputField('Username', userNameController),
          //               Padding(padding: EdgeInsets.all(8)),
          //               _inputField('Password', passController, isPassword: true),
          //               Padding(padding: EdgeInsets.all(12)),
          //               // _inputField('Nhập lại Password', passController, isPassword: true),
          //               Padding(padding: EdgeInsets.all(12)),
          //               Center(
          //                 child: Container(
          //                                     width: MediaQuery.of(context).size.width/2 -15,
          //                                     child: ElevatedButton.icon(onPressed: (){
          //                                       registerUser();
          //                 //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
          //                                     },
          //                                     style: ButtonStyle(
          //                 backgroundColor: MaterialStatePropertyAll(kbackgroundColor)
          //                                     ),
          //                                     icon: Icon(Icons.login_outlined, color: kbackgroundAppbar,),
          //                                     label: Text('Xong', style: TextStyle(color: kbackgroundAppbar)))),
          //               ),
          //             Padding(padding: EdgeInsets.all(5)),
                      
          //             ],
          //           ),
          //         ),
          //   ],
          // ),
        )
        );
  }
}

Widget _inputField(String hinttext, TextEditingController textEditingController, {isPassword = false}) {
  const Color kbackgroundColor = Color(0xFFf1f1f1);
  const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide.none//BorderSide(color: kbackgroundColor)
  );
  return TextField(
    style: TextStyle(
      color: kbackgroundColor,
    ),
    controller: textEditingController,
    decoration: InputDecoration(
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.black),
      enabledBorder: border,
      focusedBorder: border,
    ),
    obscureText: isPassword,
  );
}