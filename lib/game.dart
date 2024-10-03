import 'package:color_switch/circle_rotator.dart';
import 'package:color_switch/ground.dart';
import 'package:color_switch/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player player;
  final List<Color> gameColors;
  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.yellowAccent,
      ]});

  @override
  Color backgroundColor() => Color(0xff222222);

  @override
  void onMount() {
    world.add(Ground(position: Vector2(0, 300)));
    world.add(player = Player(position: Vector2(0, 250)));
    generateGameComponent();
    // debugMode = true;
    super.onMount();
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;
    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    player.jump();
  }

  void generateGameComponent() {
    world.add(CircleRotator(position: Vector2(0, 0), size: Vector2(200, 200)));
  }
}
