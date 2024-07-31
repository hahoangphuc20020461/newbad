import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:image_picker/image_picker.dart';
import 'package:newbad/Model/dashboard.dart';
import 'package:newbad/Service/config.dart';
class AddCourtPage extends StatefulWidget {
  const AddCourtPage({super.key, required this.useradminId});
  final String useradminId;

  @override
  State<AddCourtPage> createState() => _AddCourtPageState();
}

class _AddCourtPageState extends State<AddCourtPage> {
  TextEditingController tensan = TextEditingController();
  TextEditingController tenchusan =TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController location =TextEditingController();
  TextEditingController linkvitri = TextEditingController();
  TextEditingController soluongsan = TextEditingController();
  //late String useradminId;
  bool isnotValidate = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  XFile? _image2;
  List<DashBoardforAdmin> item = [];
  bool _isImagePicked = false;
  //soluongsan.text.split(',').map((item) => item.trim()).toList();

  void addCourt() async {
    String base64Image = base64Encode(File(_image!.path).readAsBytesSync());
    String base64Image2 = base64Encode(File(_image2!.path).readAsBytesSync());
    //String fileName = _image!.path.split("/").last;
    List<String> soluongSanArray = soluongsan.text.split(',').map((e) => e.trim()).toList();
    if (tensan.text.isNotEmpty && tenchusan.text.isNotEmpty &&
     phonenumber.text.isNotEmpty && location.text.isNotEmpty && linkvitri.text.isNotEmpty) {
      var regBody = {
        "useradminId": widget.useradminId,
        "name" : tensan.text,
        "nameofpeople": tenchusan.text,
        "phonenumber": phonenumber.text,
        "location": location.text,
        "image": base64Image,
        "linklocation": linkvitri.text,
        "soluongsan": soluongSanArray,
        "model2d": base64Image2
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
  void _clearTextField() {
    // Sử dụng phương thức clear để xóa text
    tensan.clear();
    tenchusan.clear();
    phonenumber.clear();
    location.clear();
    linkvitri.clear();
    soluongsan.clear();
    _image = null;

  }

   Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
      _isImagePicked = true;
      if(_image != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hình ảnh đã tải lên'),
                        backgroundColor: Color(0xFF388E3C),
                        )
                      );
                      }
    });
  }
  Future<void> _pickImage2() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image2 = pickedImage;
      if(_image2 != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hình ảnh đã tải lên'),
                        backgroundColor: Color(0xFF388E3C),
                        )
                      );
                      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,
        color: Colors.white,), onPressed: () { 
          Navigator.pop(context,true);
         },),
        backgroundColor: Colors.green,
        title: Text('Thêm sân',
        style: TextStyle(color: Colors.white, fontSize: 25),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Container(
          
            width: MediaQuery.of(context).size.width-40,
            child: Column(
              
              children: [
                SizedBox(height: 30,),
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
                    ),
                     if (_image != null && _isImagePicked == true)
                            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Đã chọn ảnh',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
                  
                    Row(
                      children: [
                        Text("Thêm mô hình sân của bạn"),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          _pickImage2();
                        }, icon: Icon(Icons.photo)),
                      ],
                    ),
                    if (_image2 != null)
                            Text(
                              'Đã chọn ảnh',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30,),
                    Center(
                      child: Container(
                        width: 100,
                        child: FloatingActionButton(onPressed: (){
                          addCourt();
                            _clearTextField();
                        },
                        child: Text('Thêm',
                        style: TextStyle(
                          color: Colors.white
                        ),),
                        backgroundColor: Colors.green,),
                      ),
                    )
              ],
            ),
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