import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.isExpanded = true,
  });

  final Function()? onPressed;
  final String text;
  final Color? color;
  final bool isExpanded;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? Expanded(
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(backgroundColor: widget.color),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: widget.color),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}
