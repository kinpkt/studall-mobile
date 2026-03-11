import 'package:flutter_riverpod/flutter_riverpod.dart';

final partnerLayoutControllerProvider = NotifierProvider<PartnerLayoutController, int>(
  () {
    return PartnerLayoutController();
  },
);

class PartnerLayoutController extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
