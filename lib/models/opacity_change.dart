import '../utils/constants.dart';

/// Controls the level of opacity of the main title and the subtitle.
class OpacityChange {
  double _mainTitleOpacityLevel = 1;
  double _subtitleOpacityLevel = 0;

  ///Changes the opacity level of the main title at a given container height.
  void changeMainOpacity(double containerHeight) {
    containerHeight <= kAnimatedHeight
        ? _mainTitleOpacityLevel = 0
        : _mainTitleOpacityLevel = 1;
  }

  ///Changes the opacity level of the subtitle at a given container height.
  void changeSubOpacity(double containerHeight) {
    containerHeight <= kAnimatedHeight
        ? _subtitleOpacityLevel = 1
        : _subtitleOpacityLevel = 0;
  }

  double get mainTitleOpacityLevel {
    return _mainTitleOpacityLevel;
  }

  double get subtitleOpacityLevel {
    return _subtitleOpacityLevel;
  }
}
