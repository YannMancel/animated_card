import 'package:color_card/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const _kAppTitle = 'Animated background';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _kAppTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: _kAppTitle),
    );
  }
}
