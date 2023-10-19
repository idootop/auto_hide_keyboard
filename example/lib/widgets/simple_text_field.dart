import 'package:flutter/material.dart';

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    this.hint = 'Please enter...',
    this.focusNode,
    this.width = 240,
    this.height = 48,
    Key? key,
  }) : super(key: key);

  final String hint;
  final FocusNode? focusNode;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(height / 2)),
      ),
      padding: EdgeInsets.symmetric(horizontal: height / 2),
      child: TextField(
        textAlign: TextAlign.center,
        focusNode: focusNode,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: height / 3,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: height / 3,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        cursorColor: Colors.black,
      ),
    );
  }
}
