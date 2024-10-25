import 'dart:async';

import 'package:maid_jump_game/components/maid_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:maid_jump_game/components/bullet_component.dart';
import 'package:maid_jump_game/games/jump_game.dart';

class OtherPlayerComponent extends SpriteComponent with HasGameRef<JumpGame> {
  late bool isJump = false;
  late bool isJumpUp = false;
  final double maxJump = 50.0;
  final double jumSpeed = 10;
  final double basePos;
  late bool isGameOver = false;
  OtherPlayerComponent({
    super.position,
    super.size,
    super.sprite,
    required this.basePos,
  }) : super(
          anchor: Anchor.center,
          paint: BasicPalette.gray.paint(),
        );

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isJump) {
      if (isJumpUp) {
        position.y -= jumSpeed;
        if (position.y <= maxJump) {
          isJumpUp = false;
        }
      } else {
        position.y += jumSpeed;
        if (position.y >= basePos) {
          positionReset();
          isJump = false;
        }
      }
    }
  }

  void jump() {
    isJump = true;
    isJumpUp = true;
  }

  void gameStart() async {
    final slimeSprite = await Sprite.load('meido01.png');
    sprite = slimeSprite;
    isGameOver = false;
  }

  void gameOver() async {
    positionReset();
    final slimeSprite = await Sprite.load('slime.png');
    sprite = slimeSprite;
    isGameOver = true;
  }

  void positionReset() {
    position.y = basePos;
  }
}
