import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:flutter/material.dart';

class DanhGiasanPage extends StatefulWidget {
  const DanhGiasanPage({super.key});

  @override
  State<DanhGiasanPage> createState() => _DanhGiasanPageState();
}

class _DanhGiasanPageState extends State<DanhGiasanPage> {
  List? _outputs;
  File? _image;
  bool? _loading = false;
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
            Row(
              children: [
                FloatingActionButton(
                  tooltip: 'Shot Image',
                  onPressed: shotImage,
                  child: Icon(Icons.add_a_photo,
                  size: 20,
                  color: Colors.white,
                  ),
                  backgroundColor: Colors.amber,
                ),
                FloatingActionButton(
                  tooltip: 'Pick Image',
                  onPressed: pickImage,
                  child: Icon(Icons.photo,
                  size: 20,
                  color: Colors.white,
                  ),
                  backgroundColor: Colors.amber,
                ),
                SizedBox(height: 20,),
                _inputField('Đánh giá sân ở đây', addcomment )
              ],
            ),
          ],
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