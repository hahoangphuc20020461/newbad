import 'dart:convert';

import 'package:newbad/Model/user.dart';
import 'package:newbad/Service/config.dart';
import 'package:http/http.dart' as http ;

class GetUserInfo {
  Future<User?> fetchUserInfo(String id) async {
  
  try {
    final response = await http.get(Uri.parse(getInfUser+id));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      print('Failed to fetch user info. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred while fetching user info: $e');
  }
  return null;
}
}