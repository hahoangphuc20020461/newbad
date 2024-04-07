import 'dart:convert';
import 'dart:math';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http ;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/dashboardusersv.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.token, required this.courtId, required this.tensan, required this.sansomay});
  final String token;
  final String courtId;
  final String tensan;
  final String sansomay;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  // String startca1 = '05:00';
  // String startca2 = '07:00';
  // String startca3 = '09:00';
  // String startca4 = '11:00';
  // String startca5 = '13:00';
  // String startca6 = '15:00';
  // String startca7 = '17:00';
  // String startca8 = '19:00';
  // String startca9 = '21:00';
  
  // String endca1 = '06:59';
  // String endca2 = '08:59';
  // String endca3 = '10:59';
  // String endca4 = '12:59';
  // String endca5 = '14:59';
  // String endca6 = '16:59';
  // String endca7 = '18:59';
  // String endca8 = '20:59';
  // String endca9 = '22:59';

  List<String> liststart = ['05:00', '07:00', '09:00', '11:00', '13:00','15:00', '17:00', '19:00', '21:00'];
  List<String> listend = ['06:59', '08:59', '10:59', '12:59', '14:59', '16:59', '18:59', '20:59', '22:59'];

  bool click = false;
  // String? start;
  // String? end;
  
  String isoDateDirect = DateTime.now().toIso8601String();
  Future<List<DashBoardforAdmin>>? _futureDashboardData;
  DateTime selectedDate = DateTime.now();

void updateSelectedDateString() {
  setState(() {
    isoDateDirect = selectedDate.toIso8601String(); // Chuyển đổi selectedDate sang string theo chuẩn ISO 8601 và lưu vào biến
  });
}

void goToNextDay() {
  setState(() {
    selectedDate = selectedDate.add(Duration(days: 1));
    updateSelectedDateString(); // Thêm 1 ngày vào ngày hiện tại
  });
}

void goToPreviousDay() {
  setState(() {
    if (selectedDate.isAfter(DateTime.now())) { // Kiểm tra để không quay trở lại quá ngày hiện tại
      selectedDate = selectedDate.subtract(Duration(days: 1));
      updateSelectedDateString(); // Bớt 1 ngày từ ngày hiện tại
    }
  });
}

void _selectDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
      updateSelectedDateString();
    });
  }
}
  String? userid;
    String? userId;
