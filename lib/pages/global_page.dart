import 'package:flutter/material.dart';
import '../widgets/auto_hide_keyboard.dart';
import '../widgets/simple_button.dart';
import '../widgets/simple_text_field.dart';

class GlobalPage extends StatelessWidget {
  const GlobalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoHideKeyBoard.global(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SimpleTextField(hint: '我是输入框'),
            SimpleButton(),
          ],
        ),
      ),
    );
  }
}
