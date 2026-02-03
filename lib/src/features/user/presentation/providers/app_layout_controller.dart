import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLayoutControllerProvider = NotifierProvider<AppLayoutController, int>(
  () {
    return AppLayoutController();
  },
);

class AppLayoutController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
