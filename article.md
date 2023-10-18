# Flutter 中点击空白处收起键盘更优雅的解法

## 📖 背景简介

通常我们在 Flutter 中实现点击空白处隐藏键盘的需求时，有以下两种方法：

### 方案一

在整个页面外部包裹一个 GestureDetector

```dart
void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

class SomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: hideKeyboard,
            child: Scaffold(
                body: ..., //something
            ),
        );
    }
}
```

或者全局为所有子页面都包裹一个 GestureDetector

```dart
class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            builder: (context, child) => GestureDetector(
                onTap: hideKeyboard,
                child: child,
            ),
            home: ..., //home page
        );
    }
}
```

**😫 但是这种方案有一个缺陷：**

如果页面中有其他消费点击事件的子组件（如：Button），那么包裹在当前页面最外面的 GestureDetector 将无法响应该点击事件。

为了解决这个问题，比较简单粗暴的一种做法是，为所有的点击事件再调用一次`hideKeyboard()` >\_<

（想想就很刺激...）

```dart
class SomePage extends StatelessWidget {

    void onTapButton(){
        hideKeyboard();
        ... //do something
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: hideKeyboard,
            child: Scaffold(
                body: Column(
                    children: [
                        //点击此按钮的时候，外部GestureDetector的onTap不会响应
                        TextButton(
                            onPressed: onTapButton, //需要再手动调用一次hideKeyboard()
                            child: Text('我是按钮'),
                        ),
                        ... //something
                    ],
                ),
            ),
        );
    }
}
```

### 方案二

针对方案一中的缺陷，我们尝试将包裹在页面外部的 GestureDetector 换成 Listener

```dart
class SomePage extends StatelessWidget {

    void onTapButton(){
        ... //do something
    }

    @override
    Widget build(BuildContext context) {
        return Listener(
            onPointerDown: (_) => hideKeyboard(),
            child: Scaffold(
                body: Column(
                    children: [
                        //点击此按钮的时候，外部Listener的onPointerDown也会响应
                        TextButton(
                            onPressed: onTapButton,
                            child: Text('我是按钮'),
                        ),
                        ... //something
                    ],
                ),
            ),
        );
    }
}
```

OK，现在方案一中的问题似乎已经完美解决了。

**但是**

你有没有发现，如果在输入框聚焦键盘弹起的状态下，再点击输入框区域，

此时已经弹起的键盘会先收下去，然后重新弹出来。

很蛋疼～

## 💡 解决方案

简单分析可知，解决此需求的关键有两点：

1. 响应全局点击事件，且不影响已有组件点击事件的分发响应
2. 获取点击坐标，判断是否命中输入框组件所在区域

### 如何监听全局点击事件，且不影响已有组件点击事件的分发响应

对于第一点，我从 ToolTip 组件的源码中获得了灵感

```dart
class _TooltipState extends State<Tooltip> withSingleTickerProviderStateMixin {
    ...
    void _handlePointerEvent(PointerEvent event) {
        ...
        if (event is PointerUpEvent || event is PointerCancelEvent) {
            _hideTooltip();
        } else if (event is PointerDownEvent) {
            _hideTooltip(immediately: true);
        }
    }

    @override
    void initState() {
        super.initState();
        ...
        // Listen to global pointer events so that we can hide a tooltip immediately
        // if some other control is clicked on.
        GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
    }

    @override
    void dispose() {
        GestureBinding.instance!.pointerRouter.removeGlobalRoute(_handlePointerEvent);
        ...
        super.dispose();
    }
    ...
}
```

可以看到，我们可以在`GestureBinding.instance!.pointerRouter`里注册全局点击事件的回调，

在并且可以从`PointerEvent`里拿到点击的坐标，

至此我们解决了问题的一大半。

接着往下看，如何拿到输入框组件所在的区域？

### 如何获取输入框组件所在的区域，判断点击坐标是否命中

这个问题比较简单，我们可以通过输入框组件的`BuildContext`拿到它的`RenderObject`，

如果这个`RenderObject`是`RenderBox`就可以取到它的`size`，

然后通过`RenderBox.localToGlobal`即可得到输入框组件所在的区域，

> Life is short, show me the code.

话不多说，上代码

```dart
  void _handlePointerEvent(PointerEvent event) {
    final randerObject = context.findRenderObject();
    if (randerObject is RenderBox) {
      final box = randerObject;
      final target = box.localToGlobal(Offset.zero) & box.size;
      final inSide = target.contains(event.position);
      ...
    }
  }
```

## 🌈 组件封装

根据上面的解决方案，我们把其封装成组件，方便使用。

### GlobalPointerListener

用途：监听全局手势，不影响父子组件原有点击事件的分发响应流程

|   参数    |             备注              |
| :-------: | :---------------------------: |
| onPanDown | inSide 表示是否点击在组件内部 |
|  onPanUp  | inSide 表示是否点击在组件内部 |

