import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentLayoutControllerProvider =
    NotifierProvider<StudentLayoutController, int>(() {
      return StudentLayoutController();
    });

class StudentLayoutController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
