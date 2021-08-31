import 'package:flutter/material.dart';

class SimpleButton extends StatefulWidget {
  const SimpleButton({
    this.text = '我是按钮',
    this.onTap,
    this.width = 240,
    this.height = 48,
    Key? key,
  }) : super(key: key);

  final String text;
  final void Function()? onTap;
  final double width;
  final double height;

  @override
  State<SimpleButton> createState() => _SimpleButtonState();
}

class _SimpleButtonState extends State<SimpleButton> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap ??
          () {
            setState(() {
              _count++;
            });
          },
      child: Container(
        alignment: Alignment.center,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(widget.height / 2)),
        ),
        padding: EdgeInsets.symmetric(horizontal: widget.height / 2),
        margin: EdgeInsets.symmetric(vertical: widget.height / 2),
        child: Text(
          _count > 0 ? '你点击了$_count次按钮' : widget.text,
          style: TextStyle(
            fontSize: widget.height / 3,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
