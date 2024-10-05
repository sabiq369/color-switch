import 'package:color_switch/components/circle_rotator.dart';
import 'package:color_switch/components/color_switcher.dart';
import 'package:color_switch/components/ground.dart';
import 'package:color_switch/components/player.dart';
import 'package:color_switch/components/star_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player player;
  final List<Color> gameColors;
  final ValueNotifier<int> currentScore = ValueNotifier(0);
  final ValueNotifier<bool> mute = ValueNotifier(false);
  final List<PositionComponent> _gameComponents = [];

  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.yellowAccent,
        Colors.blueAccent,
        Colors.purpleAccent
      ]})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xff222222);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    decorator = PaintDecorator.blur(0);
  }

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

  void _addComponentToTheGame(PositionComponent component) {
    _gameComponents.add(component);
    world.add(component);
  }

  void _generateGameComponents(Vector2 generateFromPosition) {
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(200, 200)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2(0, 0)));
    generateFromPosition -= Vector2(0, 380);
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(200, 200)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(150, 150)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2(0, 0)));
    generateFromPosition -= Vector2(0, 380);
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(250, 250)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(200, 200)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(150, 150)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2(0, 0)));
    generateFromPosition -= Vector2(0, 380);
    _addComponentToTheGame(
        ColorSwitcher(position: generateFromPosition + Vector2(0, 180)));
    _addComponentToTheGame(CircleRotator(
        position: generateFromPosition + Vector2(0, 0),
        size: Vector2(125, 125)));
    _addComponentToTheGame(
        StarComponent(position: generateFromPosition + Vector2(0, 0)));
  }

  gameOver() {
    // FlameAudio.bgm.stop();
    for (var element in world.children) {
      element.removeFromParent();
    }
    _initializeGame();
  }

  bool get isGamePaused => timeScale == 0.0;
  bool get isGamePlaying => !isGamePaused;

  pauseGame() {
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
  }

  resumeGame() {
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
  }

  void _initializeGame() {
    currentScore.value = 0;
    world.add(Ground(position: Vector2(0, (size.y) / 3)));
    world.add(player = Player(position: Vector2(0, 250)));
    camera.moveTo(Vector2(0, 0));
    _generateGameComponents(Vector2(0, 20));
  }

  void increaseScore() => currentScore.value++;

  void generateNextBatch(StarComponent starComponent) {
    final allStarComponents =
        _gameComponents.whereType<StarComponent>().toList();
    final length = allStarComponents.length;
    for (int i = 0; i < length; i++) {
      if (starComponent == allStarComponents[i] && i >= length - 2) {
        final lastStar = allStarComponents.last;
        _generateGameComponents(lastStar.position - Vector2(0, 400));
        _destroyPreviousComponents(starComponent);
      }
    }
  }

  void _destroyPreviousComponents(StarComponent starComponent) {
    final length = _gameComponents.length;
    for (int i = 0; i < length; i++) {
      if (starComponent == _gameComponents[i] && i >= 15) {
        for (int i = 7; i >= 0; i--) {
          _gameComponents[i].removeFromParent();
          _gameComponents.removeAt(i);
        }
        break;
      }
    }
  }
}
