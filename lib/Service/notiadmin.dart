import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:newbad/Model/notifyadmin.dart';
import 'package:newbad/Service/config.dart';

class NotifyAdminService {
static Future<List<NotifyAdmin>> fetchallNotiData(String courtid) async {
    final response = await http.get(Uri.parse(getDanhgia+'?courtId=$courtid'),
    headers: {
      'Content-Type': 'application/json',
        'Accept': 'application/json',
        //'accessToken': userid,
        //'id': '$useradminId'
    });
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
      // Nếu jsonResponse là một List, chuyển mỗi phần tử thành một đối tượng DashboardForAdmin
      return jsonResponse.map((response) => NotifyAdmin.fromJson(response)).toList();
    } else if (jsonResponse is Map) {
      // Nếu jsonResponse là một Map, và bạn biết key chứa mảng, truy cập mảng đó
      // Ví dụ, nếu mảng nằm trong key 'data'
      final List<dynamic> dataList = jsonResponse['successRes'] as List<dynamic>;  //List.from(jsonResponse['successRes']);
      return dataList.map((data) => NotifyAdmin.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected JSON format');
    }
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }

}