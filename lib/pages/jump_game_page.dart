import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mmo/games/jump_game.dart';

class JumpGamePage extends StatelessWidget {
  JumpGamePage({super.key});

  final game = JumpGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
  }
}
