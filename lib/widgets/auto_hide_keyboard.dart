import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'global_touch.dart';

class AutoHideKeyBoard extends StatefulWidget {
  ///点击空白处自动隐藏键盘
  ///
  ///你可以通过设置 padding 调整输入框范围
  ///
  ///AutoHideKeyBoard.padding = EdgeInsets.all(48);
  AutoHideKeyBoard({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;
  static EdgeInsets padding = EdgeInsets.all(48);

  static final Set<String> _visibleInputs = {};
  static final Map<String, BuildContext> _inputContexts = {};

  static void _onVisibilityChanged(String id, bool isShow) {
    if (isShow) {
      _visibleInputs.add(id);
    } else {
      _visibleInputs.remove(id);
    }
  }

  static void _addInputContext(String id, BuildContext context) {
    _inputContexts[id] = context;
  }

  static void _removeInputContext(String id) {
    _inputContexts.remove(id);
  }

  static bool _shouldHideKeyboard(
    BuildContext context,
    String id,
    PointerEvent event,
  ) {
    bool tapInside(BuildContext context, PointerEvent event) {
      final randerObject = context.findRenderObject();
      if (randerObject is RenderBox) {
        final box = randerObject;
        final target = box.localToGlobal(Offset.zero) & box.size;
        //扩大输入框区域，防止长按复制粘贴时，点击收起键盘
        final newTarget = padding.inflateRect(target);
        return newTarget.contains(event.position);
      }
      return false;
    }

    // 查询当前页面可见的Input组件
    final inputContexts =
        _visibleInputs.map((id) => _inputContexts[id]!).toList();
    return !inputContexts.any((e) => tapInside(e, event));
  }

  @override
  State<AutoHideKeyBoard> createState() => _AutoHideKeyBoardState();
}

int _id = 0;
String _getId() => (_id++).toString();

class _AutoHideKeyBoardState extends State<AutoHideKeyBoard> {
  final String _id = _getId();
  final Key _key = UniqueKey();

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    var isShow = visibilityInfo.visibleFraction > 0;
    AutoHideKeyBoard._onVisibilityChanged(_id, isShow);
  }

  @override
  void initState() {
    super.initState();
    AutoHideKeyBoard._addInputContext(_id, context);
  }

  @override
  void dispose() {
    AutoHideKeyBoard._removeInputContext(_id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalTouch(
      onPanDown: (event, inSide) {
        if (!inSide &&
            AutoHideKeyBoard._shouldHideKeyboard(
              context,
              _id,
              event,
            )) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: VisibilityDetector(
        key: _key,
        onVisibilityChanged: _onVisibilityChanged,
        child: widget.child,
      ),
    );
  }
}
