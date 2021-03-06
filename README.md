# auto_hide_keyboard

An example of automatically retracting the soft keyboard in Flutter by clicking on a blank space. 

[中文文档请戳这里](README.zh.md)

## 🌍 Preview

Web demo 👉   [Click Here](https://killer-1255480117.cos.ap-chongqing.myqcloud.com/web/autoHideKeyboard/index.html)

## 💡 Usage

### Case1：Listen to global pointer events to automatically hide the keyboard

Wrap the entire page with `AutoHideKeyBoard.global`

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

Disadvantages:

If you click on the TextField area again while the TextField in focus and keyboard is popped up, 

the keyboard will be retracted and then popped up again.

*For more information, see:*

* `lib/pages/global_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.global`

### Case2：Only one TextField on the page

Wrap the TextField with `AutoHideKeyBoard.single`

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

Disadvantages:

If there are more than one TextField on the page, click on the TextField area again while the TextField  in focus and keyboard is popped up, the keyboard will be retracted and then popped up again.

*For more information, see:*

* `lib/pages/single_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.single`

### Case3：More than one TextField on the page

Wrap the TextField with `AutoHideKeyBoard.multi`

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

*For more information, see:*

* `lib/pages/multi_page.dart`
* `lib/widgets/auto_hide_keyboard.dart#AutoHideKeyBoard.multi`


