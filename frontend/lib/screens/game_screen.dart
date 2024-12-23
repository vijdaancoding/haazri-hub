import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '/utils/app_colors.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double playerPosition = 0.0; // Initial horizontal position of the player
  double obstaclePosition = 0.0; // Initial horizontal position of the obstacle
  double obstacleHeight = 50.0; // Height of the obstacle
  double playerJumpHeight = 100.0; // Maximum jump height
  bool isJumping = false; // Flag to indicate if the player is currently jumping
  double score = 0.0; // Game score

  @override
  void initState() {
    super.initState();
    startGameLoop();
  }

  void startGameLoop() {
    // Simulate game loop with a periodic timer
    const duration = Duration(milliseconds: 50);
    double jumpSpeed = 4.0; // Speed of the jump

    // Initialize the player's horizontal position to the left edge of the screen
    playerPosition = -1.0; // -1.0 represents the left edge of the screen

    // Initialize the obstacle's horizontal position randomly
    obstaclePosition = 1.0 + Random().nextDouble() * 0.5; // Start off-screen to the right

    Timer.periodic(duration, (timer) {
      setState(() {
        // Update obstacle position
        obstaclePosition -= 0.02; // Adjust the speed as needed
        if (obstaclePosition < -1.5) {
          // Reset the obstacle's position when it goes off-screen to the left
          obstaclePosition = 1.0 + Random().nextDouble() * 0.5;
          score += 1;
          // Randomize obstacle height
          obstacleHeight = 30.0 + Random().nextDouble() * 70.0; // Heights between 30 and 100
        }

        // Update player jump
        if (isJumping) {
          playerJumpHeight -= jumpSpeed;
          if (playerJumpHeight <= 0) {
            isJumping = false;
            playerJumpHeight = 0;
          }
        }

        // Check for collision
        if (isColliding()) {
          // Handle game over
          timer.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void jump() {
    // Start the jump only if not already jumping
    if (!isJumping) {
      setState(() {
        isJumping = true;
        playerJumpHeight = 100.0; // Reset jump height
      });
    }
  }

  bool isColliding() {
    if (playerPosition > obstaclePosition - 0.2 && playerPosition < obstaclePosition + 0.2) {
      // Adjust these values as needed for your game
      return playerJumpHeight < obstacleHeight / 100; // Check if player is under the obstacle height
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Game Over', style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)),
        content: Text('Your score: ${score.toInt()}', style: TextStyle(color: AppColors.textColor)),
        backgroundColor: AppColors.surfaceColor, // Using surface color for dialog background
        actions: <Widget>[
          TextButton(
            child: Text('Play Again', style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              setState(() {
                score = 0; // Reset the score
                playerPosition = -1.0;
                obstaclePosition = 1.0 + Random().nextDouble() * 0.5; // Reset obstacle position
                obstacleHeight = 30.0 + Random().nextDouble() * 70.0; // Reset obstacle height
              });
              startGameLoop(); // Start the game loop again
            },
          ),
          TextButton(
            child: Text('Exit', style: TextStyle(color: AppColors.errorColor)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the game screen and return to the dashboard
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onTap: jump,
        child: Stack(
          children: <Widget>[
            // Player (You can replace this with an image)
            AnimatedPositioned(
              duration: Duration(milliseconds: isJumping ? 300 : 0),
              curve: Curves.easeOut,
              left: MediaQuery.of(context).size.width / 2 +
                  playerPosition * (MediaQuery.of(context).size.width / 4) -
                  25, // Adjusted to center the player
              bottom: isJumping ? playerJumpHeight : 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Player color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
            ),

            // Obstacle
            Positioned(
              left: MediaQuery.of(context).size.width / 2 +
                  obstaclePosition * (MediaQuery.of(context).size.width / 4) -
                  25, // Adjusted to center the obstacle
              bottom: 0,
              child: Container(
                width: 50,
                height: obstacleHeight, // Variable height for the obstacle
                color: AppColors.accentColor, // Obstacle color
              ),
            ),

            // Score
            Positioned(
              top: 20,
              right: 20,
              child: Text('Score: ${score.toInt()}',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)),
            ),
          ],
        ),
      ),
    );
  }
}