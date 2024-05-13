import 'dart:math';
import 'dart:ui';

import '../components/bitcoin.dart';

class BitcoinManager {
  final List<BitCoin> bitcoins = [];
  double screenWidth;
  double screenHeight;
  double speedMultiplier = 0.5; // Default speed multiplier

  BitcoinManager({required this.screenWidth, required this.screenHeight});

  void spawnBitcoin(double xPos, double yPos) {
    bitcoins.add(BitCoin(pos: Offset(xPos, yPos)));
  }

/*  void moveBitcoins() {
    for (int i = 0; i < bitcoins.length; i++) {
      bitcoins[i] = BitCoin(
          center: Offset(bitcoins[i].center.dx - 5 * speedMultiplier,
              bitcoins[i].center.dy)); // Apply the speed multiplier
      bitcoins[i].center.dx <= 100 ? bitcoins.removeAt(i) : bitcoins;
    }
  }*/

  void spawnRandomBitcoin() {
    double rand = Random().nextDouble();
    double yPos = (rand + 1) / 3;
    double xPos = screenWidth + rand * 200;
    spawnBitcoin(xPos, screenHeight * yPos);
  }

  void setSpeedMultiplier(double multiplier) {
    speedMultiplier = multiplier;
  }
}
