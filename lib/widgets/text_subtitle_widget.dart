import 'package:flutter/material.dart';

class TextSubtitleWidget extends StatefulWidget {
  const TextSubtitleWidget({
    super.key,
    this.text,
    this.alt,
  });

  final String? text;
  final String? alt;

  @override
  State<TextSubtitleWidget> createState() => _TextSubtitleWidgetState();
}

class _TextSubtitleWidgetState extends State<TextSubtitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text ?? widget.alt ?? '',
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }
}
