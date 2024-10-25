import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:maid_jump_game/components/maid_component.dart';
import 'package:maid_jump_game/games/jump_game.dart';

// 球のコンポーネント
class BulletComponent extends CircleComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  BulletComponent({super.position}) : super(radius: 10);
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 円形のhitboxを追加
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 右から左へ移動する
    position.x -= 10.0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MaidComponent) {
      // プレイヤーキャラクターに当たったら球を消す
      removeFromParent();
    }

    if (other is ScreenHitbox) {
      // 壁に当たったらカウントして球を消す
      gameRef.jumpCount++;
      removeFromParent();
    }
  }
}
