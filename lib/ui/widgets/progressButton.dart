import 'package:flutter/material.dart';

class ProgressButton extends StatelessWidget {
  final String text;
  final double width;
  final Color color;
  final Color textColor;
  final Function onPressed;

  const ProgressButton(
      {Key key,
      this.text,
      this.width = 100.0,
      this.color,
      this.textColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: width,
      decoration: BoxDecoration(),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        color: color,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
