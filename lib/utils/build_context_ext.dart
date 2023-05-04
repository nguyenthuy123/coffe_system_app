import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  get height => MediaQuery.of(this).size.height;
  get width => MediaQuery.of(this).size.width;

  showSnackBar(String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  push(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  pop(dynamic result) {
    return Navigator.of(this).pop(result);
  }
}
