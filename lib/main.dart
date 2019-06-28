import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/daily_share.dart';

import 'package:flutter_demo/ui/radom_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome to Flutter',
        theme: new ThemeData(
          primarySwatch: Colors.green,
        ),
        home: new Home(),
        routes: {
          RandomWords.sName: (context) => new RandomWords(),
        });
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    new RandomWords(), new DailyShareListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Home',
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _children,),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance),
            title: new Text("list")
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance_wallet),
            title: new Text("share")
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) => {
          setState(() {
            _currentIndex = index;
          })
        },
      ),
    );
  }
}
