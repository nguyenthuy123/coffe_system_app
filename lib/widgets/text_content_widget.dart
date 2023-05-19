import 'package:flutter/material.dart';

class TextContentWidget extends StatefulWidget {
  const TextContentWidget({
    super.key,
    this.text,
    this.alt,
  });

  final String? text;
  final String? alt;

  @override
  State<TextContentWidget> createState() => _TextContentWidgetState();
}

class _TextContentWidgetState extends State<TextContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text ?? widget.alt ?? '',
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 18),
    );
  }
}
