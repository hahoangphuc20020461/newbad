import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/config.dart';

class DashBoardforUser {
  static Future<List<DashBoardforAdmin>> fetchallDashboardData() async {
    final response = await http.get(Uri.parse(getalldatacourt),
    headers: {
      'Content-Type': 'application/json',
        'Accept': 'application/json',
        //'accessToken': useradminId,
        //'id': '$useradminId'
    });
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is List) {
      // Nếu jsonResponse là một List, chuyển mỗi phần tử thành một đối tượng DashboardForAdmin
      return jsonResponse.map((response) => DashBoardforAdmin.fromJson(response)).toList();
    } else if (jsonResponse is Map) {
      // Nếu jsonResponse là một Map, và bạn biết key chứa mảng, truy cập mảng đó
      // Ví dụ, nếu mảng nằm trong key 'data'
      final List<dynamic> dataList = jsonResponse['successRes'] as List<dynamic>;  //List.from(jsonResponse['successRes']);
      return dataList.map((data) => DashBoardforAdmin.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected JSON format');
    }
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}