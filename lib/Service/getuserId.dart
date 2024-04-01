import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newbad/Service/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http ;

class LoginService {
  static const _userIdKey = 'userId';

  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
  // Future<void> loginUser(BuildContext context, String username, String pass) async {
  //   try {
  //     var regBody = {
  //       "username": username,
  //       "password": pass
  //     };

  //     var response = await http.post(
  //       Uri.parse(login), // Thay YOUR_LOGIN_ENDPOINT bằng endpoint của bạn
  //       body: jsonEncode(regBody),
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       var myToken = jsonResponse['accessToken'];

  //       // Kiểm tra xem token có tồn tại không
  //       if (myToken != null && myToken.isNotEmpty) {
  //         // Token hợp lệ, chuyển qua màn hình mới
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => NavigatePage(token: myToken)),
  //         );
  //       } else {
  //         // Token không hợp lệ hoặc thiếu, hiển thị thông báo lỗi
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text('$myToken'),//Invalid token or missing token
            
  //         ));
  //       }
  //     } else if (response.statusCode == 404) {
  //       print('Email is not found');
  //     } else if (response.statusCode == 403) {
  //       print('Password is incorrect');
  //     } else {
  //       print('Login failed with status code: ${response.statusCode}');
  //       print('Error message: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('An error occurred: $e');
  //   }
  // }
}
