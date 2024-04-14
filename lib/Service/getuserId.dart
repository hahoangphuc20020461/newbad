
import 'package:shared_preferences/shared_preferences.dart';


class LoginService {
  static const _userIdKey = 'userId';
  static const _tokenKey = 'myToken';

  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
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
