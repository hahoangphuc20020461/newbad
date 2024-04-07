
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/dashboardusersv.dart';
import 'package:newbad/UI/Court/court_screen.dart';
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key, });
  //final token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController; 
  int _bottomNavIndex = 0;
  String searchValue = '';
  final List<String> _suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];
  //GoogleMapController? googleMapController;
  //final LatLng center = const LatLng(21.03748, 105.78341);
  // void onMapCreated(GoogleMapController controller) {
  //   googleMapController = controller;
  // }
  String _location = 'Đang tìm vị trí...';
  

Future<void> _determinePosition() async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Vị trí: ${position.latitude}, ${position.longitude}");

    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.first;
    setState(() {
      _location = '${place.locality}, ${place.country}';
    });
    print("Địa điểm: $_location");
  } catch (e) {
    print("Lỗi khi lấy vị trí hoặc địa điểm: $e");
    setState(() {
      _location = "Không thể lấy được địa điểm.";
    });
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    print("Quyền truy cập vị trí đã được cấp.");
    _determinePosition();
  } else if (status.isDenied) {
    print("Quyền truy cập vị trí bị từ chối.");
  } else if (status.isPermanentlyDenied) {
    print("Quyền truy cập vị trí bị từ chối vĩnh viễn. Mở cài đặt.");
    openAppSettings();
  }
}

 //List<Widget> listpage = [StartPage(), LoginPage(title: '')];
  Future<List<DashBoardforAdmin>>? _futureDashboardData;
  @override
  void initState() {
    requestLocationPermission();
    //_checkLocationPermission();
    // TODO: implement initState
    super.initState();
    _futureDashboardData = DashBoardforUser.fetchallDashboardData();
    //Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    //late String username = jwtDecodeToken['username'];
  //pageController = PageController();
  
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // bottomNavigationBar: SalomonBottomBar(
        
      //   currentIndex: _bottomNavIndex,
      //   onTap: (i) => setState(() => _bottomNavIndex = i),
      //   items: [SalomonBottomBarItem(
      //         icon: Icon(Icons.home),
      //         title: Text("Trang chủ"),
      //         selectedColor: Color(0xFF388E3C),
      //       ),

      //       /// Likes
      //       SalomonBottomBarItem(
      //         icon: Icon(Icons.bookmark_add_rounded),
      //         title: Text("Sân Thuê"),
      //         selectedColor: Color(0xFF388E3C),
      //       ),

      //       /// Search
      //       SalomonBottomBarItem(
      //         icon: Icon(Icons.notifications),
      //         title: Text("Thông báo"),
      //         selectedColor: Color(0xFF388E3C),
      //       ),

      //       /// Profile
      //       SalomonBottomBarItem(
      //         icon: Icon(Icons.person),
      //         title: Text("Trang cá nhân"),
      //         selectedColor: Color(0xFF388E3C),
      //       ),]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _futureDashboardData,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                      return SearchAnchor(
                        builder: (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                        // trailing: <Widget>[
                        //   Tooltip(
                        //     message: 'Change brightness mode',
                        //     child: IconButton(
                        //       isSelected: isDark,
                        //       onPressed: () {
                        //         setState(() {
                        //           isDark = !isDark;
                        //         });
                        //       },
                        //       icon: const Icon(Icons.wb_sunny_outlined),
                        //       selectedIcon: const Icon(Icons.brightness_2_outlined),
                        //     ),
                        //   )
                        // ],
                      );
                    }, suggestionsBuilder:
                            (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(snapshot.data?.length, (int index) {
                        final String item = snapshot.data![index].name;
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            print(snapshot.data![index].soluongsan.length);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CourtPage(hoten: snapshot.data![index].nameofpeople,
                     sodienthoai: snapshot.data![index].phonenumber, loc: snapshot.data![index].location, anhthumnail: snapshot.data![index].nameofpeople,
                      dashboardId: snapshot.data![index].id, namecourt: snapshot.data![index].name, soluongsan: snapshot.data![index].soluongsan.length, 
                      listsan: snapshot.data![index].soluongsan,
                      )));
                              //controller.closeView(item);
                            
                          },
                        );
                      });
                    });
                     },
                    
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Row(
                  children: [
                    Text('Vị trí của bạn:',
                          style: TextStyle(
                              color: Color(0xFF0D2D3A),
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                                            )
                          ),
                          //SizedBox(width: 70,),
                          
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_sharp),
                    Text('$_location'),
                    //SizedBox(width: 50,),
                    
                    
                    
                  ],
                ),
              ),
                Row(
                  children: [
                    TextButton.icon(onPressed: (){}, icon: Icon(Icons.location_on, // Biểu tượng của nút
                        color: Colors.green, // Màu của icon
                        size: 24,), label: Text(
                        'Xem sân gần đây', // Text hiển thị dưới icon
                        style: TextStyle(
                          color: Colors.green, // Màu của text
                           // Kích thước của text
                        ),
                                    ),),
                  ],
                ),  
              
              
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text('Tất cả sân:',
                    style: TextStyle(
                        color: Color(0xFF0D2D3A),
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                                      )
                    ),
                  ],
                ),
              ),
              
              Container(
                
                height: MediaQuery.of(context).size.height,
                width: 350,
                child: FutureBuilder(
                  future: _futureDashboardData,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                    if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            
            return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) { 
                      return Padding(padding: EdgeInsets.only(left: 10, right: 10),
                      child: CardList(name: snapshot.data![index].name,
                       location: snapshot.data![index].location,
                        hotenchusan: snapshot.data![index].nameofpeople, sodienthoai: snapshot.data![index].phonenumber,
                         vitritrongsan: snapshot.data![index].phonenumber, anhthumnail: snapshot.data![index].image,
                          id: snapshot.data![index].id, soluongsan: snapshot.data![index].soluongsan.length,
                           listsan: snapshot.data![index].soluongsan, image: snapshot.data![index].image, ),
                      );
                   },);
          }
                   },
                  
                ),
              )
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

class CardList extends StatelessWidget {
  const CardList({super.key, required this.name, required this.location,
   required this.hotenchusan, required this.sodienthoai,
    required this.vitritrongsan, required this.anhthumnail, required this.id,
     required this.soluongsan, required this.listsan, required this.image, });
  final String name;
  final String location;
  final String hotenchusan;
  final String sodienthoai;
  final String vitritrongsan;
  final String anhthumnail;
  final String id;
  final String image;
  final int soluongsan;
  final List<String> listsan;
  
  //final Token;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64ToUint8List(image);
    return Container(
        decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CourtPage(hoten: hotenchusan,
                     sodienthoai: sodienthoai, loc: location, anhthumnail: anhthumnail,
                      dashboardId: id, namecourt: name, soluongsan: soluongsan, listsan: listsan,)));
                  },
                ),
              width: 340.13,
              height: 235,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: MemoryImage(bytes),
                   fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                 ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
              child: Row(
              children: [
                //SizedBox(width: 220),
                Icon(Icons.location_on),
                Text(
                              '$location',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: null,
                              style: TextStyle(
                                color: Color(0xFF0882B4),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
              ],
                        ),
            ),
            ],
            //child: 
          ),
          SizedBox(width: 20,),
          Text(
          '$name',
          style: TextStyle(
              color: Color(0xFF0D2D3A),
              fontSize: 25,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 0,
                            ),
                      ),
          //SizedBox(height: 10,),
          
               SizedBox(height: 20,) 
        ],
      ),
    );
  }
}
