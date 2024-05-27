import 'dart:math';
import 'dart:ui';

import 'package:flaptron_3000/services/speed_manager.dart';
import 'package:flutter/material.dart';

import '../components/bitcoin.dart';

class BitcoinManager {
  final List<BitCoin> bitcoins = [];

  BitcoinManager();

  void spawnBitcoin(double xPos, double yPos) {
    bitcoins.add(BitCoin(pos: Offset(xPos, yPos)));
  }

  void moveBitcoins() {
    for (var bitcoin in bitcoins) {
      bitcoin.pos = Offset(
          bitcoin.pos.dx - SpeedManager.speed, bitcoin.pos.dy);
      if (bitcoin.pos.dx <= 0) {
        bitcoins.remove(bitcoin);
      }
    }
  }

  void spawnRandomBitcoin() {
    final size =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size;
    double rand = Random().nextDouble();
    double yPos = (rand + 1) / 3;
    double xPos = size.width + rand * 200;
    spawnBitcoin(xPos, size.height * yPos);
  }
}
