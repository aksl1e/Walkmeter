import 'package:flutter/material.dart';

import 'walkmeter/views/views.dart';

class App extends MaterialApp {
  const App({super.key})
      : super(home: const WalkmeterPage(), debugShowCheckedModeBanner: false);
}
