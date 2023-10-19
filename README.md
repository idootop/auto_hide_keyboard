# auto_hide_keyboard

Automatically hides the keyboard when tapping outside the TextField.

## 🔥 Preview

![](demo.gif)

## ✨ Highlights

- **🔮 Magic**: Simultaneously responds to click events of other widgets on the same page and automatically hides the keyboard.
- 🔢 Supports multiple TextFields on a single page without interference.
- 📋 Does not affect the original selection, copy, and paste functionality of TextFields.

Try it online: [https://flutter-auto-hide-keyboard.vercel.app](https://flutter-auto-hide-keyboard.vercel.app)

## ⚡️ Get started

Simply wrap your `TextField` with the `AutoHideKeyboard`.

```dart
AutoHideKeyboard(
  child: TextField(), // Your TextField widget
)
```

That's it!

Inspired by `Tooltip`.
