import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.title});

  final String title;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const Color kbackgroundColor = Color(0xFFf1f1f1);
  static const Color kbackgroundAppbar = Color.fromARGB(255, 123, 51, 25);
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              //alignment: Alignment.bottomCenter,
              children: [
                // Background for the top part of the profile
                Container(
                  height: 250,
                  color: Colors.orangeAccent,
                ),
                // Profile image
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 205, 0, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        'https://via.placeholder.com/150', // Replace with the actual image link
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Positioned widget can be used for icons on the top right
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left:24),
              child: Row(
                children: [
                  Text(
                    'Username',
                    
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 12,),
            Divider(thickness: 2,),
            Padding(
              padding: const EdgeInsets.only(left:22),
              child: Row(
                children: [
                  Text("Thông tin cá nhân",
                  style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),),
                          SizedBox(width:5,),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit, color: Colors.orange),
                            
                          ),
                ],
              ),
            ),
           
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('0xxxxxxx'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Hà hoàng phúc'),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.recent_actors),
              title: Text('Sân đã thuê'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.recent_actors),
              title: Text('Sân đã thuê'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              trailing: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}