import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent {
  StarComponent({required super.position})
      : super(size: Vector2(28, 28), anchor: Anchor.center);

  late Sprite _starSprite;
  final _particlePaint = Paint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _starSprite = await Sprite.load("white_star.png");
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
    final rnd = Random();
    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 80;
    parent!.add(ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 0.8,
          generator: (i) {
            return AcceleratedParticle(
                speed: randomVector2(),
                acceleration: randomVector2(),
                child: RotatingParticle(
                    to: rnd.nextDouble() * pi * 2,
                    child: ComputedParticle(renderer: (canvas, particle) {
                      _starSprite.render(canvas,
                          anchor: Anchor.center,
                          overridePaint: _particlePaint
                            ..color =
                                Colors.white.withOpacity(1 - particle.progress),
                          size: size * (1 - particle.progress));
                    })));
          },
        )));
    removeFromParent();
  }
}
