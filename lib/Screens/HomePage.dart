import 'dart:async';

import 'package:flappy_b/Screens/MyCoverScreen.dart';
import 'package:flappy_b/Screens/barriers.dart';
import 'package:flappy_b/Screens/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // how strong the gravity is
  double velocity = 2.8; // how strong the jump is

  double birdHeight = 0.2;
  double birdWidth = 0.2;

  bool gameHasStarted = false;

  double bestScore = 00;
  double CScore = 00;

  static List<double> barrierX = [2, 2];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    //topHeight , bottomHeight
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // a real physical jump is the same as an upside down parabola
      // so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
        CScore += 0.025;
      });

      // check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        if (CScore > bestScore) {
          bestScore = CScore;
        }
      }

      // keep the map moving (move barriers)
      moveMap();

      // keep the time going!
      time += 0.01;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.005;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 0.77) {
      return true;
    }
    // checking if the bird is within the barriers X Y coordinates
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    //Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      CScore = 0.0;
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted
          ? jump
          : birdIsDead()
              ? resetGame
              : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      // bird
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                        birdImage: birdIsDead()
                            ? 'lib/images/bird_out.png'
                            : 'lib/images/bird_down.png',
                      ),

                      // Top barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),

                      // Bottom barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),

                      // Top barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),

                      // Bottom barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                      // tap to play
                      MyCoverScreen(
                        gameHasStarted: gameHasStarted,
                      ),
                      Container(
                        alignment: Alignment(0, 0.6),
                        child: gameHasStarted
                            ? Text(" ")
                            : IconButton(
                                onPressed: birdIsDead() ? resetGame : startGame,
                                icon: birdIsDead()
                                    ? Icon(Icons.refresh)
                                    : Icon(Icons.play_arrow_outlined),
                                iconSize: 100,
                                color: Colors.white,
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 10,
              color: Colors.lightGreenAccent,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CScore.toString().split(".").first,
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'S C O R E',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            bestScore.toString().split(".").first,
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'B E S T',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
