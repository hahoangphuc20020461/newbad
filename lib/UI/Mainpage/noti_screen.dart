import 'package:flutter/material.dart';
import 'package:newbad/Model/notifyuser.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/Service/notifyusersv.dart';

class NotifycationPage extends StatefulWidget {
  const NotifycationPage({super.key});

  @override
  State<NotifycationPage> createState() => _NotifycationPageState();
}

class _NotifycationPageState extends State<NotifycationPage> {
  Future<List<Notify>>? _futureNotiData;
  String? userid; 
    String? userId;
    String? token;
    Map<String, dynamic>? jwtDecodeToken;
void doSomethingWithToken() async {
    token = await LoginService.getToken();
    if (token != null && mounted) {
      // Token đã lấy ra thành công và bạn có thể sử dụng nó ở đây
      print("We have the token: $token");
      setState(() {
        _futureNotiData = NotifyService.fetchallNotiData('$token');
      });
      
      // Thực hiện các hành động tiếp theo cần sử dụng token
    } else {
      Center(child: CircularProgressIndicator());
      // Token không tồn tại, có thể do người dùng chưa đăng nhập
      print("No token found, user might not be logged in.");
      // Xử lý trường hợp không có token, ví dụ: chuyển người dùng đến màn hình đăng nhập
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doSomethingWithToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Thông báo',
        style: TextStyle(
              color: Color(0xFF0D2D3A),
              fontSize: 25,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
                            ),),
        
      ),
      body:
      FutureBuilder(
        future: _futureNotiData,
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
            title: Text(snapshot.data[index].courtname), // Replace with actual data
            subtitle: Text(snapshot.data[index].message), // Replace with actual data
            
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