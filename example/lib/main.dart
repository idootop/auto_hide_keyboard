import 'package:example/widgets/simple_button.dart';
import 'package:example/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:auto_hide_keyboard/auto_hide_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AutoHideKeyboard'),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Tab(text: 'Single'),
            Tab(text: 'Multi'),
          ]),
        ),
        body: const TabBarView(children: [
          SinglePage(),
          MultiPage(),
        ]),
      ),
    );
  }
}

class SinglePage extends StatelessWidget {
  const SinglePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoHideKeyboard(
            child: const SimpleTextField(hint: 'TextField 0'),
          ),
          const SimpleButton(),
        ],
      ),
    );
  }
}

class MultiPage extends StatelessWidget {
  const MultiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoHideKeyboard(
            child: const SimpleTextField(
              hint: 'TextField 1',
            ),
          ),
          Container(height: 24),
          AutoHideKeyboard(
            child: const SimpleTextField(
              hint: 'TextField 2',
            ),
          ),
          const SimpleButton(),
        ],
      ),
    );
  }
}
