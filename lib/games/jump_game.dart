import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:flutter_mmo/components/bullet_component.dart';
import 'package:flutter_mmo/components/maid_component.dart';

class JumpGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late MeidoComponent _myChar;
  late int jumpCount = 0;
  @override
  Future<void> onLoad() async {
    final myCharSprite = await Sprite.load('meido01.png');
    _myChar = MeidoComponent(
        position: Vector2(100, size.y * 0.8),
        size: Vector2.all(size.x * 0.1),
        sprite: myCharSprite,
        basePos: size.y * 0.8);
    super.onLoad();
    add(ScreenHitbox());
    add(_myChar);
    add(TimerComponent(
        period: 5,
        repeat: true,
        onTick: () {
          add(BulletComponent(position: Vector2(size.x - 30, size.y * 0.8)));
        }));
  }

  @override
  void onMount() {
    super.onMount();
    paused = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_myChar.isGameOver) {
      gameOver();
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      final bullet =
          BulletComponent(position: Vector2(size.x - 30, size.y * 0.8));
      add(bullet);
    }
    return KeyEventResult.ignored;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _myChar.jump();
  }

  void gameStart() async {
    overlays.remove('init');
    paused = false;
    _myChar.gameStart();
  }

  void gameOver() {
    paused = true;
    overlays.add("gameOver");
  }

  void gameRestart() {
    overlays.remove('gameOver');
    overlays.add('init');
  }
}