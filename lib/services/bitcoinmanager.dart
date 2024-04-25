import 'dart:math';
import 'dart:ui';

class BitcoinManager {
  final List<Offset> bitcoinPositions = [];
  double screenWidth;
  double screenHeight;
  double speedMultiplier = 1.0;  // Default speed multiplier

  BitcoinManager({required this.screenWidth, required this.screenHeight});

  void spawnBitcoin(double xPos, double yPos) {
    bitcoinPositions.add(Offset(xPos, yPos));
  }

  void moveBitcoins() {
    for (int i = 0; i < bitcoinPositions.length; i++) {
      bitcoinPositions[i] =
          Offset(bitcoinPositions[i].dx - 5 * speedMultiplier, bitcoinPositions[i].dy);  // Apply the speed multiplier
    }
    bitcoinPositions.removeWhere((pos) => pos.dx < -80);
  }

  void spawnRandomBitcoin() {
    Random rand = Random();
    double yPos = rand.nextDouble() * (screenHeight - 50);
    double xPos = screenWidth + rand.nextDouble() * 200;
    spawnBitcoin(xPos, yPos);
  }

  void setSpeedMultiplier(double multiplier) {
    speedMultiplier = multiplier;
  }
}