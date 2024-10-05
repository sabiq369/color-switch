import 'package:color_switch/components/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomePage(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MyGame _myGame;
  bool mute = false;

  @override
  void initState() {
    _myGame = MyGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: _myGame.mute,
            builder: (context, value, child) {
              return Stack(
                children: [
                  GameWidget(
                    game: _myGame,
                  ),
                  if (_myGame.isGamePlaying)
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _myGame.pauseGame();
                          });
                        },
                        icon: const Icon(Icons.pause)),
                  if (_myGame.isGamePlaying)
                    Align(
                      alignment: Alignment.topRight,
                      child: ValueListenableBuilder(
                        valueListenable: _myGame.currentScore,
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              'Score: ${value.toString()}',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  if (_myGame.isGamePaused)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'PAUSED!',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  mute = false;
                                  _myGame.resumeGame();
                                });
                              },
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