Future<void> _loadUserId() async {
    // Gọi SharedPreferencesService để lấy userId
    userId = await LoginService.getUserId();
    // Để cập nhật UI sau khi nhận userId, gọi setState
    if (userId != null) {
    // Nếu userId không phải là null, giờ chúng ta có thể decode nó
    var jwtDecodeToken = JwtDecoder.decode(userId!);
    userid = jwtDecodeToken!['_id'];
    print("User ID retrieved: ${jwtDecodeToken!['_id']}");
  } else {
    // userId là null, xử lý trường hợp này
    print('vcl null r');
  }
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodeToken['_id'];
    _futureDashboardData = DashBoardforUser.fetchallDashboardData();
    _loadUserId();
     //updateSelectedDateString();
  }

  void button() {
    setState(() {
      click = true;
    });
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10000', 'GBP');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "GB",
          currencyCode: "GBP",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Abhi',
              googlePay: gpay))
          .then((value) {
            
          });
      //STEP 3: Display Payment sheet
      displayPaymentSheet();
      //addCourt(start, end);
      //newNotify(message);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
        showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Đặt sân thành công"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));

        //addCourt(start, end);
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount, 
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51P0KVJP8OZat8l3pyY11Izejt8aGn9qzwyDAcqgMv2XVXphxMO3bJf9ihuKHYUsK6gAsI0PBzxSLirDeJP60DEPm00SBnX0Aqi',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

    void addCourt(String start, String end) async {
      var regBody = {
        "courtId": widget.courtId,
        "userId" : widget.token,
        "tensan" : widget.tensan,
        "sansomay": widget.sansomay,
        "starttime": start,
        "endtime": end,
        "date": isoDateDirect,
        "status": "Sân đã đặt",
        "paymentstatus": false
      };
      print('Sending request with body: $regBody');
      // var response = await http.post(Uri.parse(bookctasan1day),
      // body: jsonEncode(regBody),
      // headers: {"Content-Type":"application/json"}
      // );
      // var jsonResponse = jsonDecode(response.body);
      
      // if (jsonResponse['status']) {
      //   //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
      // } else {
      //   print('loi roi');
      // }
      try {
    var response = await http.post(Uri.parse(bookctasan1day),
    body: jsonEncode(regBody),
    headers: {"Content-Type":"application/json; charset=UTF-8"}
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Response: $jsonResponse'); // Thêm logging
      if (jsonResponse['status']) {
        makePayment();
        // Success logic
      } else {
        // Error handling
        print('Error from API: ${jsonResponse['message']}');
      }
    } else {
      showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Ca này đã được đặt trước, vui lòng chọn ca khác"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
      // Error handling
      print('Request failed with status: ${response.statusCode}.');
    }
  } on Exception catch (e) {
    // Exception handling
    makePayment();
    print('Exception occurred: $e');
  }
    //  else {
    //   setState(() {
    //     isnotValidate = true;
    //   });
    // }
  }

  void newNotify(String message) async {
      var regBody = {
        "userId": widget.token,
        "courtname": widget.tensan,
        "message": message
      };
      
      var response = await http.post(Uri.parse(newnotifyuser),
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
            Navigator.of(context).pop();
            // Logic to go back or show previous day's schedule
          },
        ),
        
      ),
      body:Column(
        children: [ 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              goToPreviousDay();
              // Logic to show next day's schedule
            },
          ),
              IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate();
              // Logic to select date
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              goToNextDay();
              // Logic to show next day's schedule
            },
          ),
            ],
          ),
          Center(child: Text("${selectedDate.toLocal()}".split(' ')[0])),
          SizedBox(height: 20,),
          GridView.count(
                  crossAxisCount: 3, // Số cột trong GridView
                  childAspectRatio: 1.0, // Tỉ lệ của từng item (rộng/cao)
                  mainAxisSpacing: 3.0, // Khoảng cách giữa các hàng
                  crossAxisSpacing: 3.0, // Khoảng cách giữa các cột
                  shrinkWrap: true, // Cho phép GridView co lại để vừa với nội dung
                  physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn trong GridView
                  children: List.generate(listend.length, (index) => Hourly(starttime: liststart[index],
                   endtime: listend[index], click: click, press: () { 
                    addCourt(liststart[index], listend[index]); 
                    
                    //makePayment(liststart[index], listend[index], 'Bạn đã thuê ${widget.tensan} từ ${liststart[index]} đến ${listend[index]}');
                   
                    // if (click == false) {
                    //   button();
                    // }
                    
                    },)),
                )
        //   FutureBuilder(
        //             future: _futureDashboardData,
        //             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
        //               if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     } else if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     } else {
        //       return GridView.count(
        //           crossAxisCount: 3, // Số cột trong GridView
        //           childAspectRatio: 1.0, // Tỉ lệ của từng item (rộng/cao)
        //           mainAxisSpacing: 3.0, // Khoảng cách giữa các hàng
        //           crossAxisSpacing: 3.0, // Khoảng cách giữa các cột
        //           shrinkWrap: true, // Cho phép GridView co lại để vừa với nội dung
        //           physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn trong GridView
        //           children: List.generate(listend.length, (index) => Hourly(starttime: liststart[index],
        //            endtime: listend[index], click: click, press: () { 
        //             addCourt(liststart[index], listend[index]); 
        //             makePayment();
        //             //makePayment(liststart[index], listend[index], 'Bạn đã thuê ${widget.tensan} từ ${liststart[index]} đến ${listend[index]}');
                   
        //             // if (click == false) {
        //             //   button();
        //             // }
                    
        //             },)),
        //         );
        //     }
        //             }
        // ),
        ]
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
            // if  (click == true) {
            //   showDialog(context: context, builder: ( (context) {
            //                   return AlertDialog(
            //                     title: Text("Ca này đã được đặt trước, vui lòng chọn ca khác"),
            //                     actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
            //                   );
            //                 }));
            // } else {
            //   showDialog(context: context, builder: ( (context) {
            //                   return AlertDialog(
            //                     title: Text("Đặt sân thành công"),
            //                     actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
            //                   );
            //                 }));
            // }
            
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