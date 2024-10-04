import 'dart:ui';

import 'package:color_switch/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ColorSwitcher extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  ColorSwitcher({
    required super.position,
    this.radius = 16,
  }) : super(anchor: Anchor.center, size: Vector2.all(radius * 2));
  final double radius;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      position: size / 2,
      radius: radius,
      anchor: anchor,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    final length = gameRef.gameColors.length;
    final sweepAngle = (math.pi * 2) / length;
    for (int i = 0; i < length; i++) {
      canvas.drawArc(size.toRect(), i * sweepAngle, sweepAngle, true,
          Paint()..color = gameRef.gameColors[i]);
    }

    super.render(canvas);
  }
}
