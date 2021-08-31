import 'package:flutter/material.dart';
import '../widgets/auto_hide_keyboard.dart';
import '../widgets/simple_button.dart';
import '../widgets/simple_text_field.dart';

class SinglePage extends StatelessWidget {
  const SinglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoHideKeyBoard.single(
            child: SimpleTextField(hint: '我是输入框'),
          ),
          SimpleButton(),
        ],
      ),
    );
  }
}
