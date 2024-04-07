import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/Service/dashboardadminsv.dart';
import 'package:newbad/UI/Admin/courtpageadmin.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key, required this.token});
  final token;

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  TextEditingController tensan = TextEditingController();
  TextEditingController tenchusan =TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController location =TextEditingController();
  TextEditingController linkvitri = TextEditingController();
  TextEditingController soluongsan = TextEditingController();
  late String useradminId;
  bool isnotValidate = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List<DashBoardforAdmin> item = [];
  Timer? _pollingTimer;
  //soluongsan.text.split(',').map((item) => item.trim()).toList();

  void addCourt() async {
    String base64Image = base64Encode(File(_image!.path).readAsBytesSync());
    //String fileName = _image!.path.split("/").last;
    List<String> soluongSanArray = soluongsan.text.split(',').map((e) => e.trim()).toList();
    if (tensan.text.isNotEmpty && tenchusan.text.isNotEmpty &&
     phonenumber.text.isNotEmpty && location.text.isNotEmpty && linkvitri.text.isNotEmpty) {
      var regBody = {
        "useradminId": useradminId,
        "name" : tensan.text,
        "nameofpeople": tenchusan.text,
        "phonenumber": phonenumber.text,
        "location": location.text,
        "image": base64Image,
        "linklocation": linkvitri.text,
        "soluongsan": soluongSanArray
      };
      
      var response = await http.post(Uri.parse(addcourt),
      body: jsonEncode(regBody),
      headers: {"Content-Type":"application/json"}
      );
      var jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status']) {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));
        print('ok');
        print("Số lượng sân: $soluongSanArray");
      } else {
        print('loi roi');
      }
    } else {
      setState(() {
        isnotValidate = true;
      });
    }
  }

  // void getdatadashboard(useradminId) async {
  //   var regBody = {
  //       "useradminId": useradminId,
  //       // "name" : tensan.text,
  //       // "nameofpeople": tenchusan.text,
  //       // "phonenumber": phonenumber.text,
  //       // "location": location.text,
  //       //"image": base64Image
  //     };
  //     try{
  //     var response = await http.post(Uri.parse(getdatacourt),
  //     body: jsonEncode(regBody),
  //     headers: {"Content-Type":"application/json"}
  //     );
  //     // var jsonResponse = jsonDecode(response.body);
  //     //  Map<String, dynamic> mapj = jsonResponse;
  //     //  List<DashBoardforAdmin> tempDataList = [];
  //     //  mapj.forEach((key, value) {
  //     //   tempDataList.add(DashBoardforAdmin(name: value['name'], nameofpeople: value['nameofpeople'],
  //     //   phonenumber: value['phonenumber'], location: value['location'],image: value['image'],
  //     //    ));
  //     //  });
  //      if (response.statusCode == 200) {
  //     List<dynamic> jsonResponse = jsonDecode(response.body);
  //     List<DashBoardforAdmin> tempDataList = jsonResponse.map((data) {
  //       return DashBoardforAdmin.fromJson(data);
  //     }).toList();
      
  //     setState(() {
  //       item = tempDataList;
  //     });
  //   } else {
  //     // Handle the case when the server does not return a 200 OK response
  //     print('Server error: ${response.body}');
  //   }
  // } catch (e) {
  //   // Handle any errors that occur during the request
  //   print('Error occurred: $e');
  // }
  //     //item = jsonResponse['successRes'];
      
  //     //   item.add(jsonResponse);
      
  //     // setState(() {
  //     //   item = tempDataList;
  //     // });
    
  // }
  Future<List<DashBoardforAdmin>>? _futureDashboardData;

  void fetchData() {
  setState(() {
    _futureDashboardData = DashboardService.fetchDashboardData(widget.token);
  });
}

