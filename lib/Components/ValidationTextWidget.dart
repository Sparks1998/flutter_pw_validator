import 'package:flutter/material.dart';

/// ValidationTextWidget that represent style of each one of them and shows as list of condition that you want to the app user
class ValidationTextWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int? value;
  final double indicatorRadius;
  final double fontSize;

  ValidationTextWidget({
    required this.color,
    required this.text,
    required this.value,
    required this.indicatorRadius,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: indicatorRadius * 2,
          height: indicatorRadius * 2,
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: indicatorRadius * 2),
            child: Text(
              text.replaceFirst("-", value.toString()),
              style: TextStyle(
                fontSize: fontSize,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
