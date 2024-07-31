import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newbad/Service/config.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;

class DanhGiasanPage extends StatefulWidget {
  const DanhGiasanPage({super.key, required this.courtId, required this.courtName});
  final String courtId;
  final String courtName;

  @override
  State<DanhGiasanPage> createState() => _DanhGiasanPageState();
}

class _DanhGiasanPageState extends State<DanhGiasanPage> {
  List? _outputs;
  File? _image;
  bool? _loading = false;
  String? _displayedLabel;
 // This joins back the rest of the parts excluding the first one
 void updateLabel() {
  if (_outputs != null && _outputs!.isNotEmpty && _outputs![0].containsKey("label")) {
    String output = _outputs![0]["label"];
    List<String> parts = output.split(' ');
    String label = parts.sublist(1).join(' '); // Assumes label is always after the first space

    setState(() {
      _displayedLabel = label; // _displayedLabel should be a state variable
    });
  }
}


  final ImagePicker _picker = ImagePicker();
  TextEditingController addcomment = TextEditingController();
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
 shotImage() async {
  var image = await _picker.pickImage(source: ImageSource.camera);
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
  void newdanhgia(String message) async {
      var regBody = {
        "courtId": widget.courtId,
        "message": message
      };
      
      var response = await http.post(Uri.parse(newDanhgia),
      body: jsonEncode(regBody),
      headers: {"Content-Type":"application/json"}
      );
      var jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status']) {
        print('Response: $jsonResponse');
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
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,
        color: Colors.white,)),
        title: Text(
          "Đánh giá sân",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    Text(_outputs![0]["label"].split(' ').sublist(1).join(' '),style: TextStyle(color: Colors.black,fontSize: 20),
                    ) : Container(child: Text("")),
        
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(width: 10,),
                  FloatingActionButton(
                tooltip: 'Pick Image',
                onPressed: pickImage,
                child: Icon(Icons.photo,
                size: 20,
                color: Colors.white,
                ),
                backgroundColor: Colors.green,
              ),
              SizedBox(width: 10,),
                  Container(
                    width: 250,
                    child: _inputField('Đánh giá sân ở đây', addcomment )),
              //SizedBox(width: 10,),
              IconButton(onPressed: (){
                updateLabel();
                if (_image != null) {
                   newdanhgia('Có ai đó đã đánh giá sân của bạn là ${addcomment.text} và nhận xét rằng ${_displayedLabel}');
                } else {
                  newdanhgia('Có ai đó đã đánh giá sân của bạn là ${addcomment.text}');
                }
               showDialog(context: context, builder: ( (context) {
                              return AlertDialog(
                                iconColor: Colors.green,
                                backgroundColor: Colors.white,
                                title: Text("Cảm ơn bạn đã gửi đánh giá cho chúng tôi",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400
                                ),),
                                actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Đóng"))],
                              );
                            }));
                            addcomment.clear();
              }, icon: Icon(Icons.send_rounded,
              color: Colors.green,
              size: 40,))
                ],
              ),
              SizedBox(height: 20,),
              // ElevatedButton(onPressed: (){
              //   updateLabel();
              //   newdanhgia('Có ai đó đã đánh giá sân của bạn là ${addcomment.text} và nhận xét rằng ${_displayedLabel}');
              // },
              // style: ButtonStyle(
              //   backgroundColor: MaterialStatePropertyAll(Colors.green)
              // ),
              //  child: Text('Thêm đánh giá',
              //  style: TextStyle(
              //   color: Color(0xFF0D2D3A)
              //  ),)),
            ],
          ),
        ),
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