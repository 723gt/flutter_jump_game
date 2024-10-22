import 'package:maid_jump_game/components/maid_component.dart';

class OtherPlayerComponent extends MaidComponent {
  @override
  final double maxJump = 50.0;
  OtherPlayerComponent({
    super.position,
    super.size,
    super.sprite,
    required super.basePos,
  });

  @override
  void jump() {
    super.isJump = true;
    super.isJumpUp = true;
  }
}
