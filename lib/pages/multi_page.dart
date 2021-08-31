import 'package:flutter/material.dart';
import '../widgets/auto_hide_keyboard.dart';
import '../widgets/simple_button.dart';
import '../widgets/simple_text_field.dart';

class MultiPage extends StatelessWidget {
  const MultiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoHideKeyBoard.multi(
            tag: 'Page1',
            child: SimpleTextField(
              hint: '我是输入框1',
            ),
          ),
          AutoHideKeyBoard.multi(
            tag: 'Page1',
            child: SimpleTextField(
              hint: '我是输入框2',
            ),
          ),
          SimpleButton(),
        ],
      ),
    );
  }
}
