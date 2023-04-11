import '../features/feature_resource.dart';
import '../features/order.dart';

class FeatureManager {
  FeatureManager() {
    _init();
  }

  void _init() {
    order = Order();
  }
}
