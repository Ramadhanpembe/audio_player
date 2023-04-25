import 'dart:async';

import 'package:audio_player/utils/constants.dart';
import 'package:flutter/material.dart';

class AlertPopup extends StatefulWidget {
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
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _startTimer(),
      child: Visibility(
        visible: _isVisible,
        child: AlertDialog(
          elevation: 0.0,
          backgroundColor: kPrimaryColor,
          alignment: Alignment.topCenter,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          content: Container(
            color: Colors.transparent,
            height: 20.0,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Slider(
              activeColor: Colors.white,
              inactiveColor: kBackgroundColor,
              value: widget.value,
              onChanged: widget.onChanged,
              min: widget.minimum,
              max: widget.maximum,
            ),
          ),
        ),
      ),
    );
  }
}
