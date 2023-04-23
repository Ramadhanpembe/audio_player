import 'package:flutter/material.dart';

class AlertPopup extends StatelessWidget {
  const AlertPopup({
    super.key,
    required this.value,
    this.minimum = 0.0,
    this.maximum = 1.0,
    required this.onChanged,
  });

  final double value;
  final double minimum;
  final double maximum;
  final Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: Colors.transparent,
        height: 20.0,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Slider(
          value: value,
          onChanged: onChanged,
          divisions: 10,
          min: minimum,
          max: maximum,
        ),
      ),
    );
  }
}
