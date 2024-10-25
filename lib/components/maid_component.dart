import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:maid_jump_game/components/bullet_component.dart';
import 'package:maid_jump_game/games/jump_game.dart';

class MaidComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  late bool isJump = false;
  late bool isJumpUp = false;
  final double maxJump = 450.0;
  final double jumSpeed = 10;
  final double basePos;
  late bool isGameOver = false;
  MaidComponent({
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BulletComponent) {
      gameOver();
    }
  }

  void jump() {
    if (!isGameOver) {
      isJump = true;
      isJumpUp = true;
      gameRef.sendJumpCommand();
    }
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
