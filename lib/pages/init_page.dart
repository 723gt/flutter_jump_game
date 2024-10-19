import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mmo/games/jump_game.dart';

class InitPage extends StatelessWidget {
  final JumpGame jumpGame;
  const InitPage({super.key, required this.jumpGame});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: ElevatedButton(
          onPressed: () => jumpGame.gameStart(), child: const Text("Start")),
    );
  }
}