```dart
///监听全局手势，不影响父子组件原有点击事件的分发响应流程
class GlobalPointerListener extends StatefulWidget {
  final Widget child;
  final Function(PointerEvent event, bool inSide)? onPanDown;
  final Function(PointerEvent event, bool inSide)? onPanUp;
  GlobalPointerListener({required this.child, this.onPanDown, this.onPanUp});
  @override
  _GlobalPointerListenerState createState() => _GlobalPointerListenerState();
}

class _GlobalPointerListenerState extends State<GlobalPointerListener> {
  @override
  void initState() {
    super.initState();
    GestureBinding.instance!.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  @override
  void dispose() {
    GestureBinding.instance!.pointerRouter
        .removeGlobalRoute(_handlePointerEvent);
    super.dispose();
  }

  void _handlePointerEvent(PointerEvent event) {
    final randerObject = context.findRenderObject();
    if (randerObject is RenderBox) {
      final box = randerObject;
      final target = box.localToGlobal(Offset.zero) & box.size;
      final inSide = target.contains(event.position);
      if (event is PointerUpEvent || event is PointerCancelEvent) {
        widget.onPanUp?.call(event, inSide);
      } else if (event is PointerDownEvent) {
        widget.onPanDown?.call(event, inSide);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

### AutoHideKeyboard

用途：点击空白处自动隐藏软键盘

|           模式            |                场景                |      用法      |
| :-----------------------: | :--------------------------------: | :------------: |
| `AutoHideKeyboard.global` |          全局监听点击事件          | 包裹住整个页面 |
| `AutoHideKeyboard.single` | 适合一个页面中只有一个输入框的情况 |  包裹住输入框  |
| `AutoHideKeyboard.multi`  |  适合一个页面中有多个输入框的情况  |  包裹住输入框  |

```dart
void hideKeyBoard() => FocusManager.instance.primaryFocus?.unfocus();

enum AutoHideKeyboardType {
  ///全局监听点击事件
  global,

  ///适合一个页面中只有一个输入框的情况
  single,

  ///适合一个页面中有多个输入框的情况
  multi,
}

///点击空白处自动隐藏键盘
class AutoHideKeyboard extends StatefulWidget {
  AutoHideKeyboard._(
    this._type, {
    required this.child,
    this.tag,
    Key? key,
  }) : super(key: key);

  factory AutoHideKeyboard({
    required Widget child,
    String tag = 'default',
  }) =>
      AutoHideKeyboard.multi(
        tag: tag,
        child: child,
      );

  ///包裹住整个页面
  ///
  ///此模式有一个缺陷，当点击输入框时会先收起键盘，然后重新唤起焦点
  ///
  ///推荐使用[AutoHideKeyboard.single]或[AutoHideKeyboard.multi]
  factory AutoHideKeyboard.global({required Widget child}) =>
      AutoHideKeyboard._(
        AutoHideKeyboardType.global,
        child: child,
      );

  ///包裹住输入框
  ///
  ///适合一个页面中只有一个输入框的情况
  factory AutoHideKeyboard.single({required Widget child}) =>
      AutoHideKeyboard._(
        AutoHideKeyboardType.single,
        child: child,
      );

  ///包裹住输入框
  ///
  ///适合一个页面中有多个输入框的情况
  factory AutoHideKeyboard.multi(
          {required Widget child, String tag = 'default'}) =>
      AutoHideKeyboard._(
        AutoHideKeyboardType.multi,
        tag: tag,
        child: child,
      );

  final AutoHideKeyboardType _type;
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
  State<AutoHideKeyboard> createState() => _AutoHideKeyboardState();
}

class _AutoHideKeyboardState extends State<AutoHideKeyboard> {
  @override
  void initState() {
    super.initState();
    if (widget._type == AutoHideKeyboardType.multi) {
      AutoHideKeyboard.setInputContext(widget.tag!, context);
    }
  }

  @override
  void dispose() {
    if (widget._type == AutoHideKeyboardType.multi) {
      AutoHideKeyboard.removeInputContext(widget.tag!, context);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AutoHideKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._type == AutoHideKeyboardType.multi) {
      AutoHideKeyboard.removeInputContext(oldWidget.tag!, context);
    }
    if (widget._type == AutoHideKeyboardType.multi) {
      AutoHideKeyboard.setInputContext(widget.tag!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._type) {
      case AutoHideKeyboardType.global:
        return GlobalPointerListener(
          onPanDown: (_, __) => hideKeyBoard(),
          child: widget.child,
        );
      case AutoHideKeyboardType.single:
        return GlobalPointerListener(
          onPanDown: (_, inSide) {
            if (!inSide) hideKeyBoard();
          },
          child: widget.child,
        );
      case AutoHideKeyboardType.multi:
        return GlobalPointerListener(
          onPanDown: (event, inSide) {
            if (!inSide &&
                AutoHideKeyboard.shouldHideKeyboard(
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
```

## 🔧 项目地址

更多细节请戳 👉 [网页链接](https://github.com/idootop/auto_hide_keyboard)

## 🌍 在线预览

打开网页查看效果 👉 [网页链接](https://killer-1255480117.cos.ap-chongqing.myqcloud.com/web/AutoHideKeyboard/index.html)
