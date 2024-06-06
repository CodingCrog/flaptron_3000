import 'dart:ui';

import 'package:flaptron_3000/components/bitcoin.dart';
import 'package:flaptron_3000/homepage.dart';
import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/services/bitcoinmanager.dart';
import 'package:flaptron_3000/services/obstacle_manager.dart';
import 'package:flutter/material.dart';

import '../components/obstacles.dart';

bool checkObstacleCollision(
    {required Bird bird, required ObstacleManager obstacleManager,required Size size}) {
  double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
  Rect birdRect = Rect.fromCenter(
    center: Offset(size.width * bird.pos.dx + bird.width / 2,
        size.height * bird.pos.dy + bird.height / 2),
    width: bird.width / 2,
    height: bird.height / 2,
  );
  final obstacles = obstacleManager.obstacles;
  for (Obstacle obstacle in obstacles) {
    Rect topObstacleRect = Rect.fromLTWH(
      obstacle.xPos + padding,
      0,
      obstacle.width - 2 * padding,
      obstacle.topHeight - padding,
    );

    Rect bottomObstacleRect = Rect.fromLTWH(
      obstacle.xPos + padding,
      size.height - obstacle.bottomHeight + padding,
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
    {required Bird bird, required BitcoinManager bitcoinManager,required Size size}) {
  double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
  Rect birdRect = Rect.fromCenter(
    center: Offset(size.width * bird.pos.dx, size.height * bird.pos.dy),
    width: bird.width - 2 * padding,
    height: bird.height - 2 * padding,
  );

  List<BitCoin> collidedBitcoins = [];

  for (var bitcoin in bitcoinManager.bitcoins) {
    final bitcoinRect = Rect.fromCircle(
        center: Offset(bitcoin.pos.dx, bitcoin.pos.dy), radius: 40);
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
