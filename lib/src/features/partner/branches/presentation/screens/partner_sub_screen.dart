import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../../common_widgets/plain_text_app_bar.dart';

class PartnerSubScreen extends StatelessWidget {
  const PartnerSubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: PlainTextAppBar(text: 'Partner'),
          // body: SingleChildScrollView(child: IndexedStack(index: currentIndex, children: _pages)),
        )
    );
  }
}
