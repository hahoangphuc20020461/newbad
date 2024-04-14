// import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newbad/Model/testmodel.dart';
import 'package:newbad/Service/config.dart';
import 'package:newbad/main.dart';
import 'package:newbad/sv.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class TestStripe extends StatefulWidget {
//   const TestStripe({super.key});

//   @override
//   State<TestStripe> createState() => _TestStripeState();
// }

// class _TestStripeState extends State<TestStripe> {
//   Map<String, dynamic>? paymentIntent;
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextButton(
//               child: const Text('Buy Now'),
//               onPressed: () async {
//                 await makePayment();
//               },
//             ),
//           ],
//         ),
//     );
//   }

//   Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent('10000', 'GBP');

//       var gpay = PaymentSheetGooglePay(merchantCountryCode: "GB",
//           currencyCode: "GBP",
//           testEnv: true);

//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: paymentIntent![
//               'client_secret'], //Gotten from payment intent
//               style: ThemeMode.light,
//               merchantDisplayName: 'Abhi',
//               googlePay: gpay))
//           .then((value) {});

//       //STEP 3: Display Payment sheet
//       displayPaymentSheet();
//     } catch (err) {
//       print(err);
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         print("Payment Successfully");
//       });
//     } catch (e) {
//       print('$e');
//     }
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount, 
//         'currency': currency,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer sk_test_51P0KVJP8OZat8l3pyY11Izejt8aGn9qzwyDAcqgMv2XVXphxMO3bJf9ihuKHYUsK6gAsI0PBzxSLirDeJP60DEPm00SBnX0Aqi',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
// }


import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/material.dart';

class TestTensorFlow extends StatefulWidget {
  const TestTensorFlow({super.key});

  @override
  State<TestTensorFlow> createState() => _TestTensorFlowState();
}

class _TestTensorFlowState extends State<TestTensorFlow> {
  List? _outputs;
  File? _image;
  bool? _loading = false;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0, 
        imageStd: 255.0, 
        numResults: 2, 
        threshold: 0.2, 
        asynch: true
        );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
  pickImage() async {
  var image = await _picker.pickImage(source: ImageSource.gallery);
  if (image == null) return;
  setState(() {
    _loading = true;
    _image = File(image.path); // Chuyển đổi XFile sang File đúng cách
  });
  classifyImage(_image!); // Gọi classifyImage với kiểu File đã đúng
}
  // pickImage() async {
  //   var image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return null;
  //   setState(() {
  //     _loading = true;
  //     _image = image as XFile;
  //   });
  //   classifyImage(_image as File);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Tensorflow Lite",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading! ? Container(
              height: 300,
              width: 300,
            ): 
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? Container() : Image.file(_image! as File),
                  SizedBox(
                    height: 20,
                  ),
                  _image == null ? Container() : _outputs != null ? 
                  Text(_outputs![0]["label"],style: TextStyle(color: Colors.black,fontSize: 20),
                  ) : Container(child: Text(""))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FloatingActionButton(
              tooltip: 'Pick Image',
              onPressed: pickImage,
              child: Icon(Icons.add_a_photo,
              size: 20,
              color: Colors.white,
              ),
              backgroundColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
// import 'dart:math' show cos, sqrt, asin;
// import 'package:http/http.dart' as http ;
// class TestNoti extends StatefulWidget {
//   const TestNoti({super.key});

//   @override
//   State<TestNoti> createState() => _TestNotiState();
// }


// class _TestNotiState extends State<TestNoti> {
//   String _location = 'Đang tìm vị trí...';
//   Future<void> _determinePosition() async {
//   try {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print("Vị trí: ${position.latitude}, ${position.longitude}");

//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks.first;
//     setState(() {
//       _location = '${place.locality}, ${place.country}';
//     });
//     print("Địa điểm: $_location");
//   } catch (e) {
//     print("Lỗi khi lấy vị trí hoặc địa điểm: $e");
//     setState(() {
//       _location = "Không thể lấy được địa điểm.";
//     });
//   }
// }

// Future<void> requestLocationPermission() async {
//   var status = await Permission.location.request();
//   if (status.isGranted) {
//     print("Quyền truy cập vị trí đã được cấp.");
//     _determinePosition();
//   } else if (status.isDenied) {
//     print("Quyền truy cập vị trí bị từ chối.");
//   } else if (status.isPermanentlyDenied) {
//     print("Quyền truy cập vị trí bị từ chối vĩnh viễn. Mở cài đặt.");
//     openAppSettings();
//   }
// }
// // double calculateDistance(lat1, lon1, lat2, lon2) {
// //   var p = 0.017453292519943295;
// //   var c = cos;
// //   var a = 0.5 - c((lat2 - lat1) * p)/2 + 
// //           c(lat1 * p) * c(lat2 * p) * 
// //           (1 - c((lon2 - lon1) * p))/2;
// //   return 12742 * asin(sqrt(a));
// // }
// // Future<void> fetchNearbyLocations() async {
// //     final response = await http.get();
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         nearbyLocations = json.decode(response.body);
// //       });
// //     } else {
// //       throw Exception('Failed to load nearby locations');
// //     }
// //   }
  
// //   Future<void> showSortedLocations(double latitude, double longitude) async {
// //   // Lấy vị trí hiện tại
// //   Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

// //   // Lấy dữ liệu từ server
// //   List<Pos> allPositions = await fetchallDashboardData();

// //   // Tính toán khoảng cách và thêm vào mỗi đối tượng Pos
// //   for (var pos in allPositions) {
// //   pos.setDistanceFromCurrent(
// //     currentPosition.latitude,
// //     currentPosition.longitude,
// //   );
// // }

// //   // Sắp xếp danh sách dựa trên khoảng cách
// //   allPositions.sort((a, b) => a.distanceFromCurrent!.compareTo(b.distanceFromCurrent!));

// //   // Hiển thị danh sách ra màn hình hoặc xử lý tiếp theo nhu cầu của bạn
// //   for (var pos in allPositions) {
// //     //print('${pos.name}: ${pos.distanceFromCurrent} km');
// //   }

// //   // Cập nhật UI ở đây nếu cần
// //   setState(() {
// //     // Cập nhật danh sách địa điểm đã sắp xếp trên UI
// //   });
// // }

//   @override
//   void initState() {
    
//     // TODO: implement initState
//     super.initState();

//   }
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   Uint8List? _imageData;
//   String? _base64Image;

//   Future<void> _pickImage() async {
//     final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       Uint8List imageBytes = await File(pickedImage.path).readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//       setState(() {
//         _imageData = imageBytes;
//         _base64Image = base64Image;
//       });
//       print(base64Image);
//     }
//   }

//   Uint8List base64ToUint8List(String base64String) {
//     return base64Decode(base64String);
//   }

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child:FloatingActionButton(
//         onPressed: _pickImage,
//         tooltip: 'Pick Image from Gallery',
//         child: Icon(Icons.photo_library),
//       ),
//       ),
//     );
//   }
// }
