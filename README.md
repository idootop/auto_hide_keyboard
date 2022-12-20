# auto_hide_keyboard

An example of automatically retracting the soft keyboard in Flutter by clicking on a blank space. 


## 💡 Usage

```yaml
dependencies:
  # ...
  auto_hide_keyboard:
    git:
      url: https://github.com/idootop/auto_hide_keyboard.git
```

```dart
import 'auto_hide_keyboard/auto_hide_keyboard.dart';

class YourPage extends StatelessWidget {
  const YourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoHideKeyBoard(
      child: ..., // Your TextField Widget
    );
  }
}
```