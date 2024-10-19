import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maid_jump_game/games/jump_game.dart';

class GameOverPage extends StatelessWidget {
  final JumpGame jumpGame;
  const GameOverPage({super.key, required this.jumpGame});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("結果:${jumpGame.jumpCount}"),
            ElevatedButton(
                onPressed: () => jumpGame.gameRestart(),
                child: const Text("Re Start")),
          ]),
    );
  }
}
