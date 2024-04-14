import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http ;
import 'dart:io';
import 'dart:typed_data';

import 'package:newbad/Service/config.dart';
import 'package:newbad/UI/Admin/notipageadmin.dart';

class CourtPageAdmin extends StatefulWidget {
  const CourtPageAdmin({super.key,required this.token, required this.hoten, required this.loc, required this.sodienthoai, required this.anhthumnail, required this.dashboardId, required this.model2d, required this.courtname, });
  final token;
  final String hoten;
  final String sodienthoai;
  final String loc;
  final String anhthumnail;
  final String courtname;
 final String dashboardId;
 final String model2d;

  @override
  State<CourtPageAdmin> createState() => _CourtPageAdminState();
}

class _CourtPageAdminState extends State<CourtPageAdmin> {
  final List<String> imgList = [
    'https://i.stack.imgur.com/1L5On.png',
    'https://i.stack.imgur.com/1L5On.png',
    // Add all image URLs here
  ];
  //ate String dashboardId;
  bool isnotValidate = false;
  TextEditingController sosan = TextEditingController();
  List<TextEditingController> anhmota = [];

//   Future<String> fetchDashboardId(String useradminId) async {
//   final url = Uri.parse(getdatacourt); // Sửa URL của bạn
//   final response = await http.get(url, headers: {
//     "Content-Type": "application/json",
//     'Accept': 'application/json',
//         'accessToken': useradminId,
//     // Thêm headers nếu cần
//   });

//   if (response.statusCode == 200) {
//     var dashboard = jsonDecode(response.body);
//     String id = dashboard['id']; // Giả sử ID nằm trong trường 'id'
//     return id;
//   } else {
//     throw Exception('Failed to load dashboard ID');
//   }
// }

  void addCourtInfo() async {
   // String base64Image = base64Encode(File(_image!.path).readAsBytesSync());
    //String fileName = _image!.path.split("/").last;
    List<String> anhmotaStrings = anhmota.map((controller) => controller.text).toList();
    if (sosan.text.isNotEmpty ) {
      var regBody = {
        "courtId": widget.dashboardId,
        "courtNumber": sosan.text,
        "illustrationimg": anhmotaStrings
      };
      
      var response = await http.post(Uri.parse(getcourtInfo),
      body: jsonEncode(regBody),
      headers: {"Content-Type":"application/json"}
      );
      var jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status']) {
        print("Review added successfully");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
      } else {
        print('loi roi');
      }
    } else {
      setState(() {
        isnotValidate = true;
      });
    }
  }

//   Future<void> fetchDashboardId(String id) async {
//   // Thay YOUR_API_URL_HERE bằng URL của API của bạn
//   final response = await http.get(Uri.parse(getcourtId));
  
//   if (response.statusCode == 200) {
//     final idFromServer = jsonDecode(response.body)['id'];
//     print('ID từ server: $idFromServer');
//     // Thực hiện các hành động khác với ID nhận được từ server
//   } else {
//     throw Exception('Failed to load dashboard ID');
//   }
// }
 
  //TextEditingController soluongsan = TextEditingController();
   late Uint8List bytes ;
   late Uint8List bytes2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
    //dashboardId = jwtDecodeToken['_id'];
    bytes = base64ToUint8List(widget.anhthumnail); 
    bytes2 = base64ToUint8List(widget.model2d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(title: IconButton(onPressed: (){}, icon: const Icon(
      //   Icons.arrow_back_ios_new
      // )),),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                      width: 491,
                      height: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: MemoryImage(bytes),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 30, 0, 0),
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(
                        color: Colors.black,
                               Icons.arrow_back_ios_new
                             )),
                    ),
                ]
                 
              ),
                
                // child: CarouselSlider(
                //   options: CarouselOptions(
                //     autoPlay: false,
                //     aspectRatio: 2.0,
                //     enlargeCenterPage: true,
                //   ),
                //   items: imgList.map((item) => Center(
                //     child: Image.network(item, fit: BoxFit.cover, width: 1000, )
                //   )).toList(),
                // ),
              
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.courtname,
                      style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.28,
                  ),
                    ),
                    SizedBox(height: 12,),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 8,),
                        TextButton(
                           onPressed: () { 
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage())); 
                            }
                           , child: Text(widget.loc,
                          style: TextStyle(
                                    color: Colors.blue.withOpacity(0.699999988079071),
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                    letterSpacing: -0.12,
                                  ),),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 150),
                          child: IconButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotifycationAdminPage(courtid: widget.dashboardId,)));
                          }, icon: Icon(Icons.notifications_active)),
                        )
                      ],
                    ),
                    //SizedBox(height: 12,),
