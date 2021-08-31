import 'package:flutter/material.dart';

import 'global_touch.dart';

void hideKeyBoard() => FocusManager.instance.primaryFocus?.unfocus();

enum AutoHideKeyBoardType {
  ///全局监听点击事件
  global,

  ///适合一个页面中只有一个输入框的情况
  single,

  ///适合一个页面中有多个输入框的情况
  multi,
}

///点击空白处自动隐藏键盘
class AutoHideKeyBoard extends StatefulWidget {
  AutoHideKeyBoard._(
    this._type, {
    required this.child,
    this.tag,
    Key? key,
  }) : super(key: key);

  factory AutoHideKeyBoard({
    required Widget child,
    String tag = 'default',
  }) =>
      AutoHideKeyBoard.multi(
        tag: tag,
        child: child,
      );

  ///包裹住整个页面
  ///
  ///此模式有一个缺陷，当点击输入框时会先收起键盘，然后重新唤起焦点
  ///
  ///推荐使用[AutoHideKeyBoard.single]或[AutoHideKeyBoard.multi]
  factory AutoHideKeyBoard.global({required Widget child}) =>
      AutoHideKeyBoard._(
        AutoHideKeyBoardType.global,
        child: child,
      );

  ///包裹住输入框
  ///
  ///适合一个页面中只有一个输入框的情况
  factory AutoHideKeyBoard.single({required Widget child}) =>
      AutoHideKeyBoard._(
        AutoHideKeyBoardType.single,
        child: child,
      );

  ///包裹住输入框
  ///
  ///适合一个页面中有多个输入框的情况
  factory AutoHideKeyBoard.multi(
          {required Widget child, String tag = 'default'}) =>
      AutoHideKeyBoard._(
        AutoHideKeyBoardType.multi,
        tag: tag,
        child: child,
      );

  final AutoHideKeyBoardType _type;
  final Widget child;
  final String? tag;
  static final Map<String, List<BuildContext>> _multiInputContext = {};

  static void setInputContext(String tag, BuildContext context) {
    if (_multiInputContext[tag] == null) {
      _multiInputContext[tag] = [];
    }
    _multiInputContext[tag]!.add(context);
  }

  static void removeInputContext(String tag, BuildContext context) {
    _multiInputContext[tag]!.remove(context);
    if (_multiInputContext[tag]!.isEmpty) {
      _multiInputContext.remove(tag);
    }
  }

  static bool shouldHideKeyboard(
    BuildContext context,
    String tag,
    PointerEvent event,
  ) {
    bool tapInside(BuildContext context, PointerEvent event) {
      final randerObject = context.findRenderObject();
      if (randerObject is RenderBox) {
        final box = randerObject;
        final target = box.localToGlobal(Offset.zero) & box.size;
        return target.contains(event.position);
      }
      return false;
    }

    final _multiInputContexts = _multiInputContext[tag]!;
    return !_multiInputContexts.any((e) => e != context && tapInside(e, event));
  }

  @override
  State<AutoHideKeyBoard> createState() => _AutoHideKeyBoardState();
}

class _AutoHideKeyBoardState extends State<AutoHideKeyBoard> {
  @override
  void initState() {
    super.initState();
    if (widget._type == AutoHideKeyBoardType.multi) {
      AutoHideKeyBoard.setInputContext(widget.tag!, context);
    }
  }

  @override
  void dispose() {
    if (widget._type == AutoHideKeyBoardType.multi) {
      AutoHideKeyBoard.removeInputContext(widget.tag!, context);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AutoHideKeyBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._type == AutoHideKeyBoardType.multi) {
      AutoHideKeyBoard.removeInputContext(oldWidget.tag!, context);
    }
    if (widget._type == AutoHideKeyBoardType.multi) {
      AutoHideKeyBoard.setInputContext(widget.tag!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._type) {
      case AutoHideKeyBoardType.global:
        return GlobalTouch(
          onPanDown: (_, __) => hideKeyBoard(),
          child: widget.child,
        );
      case AutoHideKeyBoardType.single:
        return GlobalTouch(
          onPanDown: (_, inSide) {
            if (!inSide) hideKeyBoard();
          },
          child: widget.child,
        );
      case AutoHideKeyBoardType.multi:
        return GlobalTouch(
          onPanDown: (event, inSide) {
            if (!inSide &&
                AutoHideKeyBoard.shouldHideKeyboard(
                  context,
                  widget.tag!,
                  event,
                )) {
              hideKeyBoard();
            }
          },
          child: widget.child,
        );
      default:
        return widget.child;
    }
  }
}