// Future<void> fetchDashboardId(String id) async {
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

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  @override
  void initState() {
    
    //_checkLocationPermission();
    // TODO: implement initState
    super.initState();
    
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    useradminId = jwtDecodeToken['_id'];
    _futureDashboardData = DashboardService.fetchDashboardData(widget.token);
  }
  
  

  @override
  void dispose() {
    // TODO: implement dispose
    //_pollingTimer?.cancel();
    super.dispose();
    //pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xin chào ",
        style: TextStyle(
                              color: Color(0xFF0D2D3A),
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                                            )),
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    Text('$useradminId',
                    textAlign: TextAlign.left,),
                   
                  ],
                ),
              ),
              SizedBox(height: 18,),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: Row(
                  children: [
                    Text("Sân của bạn: ",
                                style: TextStyle(
                                    color: Color(0xFF0D2D3A),
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    
                                                  )),
                       Padding(
                      padding: const EdgeInsets.only(left: 130),
                      child: InkWell(
      onTap: () {
        // Xử lý sự kiện khi nút được nhấn
         showDialog (context: context, builder: ((context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text('Thêm thông tin sân của bạn'),
              content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                _inputField("Tên sân", tensan),
                      SizedBox(height: 10),
                _inputField("Tên chủ sân", tenchusan),
                SizedBox(height: 10,),
                _inputField("Số điện thoại", phonenumber),
                SizedBox(height: 10,),
                _inputField("Vị trí sân", location),
                SizedBox(height: 10,),
                _inputField("Link vị trí",linkvitri),
                SizedBox(height: 10,),
                _inputField("Nhập số lượng sân theo mẫu: 1, 2, ...", soluongsan),
                Row(
                  children: [
                    Text("Thêm ảnh mô tả sân của bạn"),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      _pickImage();
                    }, icon: Icon(Icons.add_a_photo)),
                  ],
                )
              ],
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                          child: Text('Đóng'),
                          onPressed: () {
                            //print(item[0]);

                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        SizedBox(width: 130,),
                    TextButton(
                          child: Text('Thêm'),
                          onPressed: () {
                            addCourt();
                            //fetchData();
                            // Add your add to-do code here
                            
                            showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                title: Text("Sân của bạn đã được thêm"),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                            //Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                  ],
                ),
              ],
            ),
          );
        }),
        
        );
      },
      child: Container(
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF388E3C), // Màu nền của nút
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white, // Màu biểu tượng
          ),
        ),
      ),
    )
                    )
                  ],
                ),
              ),
              Container(
                
                height: MediaQuery.of(context).size.height,
                width: 350,
                child: FutureBuilder(future: _futureDashboardData, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(padding: EdgeInsets.only(left: 10, right: 10),
                    child: CardList(courtname: snapshot.data![index].name ?? 'unnamed', location: snapshot.data![index].location ?? 'none',
                     image: snapshot.data![index].image, hotenchusan: snapshot.data![index].nameofpeople,
                      sodienthoai: snapshot.data![index].phonenumber, vitritrongsan: snapshot.data![index].location,
                      tokenn: widget.token, anhthumnail: snapshot.data![index].image, id: snapshot.data![index].id, )// image: item?[index]['image'],),
                    ); //snapshot.data![index].name
                 },);
          }
                }),
                // child: ListView.builder(
                //   itemCount: ,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Padding(padding: EdgeInsets.only(left: 10, right: 10),
                //     child: CardList(courtname: item[index].name ?? 'unnamed', location: item[index].location ?? 'none',)// image: item?[index]['image'],),
                //     );
                //  },),
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
  const CardList({super.key, required this.courtname, required this.location,
   required this.image, this.tokenn, required this.hotenchusan, required this.sodienthoai,
    required this.vitritrongsan, required this.anhthumnail, required this.id, }); //required this.image});
  final String courtname;
  final String location;
  final String image;
  final tokenn;
  final String hotenchusan;
  final String sodienthoai;
  final String vitritrongsan;
  final String anhthumnail;
  final String id;
  

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
                  child: Image.memory(bytes),
                  onTap: (){
                    print(id);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CourtPageAdmin(token: tokenn, hoten: hotenchusan,
                     loc: vitritrongsan, sodienthoai: sodienthoai, anhthumnail: anhthumnail, dashboardId: id, )));
                  },
                ),
              width: 340.13,
              height: 235,
              decoration: ShapeDecoration(
                // image: DecorationImage(
                 //   image: Image.memory(bytes),
                //   //image: NetworkImage("https://via.placeholder.com/340x235"),
                //    fit: BoxFit.fill,
                // ),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                 ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(230, 15, 0, 0),
              child: Row(
              children: [
                //SizedBox(width: 220),
                Icon(Icons.location_on),
                Text(
                              '$location',
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
          '$courtname',
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