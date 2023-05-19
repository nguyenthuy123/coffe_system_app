import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextLinkWidget extends StatefulWidget {
  const TextLinkWidget({
    super.key,
    this.onPressed,
    this.intro,
    this.link,
  });

  final Function()? onPressed;
  final String? intro;
  final String? link;

  @override
  State<TextLinkWidget> createState() => _TextLinkWidgetState();
}

class _TextLinkWidgetState extends State<TextLinkWidget> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.intro,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: widget.link,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()..onTap = widget.onPressed,
          ),
        ],
      ),
    );
  }
}
