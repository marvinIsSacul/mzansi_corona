

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helpers/styles.dart';


/// An Indicator Widget.
class IndicatorWidget extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const IndicatorWidget({
    Key key,
    @required this.color,
    @required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = Colors.blueGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
