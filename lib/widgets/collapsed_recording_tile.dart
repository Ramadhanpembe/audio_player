import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CollapsedRecordingTile extends StatelessWidget {
  const CollapsedRecordingTile({
    super.key,
    this.isExpanded = false,
    this.caller,
    required this.phone,
    required this.isClicked,
    this.duration,
    this.datetime,
  });

  final bool isClicked;
  final bool isExpanded;
  final String phone;
  final String? caller;
  final String? duration;
  final String? datetime;

  /// This function returns true when any of the two conditions occurs.
  /// One, if the recording tile is not yet expanded and then it is clicked.
  /// Two, if  the recording tile is not yet expanded and it is not clicked.
  /// Else, the function returns false.
  bool get _isIClicked {
    if (isClicked && !isExpanded || !isClicked && !isExpanded) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                caller!,
                style: kCallerTitleStyle,
              ),
              Text(
                duration!,
                style: kPhoneTitleStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phone,
                style: kPhoneTitleStyle,
              ),
              Text(
                datetime!,
                style: kPhoneTitleStyle,
              ),
            ],
          ),
          Divider(
            /// Ensures that the divider color is only visible when the recording tile is clicked before it is expanded or when when it is not clicked and not expanded.
            color:
                _isIClicked ? const Color(kDividerColor) : Colors.transparent,
            thickness: 1.6,
          ),
        ],
      ),
    );
  }
}
