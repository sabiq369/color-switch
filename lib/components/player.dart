import 'package:color_switch/components/circle_rotator.dart';
import 'package:color_switch/components/color_switcher.dart';
import 'package:color_switch/components/game.dart';
import 'package:color_switch/components/ground.dart';
import 'package:color_switch/components/star_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  Player({required super.position, this.playerRadius = 13.0})
      : super(priority: 20);
  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;
  final playerRadius;
  Color _color = Colors.white;
  final _playerPaint = Paint();

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: playerRadius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));
  }

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
      _velocity.setValues(0, 0);
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      _velocity.y += _gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
        (size / 2).toOffset(), playerRadius, _playerPaint..color = _color);
  }

  jump() {
    _velocity.y = -_jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ColorSwitcher) {
      other.removeFromParent();
      changeColor();
    } else if (other is CircleArc) {
      if (_color != other.color) {
        gameRef.gameOver();
      }
    } else if (other is StarComponent) {
      FlameAudio.play("score.wav", volume: 0.4);
      other.showCollectionEffect();
      gameRef.increaseScore();
      gameRef.generateNextBatch(other);
    }
  }

  void changeColor() {
    _color = gameRef.gameColors.random();
  }
}
