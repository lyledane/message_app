import 'package:flutter/material.dart';
import 'package:message_app/screens/chat_list.dart';
import 'package:message_app/screens/mentions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> bodies = [
      ChatList(),
      Mentions(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('UserName')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('UserName'),
              onTap: () {},
            ),
            Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(color: Colors.amberAccent)),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('New Direct Message'),
              onTap: () {
                Navigator.pushNamed(context, '/Messages');
              },
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('New Group'),
              onTap: () {
                Navigator.pushNamed(context, '/NewGroup');
              },
            )
          ],
        ),
      ),
      body: bodies.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.alternate_email), label: 'Mentions'),
        ],
        selectedItemColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
