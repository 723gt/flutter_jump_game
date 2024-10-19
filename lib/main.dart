import 'package:flutter/material.dart';
import 'package:maid_jump_game/pages/jump_game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jump Games",
      home: JumpGamePage(),
    );
  }
}
