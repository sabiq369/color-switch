import 'package:color_switch/game.dart';
import 'package:color_switch/ground.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  Player({required super.position, this.playerRadius = 15.0});
  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final playerRadius;

  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
    Ground ground = gameRef.findByKeyName(Ground.keyName)!;
    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      _velocity.y += _gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
        (size / 2).toOffset(), playerRadius, Paint()..color = Colors.yellow);
  }

  jump() {
    _velocity.y = -_jumpSpeed;
  }
}
