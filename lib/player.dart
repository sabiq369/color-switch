import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  final _velocity = Vector2(0, 30);
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  @override
  void onMount() {
    super.onMount();
    position = Vector2(100, 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
    _velocity.y += _gravity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(position.toOffset(), 15, Paint()..color = Colors.red);
  }

  jump() {
    _velocity.y = -_jumpSpeed;
  }
}
