import 'package:flutter/material.dart';

enum TextTitleType { big, medium, small }

class TextTitleWidget extends StatefulWidget {
  const TextTitleWidget({
    super.key,
    this.text,
    this.alt,
    this.type = TextTitleType.medium,
  });

  final String? text;
  final String? alt;
  final TextTitleType type;

  @override
  State<TextTitleWidget> createState() => _TextTitleWidgetState();
}

class _TextTitleWidgetState extends State<TextTitleWidget> {
  late double fontSize;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case TextTitleType.big:
        fontSize = 30;
        break;
      case TextTitleType.medium:
        fontSize = 20;
        break;
      case TextTitleType.small:
        fontSize = 15;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text ?? widget.alt ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
