import 'package:flutter/material.dart';

import 'pages/multi_page.dart';
import 'pages/single_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoHideKeyboard',
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(() => {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Page2(),
            ),
          )
        });
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(() => {Navigator.pop(context)});
  }
}

class Home extends StatelessWidget {
  Home(this.onClick);
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: onClick,
            child: Text('AutoHideKeyboard'),
          ),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(text: 'single'),
            Tab(text: 'multi'),
          ]),
        ),
        body: TabBarView(children: [
          SinglePage(),
          MultiPage(),
        ]),
      ),
    );
  }
}
