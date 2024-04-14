import 'package:flutter/material.dart';
import 'package:newbad/Model/notifyadmin.dart';
import 'package:newbad/Model/notifyuser.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/Service/notiadmin.dart';
import 'package:newbad/Service/notifyusersv.dart';

class NotifycationAdminPage extends StatefulWidget {
  const NotifycationAdminPage({super.key, required this.courtid});
  final String courtid;

  @override
  State<NotifycationAdminPage> createState() => _NotifycationAdminPageState();
}

class _NotifycationAdminPageState extends State<NotifycationAdminPage> {
  Future<List<NotifyAdmin>>? _futureNotiAdminData;
  String? userid; 
    String? userId;
    String? token;
    Map<String, dynamic>? jwtDecodeToken;
// void doSomethingWithToken() async {
//     token = await LoginService.getToken();
//     if (token != null && mounted) {
//       // Token đã lấy ra thành công và bạn có thể sử dụng nó ở đây
//       print("We have the token: $token");
//       setState(() {
//         _futureNotiData = NotifyService.fetchallNotiData('$token');
//       });
      
//       // Thực hiện các hành động tiếp theo cần sử dụng token
//     } else {
//       Center(child: CircularProgressIndicator());
//       // Token không tồn tại, có thể do người dùng chưa đăng nhập
//       print("No token found, user might not be logged in.");
//       // Xử lý trường hợp không có token, ví dụ: chuyển người dùng đến màn hình đăng nhập
//     }
//   }
  @override
  void initState() {
    // TODO: implement initState
    _futureNotiAdminData = NotifyAdminService.fetchallNotiData(widget.courtid);
    super.initState();
    //doSomethingWithToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        
      ),
      body:
      FutureBuilder(
        future: _futureNotiAdminData,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) { 
            if(snapshot.data != null && index < snapshot.data.length) {
              return ListTile(
            // leading: CircleAvatar(
            //   // Add notification icon or image
            //   backgroundImage: NetworkImage('your_image_url_here'),
            // ),
             // Replace with actual data
            subtitle: Text(snapshot.data[index].message), // Replace with actual data
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Handle more action
              },
            ),
          );
            } else {
              return SizedBox();
            }
            
           } 
            // Thêm các mục đơn hàng khác ở đây
        );
          }
         },
      ), 
    );
  }
}