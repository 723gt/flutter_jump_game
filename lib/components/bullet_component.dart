import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_mmo/components/maid_component.dart';

class BulletComponent extends CircleComponent with CollisionCallbacks {
  BulletComponent({super.position}) : super(radius: 10);
  bool hitFlag = false;
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
    if (other is MeidoComponent) {
      removeFromParent();
    }
  }
}
