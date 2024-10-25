import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/widgets/focus_manager.dart';
import 'package:maid_jump_game/components/bullet_component.dart';
import 'package:maid_jump_game/components/maid_component.dart';

class JumpGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late MaidComponent _myChar;
  late int jumpCount = 0;
  @override
  Future<void> onLoad() async {
    // プレイヤーキャラクターの画像を読み込み
    final myCharSprite = await Sprite.load('meido01.png');
    // プレイヤーキャラクターのコンポーネント作成
    _myChar = MaidComponent(
        position: Vector2(100, size.y * 0.8),
        size: Vector2.all(size.x * 0.1),
        sprite: myCharSprite,
        basePos: size.y * 0.8);
    super.onLoad();
    // 画面の当たり判定をゲームに追加
    add(ScreenHitbox());
    // プレイヤーキャラクターをゲームに追加
    add(_myChar);
    // 5秒ごとに球を発射するようにTimerComponentを追加
    add(TimerComponent(
        period: 5,
        repeat: true,
        onTick: () {
          add(BulletComponent(
              position:
                  Vector2(size.x - 30, size.y * 0.8))); // 5秒ごとに球をゲームに追加c;;w
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
    // プレイヤーキャラクターが玉に当たったていた場合ゲームオーバー画面に移行
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

    // スペースキーを押されたらキャラクターがジャンプ
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      _myChar.jump();
    }
    return KeyEventResult.ignored;
  }

  @override
  void onTapDown(TapDownEvent event) {
    // クリックでもキャラクターがジャンプ
    super.onTapDown(event);
    _myChar.jump();
  }

  void gameStart() async {
    // ゲームスタート画面を削除
    overlays.remove('init');
    // ポーズを解除
    paused = false;
    // キャラクターをゲームスタート状態へ
    _myChar.gameStart();
  }

  void gameOver() {
    // ゲームのポーズを実行
    paused = true;
    // ゲームオーバー画面をオーバーレイ
    overlays.add("gameOver");
  }

  void gameRestart() {
    // ゲームオーバー画面からゲームスタート画面へ
    overlays.remove('gameOver');
    overlays.add('init');
  }
}
