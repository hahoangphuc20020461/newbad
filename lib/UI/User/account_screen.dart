import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:newbad/Model/user.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/Service/userInfoSv.dart';
import 'package:newbad/UI/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http ;
class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});

  final String title;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  
  TextEditingController peoplenameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
    String? userid;
    String? userId;
     Future<User?>? fetchUserInfo;
  @override
  void initState() {
    // TODO: implement initState
    _loadUserId();
    //fetchUserInfo = GetUserInfo().fetchUserInfo(userid!);
    print(userid);
    super.initState();
  }
  @override
void dispose() {
  super.dispose();
}


  Future<void> logoutAdmin(BuildContext context) async {
  // Xoá token từ storage
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');

  // Chuyển người dùng đến trang đăng nhập
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => StartPage()), // Thay YourLoginPage() bằng trang đăng nhập của bạn
    (Route<dynamic> route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              //alignment: Alignment.bottomCenter,
              children: [
                // Background for the top part of the profile
                Container(
                  height: 250,
                  color: Colors.green,
                ),
                // Profile image
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 205, 0, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset('assets/avatar.jpg'),
                    ),
                  ),
                ),
                // Positioned widget can be used for icons on the top right
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left:24),
              child: Row(
                children: [
                  FutureBuilder(future: fetchUserInfo, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Lỗi: ${snapshot.error}');
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      return Text(
                    user.peoplename,
                    
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
    } else {
      return Text(
                    "Hãy cập nhật tên của bạn",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
    }
           }),
                  
                  
                ],
              ),
            ),
            SizedBox(height: 12,),
            Divider(thickness: 2,),
            Padding(
              padding: const EdgeInsets.only(left:22),
              child: Row(
                children: [
                  Text("Thông tin cá nhân",
                  style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),),
                          SizedBox(width:5,),
                          IconButton(
                            onPressed: () {
                              showDialog (context: context, builder: ((context) {
          return SingleChildScrollView(
            child: AlertDialog(
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.green,
              //contentTextStyle: ,
              title: Text('Thay đổi thông tin cá nhân của bạn'),
              content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                _inputField("Tên người dùng", peoplenameController),
                      SizedBox(height: 10),
                _inputField("Số điện thoại người dùng", phonenumberController),
                SizedBox(height: 10),
                _inputField("Email người dùng", emailController),
              ],
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                          child: Text('Đóng',
                          style: TextStyle(
                            color: Colors.green
                          ),
                          ),
                          onPressed: () {
                            //print(item[0]);

                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        SizedBox(width: 130,),
                    TextButton(
                          child: Text('Thêm',
                          style: TextStyle(
                            color: Colors.green
                          ),),
                          onPressed: () {
                            if (emailController.text.isNotEmpty && phonenumberController.text.isNotEmpty && peoplenameController.text.isNotEmpty) {
                    if (isEmailValid(emailController.text)) {
                       updateUserInfo(userid!);
                       _loadUserId();
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
                                title: Text("Vui lòng nhập đủ các thông tin"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                  } 
                            //Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                  ],
                ),
              ],
            ),
          );
        }),
        
        );
                            },
                            icon: Icon(Icons.edit, color: Colors.green),
                            
                          ),
                ],
              ),
            ),
           FutureBuilder(future: fetchUserInfo, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Lỗi: ${snapshot.error}');
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      return ListTile(
              leading: Icon(Icons.phone_android),
              title: Text(user.phonenumber),
            );
    } else {
      return ListTile(
              leading: Icon(Icons.phone_android),
              title: Text(" "),
            );
    }
           }),
            
            FutureBuilder(future: fetchUserInfo, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Lỗi: ${snapshot.error}');
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      return ListTile(
              leading: Icon(Icons.people_alt),
              title: Text(user.peoplename),
            );
    } else {
      return ListTile(
              leading: Icon(Icons.people_alt),
              title: Text(" "),
            );
    }
           }),
            FutureBuilder(future: fetchUserInfo, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Lỗi: ${snapshot.error}');
    } else if (snapshot.hasData) {
      final user = snapshot.data!;
      return ListTile(
              leading: Icon(Icons.email_rounded),
              title: Text(user.email),
            );
    } else {
      return ListTile(
              leading: Icon(Icons.email_rounded),
              title: Text(" "),
            );
    }
           }),
            Divider(
              thickness: 2,
            ),
            
            ListTile(
              onTap: () {
                logoutAdmin(context);
              },
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              trailing: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
    Future<void> updateUserInfo(String id) async {
  //final String apiUrl = "http://your-api-url/gui-mail"; // Thay thế với URL của API backend
  try {
    final response = await http.post(
      Uri.parse(updateInfUser+id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'peoplename': peoplenameController.text,
        'phonenumber': phonenumberController.text,
        "email": emailController.text
      }),
    );

    if (response.statusCode == 200) {
      showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Thay đổi thông tin thành công"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
      // Yêu cầu gửi mail thành công, xử lý kết quả tại đây
      print('Email verification sent: ${response.body}');
    } else {
      // Xử lý các lỗi từ phản hồi
      showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Lỗi"),
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
Future<void> _loadUserId() async {
    // Gọi SharedPreferencesService để lấy userId
    userId = await LoginService.getUserId();
    // Để cập nhật UI sau khi nhận userId, gọi setState
    if (userId != null) {
    // Nếu userId không phải là null, giờ chúng ta có thể decode nó
    var jwtDecodeToken = JwtDecoder.decode(userId!);
      userid = jwtDecodeToken['_id'];
      if(mounted) {
        setState(() {
      fetchUserInfo = GetUserInfo().fetchUserInfo(userid!);
     
    });
      }
       print("User ID retrieved: $userid");
  } else {
    // userId là null, xử lý trường hợp này
    print('vcl null r');
  }
    setState(() {});
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
  const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(color: Colors.black)
  );
  return TextField(
    style: TextStyle(
      color: Colors.black38,
    ),
    controller: textEditingController,
    decoration: InputDecoration(
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.black45),
      enabledBorder: border,
      focusedBorder: border,
    ),
    obscureText: isPassword,
  );
}

  