//                     Row(
//                       children: <Widget>[
//                             Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage("assets/field.png"),
//                                   fit: BoxFit.fill,
//                                 ),
//                               ),
//                             ),
//                       SizedBox(width: 12,),
//                         Expanded(
//                           child: Text('6 sân '),
//                         ),
    
//     // ... other children
//   ],
// ),
        SizedBox(height: 12,),
        Row(
          children: [
            Icon(Icons.people_alt),
            SizedBox(width: 12,),
            Text("Chủ sân: ${widget.hoten}"),
          ],
        ),
        SizedBox(height: 12,),
        Row(
          children: [
            Icon(Icons.phone),
            SizedBox(width: 12,),
            Text("Số điện thoại: ${widget.sodienthoai}"),
          ],
        ),
        SizedBox(height: 24,),
        Text(
                      'Sơ đồ sân cầu: ',
                      style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.28,
                  ),
                    ),
        // GridView.count(
        //         crossAxisCount: 2, // Số cột trong GridView
        //         childAspectRatio: 1.0, // Tỉ lệ của từng item (rộng/cao)
        //         mainAxisSpacing: 4.0, // Khoảng cách giữa các hàng
        //         crossAxisSpacing: 4.0, // Khoảng cách giữa các cột
        //         shrinkWrap: true, // Cho phép GridView co lại để vừa với nội dung
        //         physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn trong GridView
        //         children: List.generate(6, (index) => _courts(court: index,)),
        //       ),
        Container(
          width: MediaQuery.of(context).size.width - 30,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(image: MemoryImage(bytes2))
          ),
        )
                    // ... other details
                  ],
                ),
              ),
              
              
              
              //_courts(),
              //_buildImageCarousel(imgList)
              
              
            ],
          ),
        ),
    );
  }
}

Uint8List base64ToUint8List(String base64String) {
  // Giải mã chuỗi base64 thành mảng byte
  List<int> byteList = base64.decode(base64String);
  // Chuyển đổi List<int> thành Uint8List
  return Uint8List.fromList(byteList);
}

Widget _inputField(String hinttext, TextEditingController textEditingController, {isPassword = false}) {
  const Color kbackgroundColor = Color(0xFFf1f1f1);
  const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(color: Colors.black)
  );
  return TextField(
    style: TextStyle(
      color: Colors.black38,
    ),
    keyboardType: TextInputType.number,
    controller: textEditingController,
    decoration: InputDecoration(
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.black45),
      enabledBorder: border,
      focusedBorder: border,
    ),
    obscureText: isPassword,
  );
}

Widget _buildImageCarousel(List<String> imgList) {
  // Kiểm tra xem imgList có phần tử nào không
  if (imgList.isEmpty) {
    // imgList rỗng, trả về Container rỗng hoặc bất kỳ widget nào bạn muốn hiển thị trong trường hợp này
    return Container(); // Hoặc SizedBox.shrink() cũng được
  } else {
    // imgList có phần tử, trả về Container chứa CarouselSlider
    return Container(
      width: 300,
      height: 300,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
        ),
        items: imgList.map((item) => Center(
          child: Image.network(item, fit: BoxFit.cover, width: 1000)
        )).toList(),
      ),
    );
  }
}