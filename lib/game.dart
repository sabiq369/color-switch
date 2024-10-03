import 'package:color_switch/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player player;
  @override
  Color backgroundColor() => Color(0xff222222);

  @override
  void onMount() {
    super.onMount();
    add(player = Player());
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    player.jump();
  }
}
