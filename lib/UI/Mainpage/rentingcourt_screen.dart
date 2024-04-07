
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:newbad/Model/bookday/cta/san1cta.dart';
import 'package:newbad/Service/bookday/datsan.dart';
import 'package:newbad/Service/getuserId.dart';

class RentingCourtPage extends StatefulWidget {
  const RentingCourtPage({super.key});

  @override
  State<RentingCourtPage> createState() => _RentingCourtPageState();
}

class _RentingCourtPageState extends State<RentingCourtPage> {
  Future<List<San1DayCTA>>? _futurebookingdData;
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
        _futurebookingdData = BookingCourtService.fetchBookingData('$token');
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
    //_futurebookingdData = BookingCourtService.fetchBookingData('$token');
    //_futurebookingdData = BookingCourtService.fetchBookingData('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWQ3NzBjOGI5YmU2MThmMmFhN2M4ODMiLCJpYXQiOjE3MTIyMDM4NDAsImV4cCI6MTcxMjIwNzQ0MH0.REK4ZUo4d5P-__c9D4SNzrmcCzMvTeuUBEE8DmFkJt8');
    print(token);
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Sân đang thuê'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     onPressed: () {
        //       // Hành động khi nhấn vào icon
        //     },
        //   ),
        // ],
      ),
      body: FutureBuilder(
        future: _futurebookingdData,
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
              return _buildOrderItem(context, snapshot.data![index].tensan, snapshot.data![index].starttime,
             snapshot.data![index].endtime, snapshot.data![index].sansomay);
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


  Widget _buildOrderItem(BuildContext context, String namecourt, String starttime,String endtime, String date) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(namecourt),
            subtitle: Text('Sân $date'),
            trailing: Image.asset('assets/field.png'),
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CourtPage()));
              // Hành động khi nhấn vào mục đơn hàng
            },
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text('$starttime - $endtime'),
          ),
          
          // FlatButton(
          //   onPressed: () {
          //     // Hành động khi nhấn nút đặt lại
          //   },
          //   child: Text(repeatOrderText),
          //   color: Colors.orange,
          // ),
        ],
      ),
    );
  }
}