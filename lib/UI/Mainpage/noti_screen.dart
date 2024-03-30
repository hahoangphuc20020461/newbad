import 'package:flutter/material.dart';

class NotifycationPage extends StatefulWidget {
  const NotifycationPage({super.key});

  @override
  State<NotifycationPage> createState() => _NotifycationPageState();
}

class _NotifycationPageState extends State<NotifycationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        
      ),
      body: ListView.builder(
        itemCount: 10, // replace with your actual number of notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              // Add notification icon or image
              backgroundImage: NetworkImage('your_image_url_here'),
            ),
            title: Text('Người dùng đã nhắc đến bạn'), // Replace with actual data
            subtitle: Text('1 giờ trước'), // Replace with actual data
            trailing: IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Handle more action
              },
            ),
          );
        },
      ),
    );
  }
}