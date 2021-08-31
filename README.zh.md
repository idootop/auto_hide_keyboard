# auto_hide_keyboard

一个在Flutter中点击空白处自动收起软键盘的示例。

## 🌍 在线预览

打开网页查看效果 👉  [网页链接](https://killer-1255480117.cos.ap-chongqing.myqcloud.com/web/autoHideKeyboard/index.html)

## 💡 使用方法

### 场景一：全局监听点击事件自动隐藏键盘

使用`AutoHideKeyBoard.global`包裹住整个页面

```dart
class YourPage extends StatelessWidget {
  const YourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoHideKeyBoard.global(
      child: ..., ///something with TextField
    );
  }
}
```

缺陷：

如果在输入框聚焦键盘弹起的状态下，再点击输入框区域，

此时已经弹起的键盘会先收下去，然后重新弹出来。

*详见:*

* `lib/pages/global_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.global`

### 场景二：页面中只有一个输入框

使用`AutoHideKeyBoard.single`包裹住输入框

```dart
class YourPage extends StatelessWidget {
  const YourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [ 
                AutoHideKeyBoard.single(
                    child: TextField(),
                ),
                ..., //something
            ],
        ),
    );
  }
}
```

缺陷：

如果页面中有多个输入框，在一个输入框聚焦键盘弹起的状态下，再点击这个输入框所在的区域，

此时已经弹起的键盘会先收下去，然后重新弹出来。

*详见:*

* `lib/pages/single_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.single`

### 场景三：页面中有多个输入框

使用`AutoHideKeyBoard.multi`包裹住输入框

```dart
class YourPage extends StatelessWidget {
  const YourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [ 
                AutoHideKeyBoard.multi(
                    tag: 'Page1',
                    child: TextField(),
                ),
                AutoHideKeyBoard.multi(
                    tag: 'Page1',
                    child: TextField(),
                ),
                ..., //something
            ],
        ),
    );
  }
}
```

*详见:*

* `lib/pages/multi_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.multi`


