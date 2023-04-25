import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  get height => MediaQuery.of(this).size.height;
  get width => MediaQuery.of(this).size.width;
}
