import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.iconData,
    this.isAutoFocus = false,
    this.isObscure = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData iconData;
  final bool isAutoFocus;
  final bool isObscure;

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        obscureText: widget.isObscure,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
          suffixIcon: Icon(widget.iconData),
        ),
      ),
    );
  }
}
