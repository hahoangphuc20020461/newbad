// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http ;
// import 'package:mockito/mockito.dart';
// import 'package:newbad/Model/notifyuser.dart';
// import 'package:newbad/Service/config.dart';
// import 'package:newbad/UI/Mainpage/noti_screen.dart';
// import 'package:newbad/main.dart';
// import 'package:provider/provider.dart';
// class MockClient extends Mock implements http.Client {}
// class ApiService {
//   Future<List<Notify>> getNotifications() async {
//     // Giả sử bạn sử dụng http.Client hoặc một http wrapper khác
//     var response = await http.get(Uri.parse(getnotifyuser));
//     var data = jsonDecode(response.body);
//     return (data as List).map((item) => Notify.fromJson(item)).toList();
//   }
// }
// void main() {
//    group('NotifycationPage Tests', () {
//     testWidgets('NotifycationPage displays notifications when fetched from API', (WidgetTester tester) async {
//       final apiService = MockClient();
//       when(apiService.getNotifications()).thenAnswer((_) async => [Notify()]);

//       // Cung cấp ApiService giả cho widget
//       await tester.pumpWidget(MaterialApp(
//         home: NotifycationPage(apiService: apiService),
//       ));

//       // Đợi cho đến khi widget hoàn tất việc tải và hiển thị dữ liệu
//       await tester.pumpAndSettle();

//       // Kiểm tra xem liệu thông báo đã được hiển thị hay không
//       expect(find.text('Test Notification'), findsOneWidget);
//     });
//   });
// }
