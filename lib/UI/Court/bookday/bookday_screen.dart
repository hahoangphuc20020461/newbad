import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http ;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/dashboardusersv.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.token, required this.courtId});
  final token;
  final String courtId;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  String startca1 = '05:00';
  String startca2 = '07:00';
  String startca3 = '09:00';
  String startca4 = '11:00';
  String startca5 = '13:00';
  String startca6 = '15:00';
  String startca7 = '17:00';
  String startca8 = '19:00';
  String startca9 = '21:00';
  
  String endca1 = '06:59';
  String endca2 = '08:59';
  String endca3 = '10:59';
  String endca4 = '12:59';
  String endca5 = '14:59';
  String endca6 = '16:59';
  String endca7 = '18:59';
  String endca8 = '20:59';
  String endca9 = '22:59';

  List<String> liststart = ['05:00', '07:00', '09:00', '11:00', '13:00','15:00', '17:00', '19:00', '21:00'];
  List<String> listend = ['06:59', '08:59', '10:59', '12:59', '14:59', '16:59', '18:59', '20:59', '22:59'];

  bool click = false;
  late String userId;
  
  String isoDateDirect = DateTime.now().toIso8601String();
  Future<List<DashBoardforAdmin>>? _futureDashboardData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodeToken['_id'];
    _futureDashboardData = DashBoardforUser.fetchallDashboardData();
  }

  void button() {
    setState(() {
      click = true;
    });
  }

    void addCourt(String start, String end) async {
      var regBody = {
        "courtId": widget.courtId,
        "userId" : userId,
        "starttime": start,
        "endtime": end,
        "date": isoDateDirect,
        "status": "Đã đặt sân",
        "paymentstatus": false
      };
      
      var response = await http.post(Uri.parse(bookctasan1day),
      body: jsonEncode(regBody),
      headers: {"Content-Type":"application/json"}
      );
      var jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status']) {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
      } else {
        print('loi roi');
      }
    //  else {
    //   setState(() {
    //     isnotValidate = true;
    //   });
    // }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt lịch ngày trực quan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Logic to go back or show previous day's schedule
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // Logic to select date
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Logic to show next day's schedule
            },
          ),
        ],
      ),
      body:FutureBuilder(
                  future: _futureDashboardData,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                    if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.count(
                crossAxisCount: 3, // Số cột trong GridView
                childAspectRatio: 1.0, // Tỉ lệ của từng item (rộng/cao)
                mainAxisSpacing: 3.0, // Khoảng cách giữa các hàng
                crossAxisSpacing: 3.0, // Khoảng cách giữa các cột
                shrinkWrap: true, // Cho phép GridView co lại để vừa với nội dung
                physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn trong GridView
                children: List.generate(listend.length, (index) => Hourly(starttime: liststart[index],
                 endtime: listend[index], click: click, press: () { addCourt(liststart[index], listend[index]); },)),
              );
          }
                  }
      )
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     // Logic to add a new booking
      //   },
      // ),
    );
  }
}

class Hourly extends StatelessWidget {
  const Hourly({super.key, required this.starttime, required this.endtime, required this.click, required this.press, });
  final String starttime;
  final String endtime;
  final bool click;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          
          width: 120,
          child: FloatingActionButton(onPressed: (){
            press();
            if  (click == true) {
              showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Đặt sân thành công"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
            } else {
              showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Ca này đã được đặt trước, vui lòng chọn ca khác"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
            }
            
          },
          child: Text('$starttime - $endtime'),
          ),
          decoration: BoxDecoration(
             
            borderRadius: BorderRadius.circular(30)
          ),
        )
      ],
    );
  }

}