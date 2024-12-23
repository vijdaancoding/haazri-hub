import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '/utils/app_colors.dart';
import '/utils/game_images.dart';
import '/utils/app_styles.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game settings
  double playerX = 0; // Player's X position (range: -1 to 1)
  double shotX = 0; // Shot's X position
  double shotY = 1; // Shot's Y position (starts at the top)
  bool shotVisible = false;
  List<List<double>> enemies = []; // List to store enemy positions: [[x1, y1], [x2, y2], ...]
  int score = 0;
  bool isGameOver = false;

  // Image to display upon reaching a certain score
  String _winnerImageUri = GameImages.secretImage;

  // Game loop
  Timer? gameLoopTimer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    gameLoopTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    score = 0;
    isGameOver = false;
    playerX = 0;
    shotVisible = false;
    enemies = []; // Reset enemies
    _generateEnemies();

    gameLoopTimer?.cancel(); // Cancel existing timer if any
    gameLoopTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      _updateGame();
    });
  }

  void _generateEnemies() {
    // Generate a few enemies initially
    Random random = Random();
    for (int i = 0; i < 3; i++) {
      enemies.add([random.nextDouble() * 1.5 - 0.75, -0.8]); // Adjust initial positions
    }
  }

  void _updateGame() {
    setState(() {
      // Move the shot
      if (shotVisible) {
        shotY -= 0.05;
        if (shotY < -1) {
          shotVisible = false;
        }
      }

      // Move enemies
      for (int i = 0; i < enemies.length; i++) {
        enemies[i][1] += 0.01; // Adjust enemy speed as needed

        // Check for collision with shot
        if (shotVisible &&
            (enemies[i][0] - shotX).abs() < 0.08 && // Adjust hit box as needed
            (enemies[i][1] - shotY).abs() < 0.08) {
          enemies.removeAt(i);
          score++;
          shotVisible = false;
          shotY = 1;

          if (score >= 15) {
            _showWinnerDialog();
            gameLoopTimer?.cancel(); // Stop the game loop
            return; // Exit the update function
          }

          // Add a new enemy when one is destroyed
          _addNewEnemy();
        }

        // Check if enemy went off-screen
        if (enemies[i][1] > 1) {
          enemies.removeAt(i);
          _addNewEnemy();
          // Optional: Penalize player for missing an enemy
        }
      }
    });
  }

  void _addNewEnemy() {
    Random random = Random();
    enemies.add([random.nextDouble() * 1.5 - 0.75, -0.8]); // Adjust position range
  }

  void _fireShot() {
    if (!shotVisible) {
      shotX = playerX;
      shotY = 0.6; // Adjust starting position of the shot
      shotVisible = true;
    }
  }

  void _showWinnerDialog() {
    gameLoopTimer?.cancel(); // Stop the game loop

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: Text(
          'Congratulations!',
          style: AppStyles.heading1.copyWith(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Fit content
          children: [
            Image.network(_winnerImageUri),
            SizedBox(height: 20),
            Text(
              'You Win! Your Score: $score',
              style: AppStyles.bodyText,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Play Again', style: TextStyle(color: AppColors.primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _startGame(); // Restart the game
            },
          ),
          TextButton(
            child: Text('Exit', style: TextStyle(color: AppColors.errorColor)),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back to the previous screen
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
        onTap: _fireShot, // Fire on tap
        onHorizontalDragUpdate: (details) {
          // Control player movement
          setState(() {
            playerX += details.delta.dx / 50; // Adjust sensitivity
            playerX = playerX.clamp(-1.0, 1.0); // Keep player within bounds
          });
        },
        child: Stack(
          children: [
            // Player (ship)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * (playerX + 1) / 2 - 25,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Icon(
                  Icons.airplanemode_active, // Use a spaceship icon
                  color: Colors.white,
                ),
              ),
            ),

            // Shot (bullet)
            if (shotVisible)
              Positioned(
                top: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height * (1 - shotY)) -
                    50,
                left: MediaQuery.of(context).size.width * (shotX + 1) / 2 - 5,
                child: Container(
                  width: 10,
                  height: 20,
                  color: AppColors.accentColor,
                ),
              ),

            // Enemies
            ...enemies.map((enemy) {
              return Positioned(
                top: MediaQuery.of(context).size.height * (1 + enemy[1]) / 2 -
                    25, // Center the enemy
                left: MediaQuery.of(context).size.width * (enemy[0] + 1) / 2 - 25,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.errorColor,
                    shape: BoxShape.circle, // Circular enemies
                  ),
                  child: Center( // Center the icon in the circle
                    child: Icon(
                      Icons.bug_report, // Replace with an appropriate enemy icon
                      color: AppColors.white,
                      size: 30, // Adjust icon size as needed
                    ),
                  ),
                ),
              );
            }).toList(),

            // Score
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'Score: $score',
                style: AppStyles.heading1.copyWith(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                ),
              ),
            ),

            // Game Over Message
            if (isGameOver)
              Center(
                child: Text(
                  'Game Over',
                  style: AppStyles.heading1.copyWith(
                    color: AppColors.errorColor,
                    fontSize: 40.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}