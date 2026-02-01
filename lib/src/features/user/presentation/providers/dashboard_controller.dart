import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardControllerProvider = NotifierProvider<DashboardController, int>(
  () {
    return DashboardController();
  },
);

class DashboardController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
