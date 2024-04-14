import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/dashboardusersv.dart';
import 'package:newbad/Service/getuserId.dart';
import 'package:newbad/UI/Court/bookday/bookday_screen.dart';
import 'package:newbad/UI/Court/danhgia_screen.dart';
import 'package:newbad/UI/Court/map_screen.dart';
import 'package:url_launcher/link.dart';

class CourtPage extends StatefulWidget {
  const CourtPage({super.key, required this.hoten,
   required this.sodienthoai, required this.loc, required this.anhthumnail,
    required this.dashboardId, required this.namecourt, required this.soluongsan, required this.listsan, required this.urlSan, required this.model2d,});
  final String hoten;
  final String sodienthoai;
  final String loc;
  final String anhthumnail;
 final String dashboardId;
 final String namecourt;
 final int soluongsan;
 final List<String> listsan;
 final String urlSan;
 final String model2d;
 
 //final String sansomay;
 

  @override
  State<CourtPage> createState() => _CourtPageState();
}
//'https://i.stack.imgur.com/1L5On.png',
class _CourtPageState extends State<CourtPage> {
  final List<String> imgList = [
    'https://i.stack.imgur.com/1L5On.png',
    'https://i.stack.imgur.com/1L5On.png',
    // Add all image URLs here
  ];
//   Future<String> getPlaceAddress(double lat, double lng) async {
//   final apiKey = 'AIzaSyDaznqv2fgoYqBqPUauA5KBxF0VcrtGlnA'; // Thay 'YOUR_API_KEY' bằng API key thực của bạn
//   final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     // Lấy địa chỉ đầu tiên từ kết quả
//     if (jsonResponse['results'] != null && jsonResponse['results'].length > 0) {
//       return jsonResponse['results'][0]['formatted_address'];
//     } else {
//       return 'Không tìm thấy địa chỉ';
//     }
//   } else {
//     throw Exception('Lỗi khi tìm kiếm địa chỉ: ${response.reasonPhrase}');
//   }
// }
// Giả sử bạn có một tọa độ

String _location = 'Đang tải...';
//String hehe = '105.77403';
Future<void> _getPlace() async {
    // Sử dụng tọa độ của TP. Hồ Chí Minh làm ví dụ
    double latitude = 21.04840;
    double longitude = 105.77403;
    // Lấy thông tin địa điểm từ tọa độ
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _location = '${place.street}, ${place.subAdministrativeArea}, ${place.country}';
      });
    }
  }
  Map<String, dynamic>? jwtDecodeToken;
  Future<List<DashBoardforAdmin>>? _futureDashboardData;
   String? userid; 
    String? userId;
