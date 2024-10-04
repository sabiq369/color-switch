import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent {
  StarComponent({required super.position})
      : super(size: Vector2(28, 28), anchor: Anchor.center);

  late Sprite _starSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _starSprite = await Sprite.load("star.png");
    decorator.addLast(PaintDecorator.tint(Colors.white));
    add(CircleHitbox(
      radius: size.x / 2,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _starSprite.render(
      canvas,
      position: size / 2,
      size: size,
      anchor: Anchor.center,
    );
  }

  void showCollectionEffect() {
    parent!.add(ParticleSystemComponent(
        particle: Particle.generate(
      count: 100,
      generator: (i) => CircleParticle(
        radius: 2.0,
        paint: Paint()..color = Colors.orangeAccent.withOpacity(0.8),
        lifespan: 1.0,
      ),
    )));

    removeFromParent();
  }
}
