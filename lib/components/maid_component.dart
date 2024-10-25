import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:maid_jump_game/components/bullet_component.dart';
import 'package:maid_jump_game/games/jump_game.dart';

// プレイヤーキャラクターのコンポーネント
//SpriteComponent: 画像を使うコンポーネント
//CollisionCallbacks: コンポーネントに当たり判定を追加
// HasGameRef: 指定したゲームを参照可能に
class MaidComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  late bool isJump = false;
  late bool isJumpUp = false;
  final double maxJump = 450.0;
  final double jumSpeed = 10;
  final double basePos;
  late bool isGameOver = false;
  MaidComponent(
      {super.position, super.size, super.sprite, required this.basePos})
      : super(
          anchor: Anchor.center,
          paint: BasicPalette.gray.paint(),
        );

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    super.onLoad();
    // 当たり判定を追加
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // ジャンプの動作を実装
    // 最高到達点へ行ったら下に落ちる
    if (isJump) {
      if (isJumpUp) {
        position.y -= jumSpeed;
        if (position.y <= maxJump) {
          isJumpUp = false;
        }
      } else {
        position.y += jumSpeed;
        if (position.y >= gameRef.size.y * 0.8) {
          positionReset();
          isJump = false;
        }
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // 玉に当たったらゲームオーバに
    if (other is BulletComponent) {
      gameOver();
    }
  }

  // ジャンプした場合に呼ばれる
  void jump() {
    isJump = true;
    isJumpUp = true;
  }

  // ゲームスタート、リスタート時に呼ばれる
  // 画像、フラグのリセット
  void gameStart() async {
    final slimeSprite = await Sprite.load('meido01.png');
    sprite = slimeSprite;
    isGameOver = false;
  }

  // ゲームオーバー
  // 画像の差し替え、フラグの変更
  void gameOver() async {
    positionReset();
    final slimeSprite = await Sprite.load('slime.png');
    sprite = slimeSprite;
    isGameOver = true;
  }

  void positionReset() {
    position.y = gameRef.size.y * 0.8;
  }
}
