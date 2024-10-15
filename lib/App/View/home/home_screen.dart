import 'package:flutter/material.dart';

import '../widgets/Bottombar/widgetbottombar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: add bottom bar in this scaffold
    return Scaffold(bottomNavigationBar: buttonnavigationbar(context));
  }
}
