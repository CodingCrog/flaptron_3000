import 'dart:ui';

import 'package:flaptron_3000/components/bitcoin.dart';
import 'package:flaptron_3000/homepage.dart';
import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/services/bitcoinmanager.dart';
import 'package:flaptron_3000/services/obstacle_manager.dart';
import 'package:flutter/material.dart';

import '../components/obstacles.dart';

bool checkObstacleCollision(
    {required Bird bird, required ObstacleManager obstacleManager}) {
  double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
  Rect birdRect = Rect.fromCenter(
    center: Offset(size.width * bird.pos.dx + bird.width / 2,
        size.height * bird.pos.dy + bird.height / 2),
    width: bird.width - 2 * padding,
    height: bird.height - 2 * padding,
  );
  final obstacles = obstacleManager.obstacles;
  for (Obstacle obstacle in obstacles) {
    Rect topObstacleRect = Rect.fromLTWH(
      obstacle.xPos - obstacle.width / 2,
      0,
      obstacle.width - 2 * padding,
      obstacle.topHeight - 2 * padding,
    );

    Rect bottomObstacleRect = Rect.fromLTWH(
      obstacle.xPos - obstacle.width / 2,
      size.height - obstacle.bottomHeight + 2 * padding,
      obstacle.width - 2 * padding,
      obstacle.bottomHeight,
    );

    if (birdRect.overlaps(topObstacleRect) ||
        birdRect.overlaps(bottomObstacleRect)) {
      return true;
    }
  }
  return false;
}

int checkBitCoinCollision(
    {required Bird bird, required BitcoinManager bitcoinManager}) {
  double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
  Rect birdRect = Rect.fromCenter(
    center: Offset(size.width * bird.pos.dx + bird.width / 2,
        size.height * bird.pos.dy + bird.height / 2),
    width: bird.width - 2 * padding,
    height: bird.height - 2 * padding,
  );

  List<BitCoin> collidedBitcoins = [];

  for (var bitcoin in bitcoinManager.bitcoins) {
    final bitcoinRect = Rect.fromCircle(
        center: Offset(bitcoin.pos.dx + 40, bitcoin.pos.dy + 40), radius: 40);
    final collide = birdRect.overlaps(bitcoinRect);
    if (collide) {
      collidedBitcoins.add(bitcoin);
    }
  }

  for (var bitcoin in collidedBitcoins) {
    bitcoinManager.bitcoins.remove(bitcoin);
  }

  return collidedBitcoins.length;
}
