
import 'package:flutter/material.dart';
import 'package:newbad/UI/Mainpage/home_screen.dart';
import 'package:newbad/UI/Mainpage/noti_screen.dart';
import 'package:newbad/UI/Mainpage/rentcourt_screen.dart';
import 'package:newbad/UI/User/account_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key, required this.token});
  final token;

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int _bottomNavIndex = 0;
  late PageController pageController;
  List<Widget> listpage = [HomePage(), RentCourtPage(), NotifycationPage(), AccountPage(title: '')];

   @override
  void initState() {
    
    //_checkLocationPermission();
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);

    late String username = jwtDecodeToken['username'];
  pageController = PageController();
  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        
        currentIndex: _bottomNavIndex,
        onTap: (i) {
          setState(() {
            _bottomNavIndex = i;
            pageController.jumpToPage(i);
          });
        },
        items: [SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Trang chủ"),
              selectedColor: Color(0xFF388E3C),
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.bookmark_add_rounded),
              title: Text("Sân Thuê"),
              selectedColor: Color(0xFF388E3C),
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Thông báo"),
              selectedColor: Color(0xFF388E3C),
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Trang cá nhân"),
              selectedColor: Color(0xFF388E3C),
            ),]),
            body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (index){
              setState(() {
                _bottomNavIndex = index;
              });
            },
            children: listpage
          ),
    );
  }
}