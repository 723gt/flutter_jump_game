import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:maid_jump_game/games/jump_game.dart';
import 'package:maid_jump_game/pages/game_over_page.dart';
import 'package:maid_jump_game/pages/init_page.dart';

// ゲームの大元のファイル
class JumpGamePage extends StatelessWidget {
  JumpGamePage({super.key});

  final game = JumpGame();

  @override
  Widget build(BuildContext context) {
    // FlutterへFlameのGameWidgetを追加
    return GameWidget(
      // FlutterのUI(Widget)を追加する
      overlayBuilderMap: {
        // スタート画面のWidget
        "init": (context, JumpGame jumpGame) => InitPage(
              jumpGame: jumpGame,
            ),
        // ゲームオーバー画面のWidget
        "gameOver": (context, JumpGame jumpGame) =>
            GameOverPage(jumpGame: jumpGame)
      },
      // ゲーム自体はJumpGameを設定
      game: game,
      initialActiveOverlays: const ['init'], // 起動時はスタート画面を設定
    );
  }
}
