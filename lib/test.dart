// import 'dart:convert';
// import 'package:flutter/material.dart';
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