Future<void> _loadUserId() async {
    // Gọi SharedPreferencesService để lấy userId
    userId = await LoginService.getUserId();
    // Để cập nhật UI sau khi nhận userId, gọi setState
    if (userId != null) {
    // Nếu userId không phải là null, giờ chúng ta có thể decode nó
    jwtDecodeToken = JwtDecoder.decode(userId!);
    userid = jwtDecodeToken!['_id'];
    print("User ID retrieved: ${jwtDecodeToken!['_id']}");
  } else {
    // userId là null, xử lý trường hợp này
    print('vcl null r');
  }
    setState(() {});
  }

  late Uint8List bytes ;
  late Uint8List bytes2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlace();
     

    // userId = jwtDecodeToken['_id'];
    _futureDashboardData = DashBoardforUser.fetchallDashboardData();
    // Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(userId!);
    // userid = jwtDecodeToken['_id'];
    _loadUserId();
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
                      '${widget.namecourt}',
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
                        Link(uri: Uri.parse(widget.urlSan),
                        builder: (BuildContext context, Future<void> Function()? followLink) {
                          return TextButton(
                           onPressed: () { 
                            if (followLink != null) {
                              followLink();
                            }
                            }
                           , child: Text('$_location', // widget.location
                          style: TextStyle(
                                    color: Colors.blue.withOpacity(0.699999988079071),
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                    letterSpacing: -0.12,
                                  ),),
                        );
                          },)
                        //child: SizedBox(width: 8,)
                        
                      ],
                    ),
                    SizedBox(height: 12,),
                    Row(
                      children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/field.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                      SizedBox(width: 12,),
                        Expanded(
                          child: Text('${widget.soluongsan} sân'),
                        ),
    
    // ... other children
  ],
),
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
        //SizedBox(height: 24,),
        
             GridView.builder(
                 itemCount: widget.soluongsan,//widget.soluongsan,
                shrinkWrap: true, // Cho phép GridView co lại để vừa với nội dung
                physics: NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn trong GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột trong GridView
          childAspectRatio: 1.0, // Tỉ lệ của từng item (rộng/cao)
          mainAxisSpacing: 4.0, // Khoảng cách giữa các hàng
          crossAxisSpacing: 4.0, // Khoảng cách giữa các cột
        ),
                itemBuilder: (BuildContext context, int index) { 
                  
                   //var courtData = snapshot.data![index % snapshot.data!.length];
                  //  var courtData = snapshot.data[index]; // Truy cập đối tượng dựa trên index của ListView
                  //  print(widget.soluongsan);                
                  //  if (index < widget.soluongsan && index < courtData.soluongsan.length) {
                    return _courts(court: index, idcourt: widget.dashboardId, press: (){
                    print(userid);
                  }, token: userid!, tensan:widget.namecourt, sansomay: widget.listsan[index],);
                  //  } else {
                  //   return SizedBox();
                  //  }
                //   return _courts(court: index, idcourt: courtData.id, press: (){
                //     print(userid);
                //   }, token: userid!, tensan:widget.namecourt, sansomay: courtData.soluongsan[index],);
                  
                //  }
                // children: List.generate(widget.soluongsan, (index) => _courts(court: index, idcourt: snapshot.data![index].id, press: (){
                //   print(userid);
                // }, token: userid!,)),
          }),
       
        Text(
                  'Sơ đồ sân cầu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 0.09,
                    letterSpacing: -0.14,
                  ),
                ),
                SizedBox(height: 20,),
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
              // Container(
              //   width: 300,
              //   height: 300,
              //   child: CarouselSlider(
              //      options: CarouselOptions(
              //         autoPlay: false,
              //         aspectRatio: 1.0,
              //         enlargeCenterPage: true,
              //       ),
              //       items: imgList.map((item) => Center(
              //         child: Image.network(item, fit: BoxFit.cover, width: 1000, )
              //       )).toList(),
              //     //Another CarouselSlider for the gallery thumbnails
              //   ),
              // ),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Container(
                  width: 327,
                  height: 60,
                        child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF388E3C), // background color
                      foregroundColor: Colors.white, // foreground color
                    ),
                    onPressed: () {
                      // Handle button press
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DanhGiasanPage(courtId: widget.dashboardId, courtName: widget.namecourt,)));
                    },
                    child: Text('Đánh giá sân'),
                  ),
                ),
              ),
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

class _courts extends StatelessWidget {
  const _courts({
    super.key, required this.court, required this.idcourt, required this.press, required this.token, required this.tensan, required this.sansomay, 
  });
  final int court;
  final String idcourt; // id của sân cần đặt
  final VoidCallback press;
  final String token; // token để đặt sân
final String tensan; // tên sân (lấy từ dashboard)
final String sansomay; //số thứ tự sân (lấy từ dashboard)
  

  @override
  Widget build(BuildContext context) {
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
    // Nút bấm hình ảnh
    InkWell(
      onTap: () {
        press();
       Navigator.push(context, MaterialPageRoute(builder: (context) => SchedulePage(courtId: idcourt, token: token, tensan: tensan, sansomay: sansomay,)));
        // Hành động khi nút được bấm
        print('Nút hình ảnh được bấm! $idcourt');
        
      },
      child: Image.asset(
        'assets/field.png', // Thay thế đường dẫn của hình ảnh bạn muốn hiển thị
        width: 100, // Chiều rộng của hình ảnh
        height: 100, // Chiều cao của hình ảnh
      ),
    ),
     // Khoảng cách giữa hình ảnh và văn bản
    // Đoạn văn bản mô tả
    Text(
      'sân ${court + 1}',
      style: TextStyle(
        fontSize: 16, // Kích thước chữ
      ),
    ),
    SizedBox(height: 10),
                ],
              );
  }
}
