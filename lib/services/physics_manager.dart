import 'dart:ui';

import 'package:flaptron_3000/model/player.dart';

class PhysicsManager {
  static const double defaultGravity = 1.0; // Gravity constant
  static const double initialVelocity = -0.2; // Initial velocity
  static const double maxFallSpeed = 0.5; // Maximum fall speed
  static const double jumpVelocity = -0.4; // Jump velocity
  static const Offset initialPosition = Offset(0.4, 0.5); // Initial position

  double gravity;
  double velocity;
  final double fallSpeedLimit;
  final double jumpStrength;

  PhysicsManager({
    this.gravity = defaultGravity,
    this.velocity = initialVelocity,
    this.fallSpeedLimit = maxFallSpeed,
    this.jumpStrength = jumpVelocity,
  });

  void updatePhysics(double deltaTime, bool isFallingPaused, PlayerM player) {
    if (!isFallingPaused) {
      velocity += gravity * deltaTime;
      if (velocity > fallSpeedLimit) {
        velocity = fallSpeedLimit;
      }
    } else {
      velocity = 0;
    }

    final double newY = player.bird.pos.dy + (velocity * deltaTime);
    player.bird.pos = Offset(player.bird.pos.dx, newY);
  }

  void resetPhysics(PlayerM player) {
    gravity = defaultGravity;
    velocity = initialVelocity;
    player.bird.pos = initialPosition;
  }

  void jump() {
    velocity = jumpStrength;
  }
}
