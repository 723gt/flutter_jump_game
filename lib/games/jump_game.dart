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
import 'package:maid_jump_game/components/other_player_component.dart';
import 'package:maid_jump_game/models/user_info.dart';
import 'package:maid_jump_game/models/join_room.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class JumpGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  late final RouterComponent router;
  late MaidComponent _myChar;
  late OtherPlayerComponent otherPlayer;
  late int jumpCount = 0;
  late IO.Socket socket;
  final JoinRoom roomInfo = JoinRoom(roomId: "room01");
  late UserInfo userInfo;
  @override
  Future<void> onLoad() async {
    final myCharSprite = await Sprite.load('meido01.png');
    // 相手プレイヤーのコンポーネント準備
    otherPlayer = OtherPlayerComponent(
        position: Vector2(100, size.y * 0.4),
        size: Vector2.all(size.x * 0.1),
        sprite: myCharSprite,
        basePos: size.y * 0.4);
    // サーバへ接続情報の設定
    socket = IO.io(
      "http://localhost:3000",
      IO.OptionBuilder()
          .setPath("/socket/")
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    // サーバへの接続完了
    socket.onConnect((_) {
      // roomへのjoin
      socket.emit("join", roomInfo.toJson());
      // roomにjoin後、サーバにclientIdを送信
      const uuid = Uuid();
      final clientId = uuid.v4();
      // 自身のidを設定、サーバに送信
      userInfo = UserInfo(clientId: clientId);
      socket.emit("info", userInfo.toJson());
    });

    socket.on("join", (params) {
      print("join info");
      print(params);
    });

    // プレイヤーのジャンプ情報
    socket.on("user-jump", (params) {
      // 他プレイヤーだった場合他のプレイヤーのジャンプを実行
      if (isOtherUser(params)) {
        otherPlayer.jump();
      }
    });

    // プレイヤーの接続情報
    socket.on("user-join-info", (params) {
      // ほかプレイヤーだった場合相手プレイヤーのメイドをゲームに追加
      if (isJoinOtherPlayer(params)) {
        add(otherPlayer);
      }
    });

    // プレイヤーが玉に当たった場合の通知
    socket.on('user-hit', (params) {
      // 相手プレイヤーだった場合相手プレイヤー画像を差し変え
      if (isOtherUser(params)) {
        otherPlayer.gameOver();
      }
    });

    // 球の発射を受信
    socket.on("bullet", (params) {
      print("bullet!");
      add(BulletComponent(position: Vector2(size.x - 30, size.y * 0.8)));
      add(BulletComponent(position: Vector2(size.x - 30, size.y * 0.4)));
    });

    //ゲームが終わった場合 ゲームオーバ画面に繊維
    socket.on('gameSet', (params) {
      gameOver();
    });
    // サーバに接続
    socket.connect();
    _myChar = MaidComponent(
        position: Vector2(100, size.y * 0.8),
        size: Vector2.all(size.x * 0.1),
        sprite: myCharSprite,
        basePos: size.y * 0.8);
    super.onLoad();
    add(ScreenHitbox());
    add(_myChar);

    add(RectangleComponent(
      position: Vector2(0, size.y * 0.5),
      size: Vector2(size.x, 1),
    ));
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
      // 玉に当たった場合サーバへ当たったことを通知
      playerHit();
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      final bullet =
          BulletComponent(position: Vector2(size.x - 30, size.y * 0.8));
      final bullet2 = BulletComponent(
          position: Vector2(size.x - 30, size.y * 0.4), isPlayer: false);
      add(bullet);
      add(bullet2);
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      _myChar.jump();
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
    jumpCount = 0;
    _myChar.gameStart();
    otherPlayer.gameStart();
    // サーバへ準備完了を送信
    socket.emit("start");
  }

  void playerHit() {
    // サーバへ球のヒットを送信
    socket.emit("hit");
  }

  void gameOver() {
    paused = true;
    overlays.add("gameOver");
  }

  void gameRestart() {
    overlays.remove('gameOver');
    overlays.add('init');
  }

  void sendJumpCommand() {
    // サーバへジャンプしたことの送信
    socket.emit("jump");
  }

  void scoreCountUp() {
    if (!_myChar.isGameOver) {
      jumpCount++;
    }
  }

  bool isJoinOtherPlayer(dynamic params) {
    final listParams = List<Map<String, dynamic>>.from(params);
    final userInfos = listParams.map((map) => UserInfo.fromJson(map)).toList();
    final otherPlayers =
        userInfos.where((item) => item.clientId != userInfo.clientId).toList();
    return otherPlayers.isNotEmpty;
  }

  bool isOtherUser(dynamic params) {
    final otherInfo = UserInfo.fromJson(params);
    return userInfo.clientId != otherInfo.clientId;
  }
}
