import 'package:flutter/material.dart';
import 'app/view/home_view.dart';

void main() {
  runApp(const Initapp());
}

class Initapp extends StatelessWidget {
  const Initapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: const HomeView());
  }
}
