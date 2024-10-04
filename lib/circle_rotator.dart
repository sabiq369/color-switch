import 'dart:ui';

import 'package:color_switch/game.dart';
import 'package:flame/collisions.dart';
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
    _addHitBox();
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

  void _addHitBox() {
    final center = size / 2,
        precision = 8,
        segment = sweepAngle / (precision - 1),
        radius = size.x / 2;

    List<Vector2> vertices = [];
    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center +
          Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius);
    }
    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center +
          Vector2(math.cos(thisSegment), math.sin(thisSegment)) *
              (radius - parent.thickness));
    }
    add(PolygonHitbox(vertices, collisionType: CollisionType.passive));
  }
}
