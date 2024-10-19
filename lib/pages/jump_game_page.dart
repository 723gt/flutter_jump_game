import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:maid_jump_game/games/jump_game.dart';
import 'package:maid_jump_game/pages/game_over_page.dart';
import 'package:maid_jump_game/pages/init_page.dart';

class JumpGamePage extends StatelessWidget {
  JumpGamePage({super.key});

  final game = JumpGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      overlayBuilderMap: {
        "init": (context, JumpGame jumpGame) => InitPage(
              jumpGame: jumpGame,
            ),
        "gameOver": (context, JumpGame jumpGame) =>
            GameOverPage(jumpGame: jumpGame)
      },
      game: game,
      initialActiveOverlays: const ['init'],
    );
  }
}
