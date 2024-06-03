import 'dart:ui';

import 'package:flaptron_3000/model/player.dart';

const double startGravity = 1.0; // 120% of display per square-second
const double startVelocity = -0.2;
const double startFallSpeedLimit = 0.5; // 50% of display per second
const double startJumpStrength = -0.4; // 50% of display per second
const Offset startPosition = Offset(0.4, 0.5); // in percentage of screen size

class PhysicsManager {
  double gravity = startGravity; // 120% of display per square-second
  double velocity = startVelocity;
  double fallSpeedLimit = startFallSpeedLimit; // 50% of display per second
  double jumpStrength = startJumpStrength; // 50% of display per second

  void updatePhysics(double deltaTime, bool isFallingPaused, PlayerM player) {
    if (!isFallingPaused) {
      velocity +=
          gravity * deltaTime; // Increment velocity by gravity over time
    } else {
      velocity =
          0; // Ensure velocity is zeroed to prevent any downward movement
    }
    velocity > fallSpeedLimit ? velocity = fallSpeedLimit : velocity;
    final dy = player.bird.pos.dy +
        (velocity * deltaTime); // Update position by velocity over time

    player.bird.pos = Offset(player.bird.pos.dx, dy);
  }

  void resetPhysics(PlayerM player) {
    gravity = startGravity;
    velocity = startVelocity;
    fallSpeedLimit = startFallSpeedLimit;
    jumpStrength = startJumpStrength;
    player.bird.pos = startPosition;
  }

  void jump() {
    velocity = jumpStrength;
  }
}
