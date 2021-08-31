import 'package:flutter/material.dart';

import 'pages/global_page.dart';
import 'pages/multi_page.dart';
import 'pages/single_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoHideKeyboard',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('AutoHideKeyboard'),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(text: 'global'),
            Tab(text: 'single'),
            Tab(text: 'multi'),
          ]),
        ),
        body: TabBarView(children: [
          GlobalPage(),
          SinglePage(),
          MultiPage(),
        ]),
      ),
    );
  }
}
