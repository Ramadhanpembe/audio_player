import 'package:audio_player/widgets/player_panel.dart';
import 'package:flutter/material.dart';

import '../customs/custom_slider_track_shape.dart';
import '../utils/constants.dart';
import 'height.dart';

/// This widget displays when the recording tile is clicked
class ExpandedRecordingTile extends StatelessWidget {
  const ExpandedRecordingTile(
      {super.key,
      this.isExpanded = false,
      required this.sliderValue,
      this.sliderMin = 0,
      this.sliderMax = 10,
      this.timeElapsed,
      this.timeRemained,
      this.iconSize = 25});

  final bool isExpanded;
  final double sliderValue;
  final double? sliderMin;
  final double? sliderMax;
  final String? timeElapsed;
  final String? timeRemained;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderTheme(
            data: SliderThemeData(
              overlayShape: SliderComponentShape.noThumb,

              /// This is implemented so as to remove the default Slider paddings and margins.
              trackShape: CustomSliderTrackShape(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: sliderValue,
              min: sliderMin!,
              max: sliderMax!,
              activeColor: const Color(0xffA31E47),
              inactiveColor: const Color(0xffF1E4EA),
              thumbColor: const Color(0xff462038),
              onChanged: (double value) {
                // onChanged implementation will go here
              },
            ),
          ),
          const Height(3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeElapsed!,
                style: kTimeElapsedTitleStyle,
              ),
              Text(
                timeRemained!,
                style: kTimeElapsedTitleStyle,
              ),
            ],
          ),
          const Height(7),
          const PlayerPanel(),
          const Height(4),
          Divider(
            /// Checks the state of the recording tile whether it is expanded or collapsed.
            /// The divider should only be visible when the recording tile is expanded.
            color: isExpanded ? const Color(kDividerColor) : Colors.transparent,
            thickness: 1.6,
          ),
        ],
      ),
    );
  }
}
