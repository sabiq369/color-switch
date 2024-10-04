import 'package:color_switch/circle_rotator.dart';
import 'package:color_switch/color_switcher.dart';
import 'package:color_switch/ground.dart';
import 'package:color_switch/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player player;
  final List<Color> gameColors;
  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.orangeAccent,
        Colors.yellowAccent,
        Colors.greenAccent,
      ]});

  @override
  Color backgroundColor() => Color(0xff222222);

  @override
  void onMount() {
    _initializeGame();

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

  void _generateGameComponent() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(CircleRotator(position: Vector2(0, 0), size: Vector2(200, 200)));
    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world.add(
        CircleRotator(position: Vector2(0, -400), size: Vector2(150, 150)));
  }

  gameOver() {
    for (var element in world.children) {
      element.removeFromParent();
    }
    _initializeGame();
  }

  void _initializeGame() {
    world.add(Ground(position: Vector2(0, size.y / 3)));
    world.add(player = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));
    _generateGameComponent();
  }
}
