import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:maid_jump_game/components/maid_component.dart';
import 'package:maid_jump_game/components/other_player_component.dart';
import 'package:maid_jump_game/games/jump_game.dart';

class BulletComponent extends CircleComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  BulletComponent({super.position, this.isPlayer = true}) : super(radius: 10);
  bool hitFlag = false;
  final bool isPlayer;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= 10.0;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MaidComponent && other is! OtherPlayerComponent) {
      removeFromParent();
    }

    if (other is ScreenHitbox && isPlayer) {
      gameRef.scoreCountUp();
      removeFromParent();
    }
  }
}
