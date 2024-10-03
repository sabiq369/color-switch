import 'dart:ui';

import 'package:color_switch/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleRotator extends PositionComponent with HasGameRef<MyGame> {
  CircleRotator(
      {required super.position,
      required super.size,
      this.thickness = 10,
      this.rotationSpeed = 2})
      : assert(size!.x == size.y),
        super(anchor: Anchor.center);
  final double thickness, rotationSpeed;

  @override
  void onMount() {
    position = Vector2.zero();
    super.onMount();
  }

  @override
  void onLoad() {
    const circle = math.pi * 2;
    final sweep = circle / gameRef.gameColors.length;
    for (int i = 0; i < gameRef.gameColors.length; i++) {
      add(CircleArc(
          color: gameRef.gameColors[i],
          startAngle: i * sweep,
          sweepAngle: sweep));
    }
    add(RotateEffect.to(
        math.pi * 2, EffectController(speed: 1, infinite: true)));
    super.onLoad();
  }

  @override
  void update(double dt) {
    angle += 0.01;
    super.update(dt);
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  final Color color;
  final double startAngle, sweepAngle;

  CircleArc({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  }) : super(anchor: Anchor.center);
  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
        size.toRect().deflate(parent.thickness / 2),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = parent.thickness);
    super.render(canvas);
  }
}
