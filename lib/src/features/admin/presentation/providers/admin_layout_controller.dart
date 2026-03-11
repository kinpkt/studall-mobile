import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminLayoutControllerProvider =
    NotifierProvider<AdminLayoutController, int>(() {
      return AdminLayoutController();
    });

class AdminLayoutController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
