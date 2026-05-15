import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/utils/app_config.dart';

class ExpressModeController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle(bool value) {
    state = value;
  }

  bool get shouldShowSwitcher {
    final now = DateTime.now();
    return now.hour >= AppConfig.expressStartHour &&
        now.hour < AppConfig.expressEndHour;
  }
}

final expressModeProvider = NotifierProvider<ExpressModeController, bool>(
  ExpressModeController.new,
);
