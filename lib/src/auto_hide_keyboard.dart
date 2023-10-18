import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'global_pointer_listener.dart';

typedef _Input = (BuildContext, EdgeInsets?);

class AutoHideKeyboard extends StatefulWidget {
  /// Automatically hides the keyboard when tapping outside the TextField.
  ///
  /// Simply wrap your `TextField` with the `AutoHideKeyboard`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// AutoHideKeyboard(
  ///   child: TextField(), // Your TextField widget
  /// )
  /// ```
  /// 
  /// That's it! 
  /// 
  /// Inspired by [Tooltip].
  AutoHideKeyboard({
    super.key,
    required this.child,
    this.safePadding,
  });

  final Widget child;
  final EdgeInsets? safePadding;
  static EdgeInsets defaultSafePadding = const EdgeInsets.all(48);

  static int _id = 0;
  static String _getId() => (_id++).toString();
  static final Set<String> _visibleInputs = {};
  static final Map<String, _Input> _inputs = {};

  static void _addInput(String id, _Input input) {
    _inputs[id] = input;
  }

  static void _removeInput(String id) {
    _inputs.remove(id);
  }

  static void _onVisibilityChanged(String id, bool visible) {
    if (visible) {
      _visibleInputs.add(id);
    } else {
      _visibleInputs.remove(id);
    }
  }

  static bool _shouldHideKeyboard(
    BuildContext context,
    String id,
    PointerEvent event,
  ) {
    bool isTapInside(_Input input, PointerEvent event) {
      var (context, safePadding) = input;
      safePadding ??= AutoHideKeyboard.defaultSafePadding;
      final randerObject = context.findRenderObject();
      if (randerObject is RenderBox) {
        final box = randerObject;
        final target = randerObject.localToGlobal(Offset.zero) & box.size;
        final safeTarget = safePadding.inflateRect(target);
        return safeTarget.contains(event.position);
      }
      return false;
    }

    final inputs = _visibleInputs.map((id) => _inputs[id]!).toList();
    return !inputs.any((e) => isTapInside(e, event));
  }

  @override
  State<AutoHideKeyboard> createState() => _AutoHideKeyboardState();
}

class _AutoHideKeyboardState extends State<AutoHideKeyboard> {
  final Key _key = UniqueKey();
  final String _id = AutoHideKeyboard._getId();

  @override
  void initState() {
    super.initState();
    AutoHideKeyboard._addInput(_id, (context, widget.safePadding));
  }

  @override
  void dispose() {
    AutoHideKeyboard._removeInput(_id);
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    var visible = visibilityInfo.visibleFraction > 0;
    AutoHideKeyboard._onVisibilityChanged(_id, visible);
  }

  @override
  Widget build(BuildContext context) {
    return GlobalPointerListener(
      onPanDown: (event, inside) {
        if (!inside &&
            AutoHideKeyboard._shouldHideKeyboard(context, _id, event)) {
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
