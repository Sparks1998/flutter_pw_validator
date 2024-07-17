import 'package:flutter/material.dart';

/// ValidationBarWidget that represent style of each one of them and shows under the TextField
class ValidationBarComponent extends StatelessWidget {
  final Color color;
  final double spacing;
  final int total;
  final int index;

  ValidationBarComponent({
    required this.color,
    required this.total,
    required this.index,
    this.spacing = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: index > 0 ? 2 : 0, right: index < total - 1 ? 2 : 0),
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
