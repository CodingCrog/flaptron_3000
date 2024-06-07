import 'dart:ui';
import 'package:flaptron_3000/model/player.dart';

class PhysicsManager {
  static const double _defaultGravity = 1.0; // Gravity constant
  static const double _initialVelocity = -0.2; // Initial velocity
  static const double _maxFallSpeed = 0.5; // Maximum fall speed
  static const double _jumpVelocity = -0.4; // Jump velocity
  static const Offset _initialPosition = Offset(0.4, 0.5); // Initial position

  double velocity;
  final double fallSpeedLimit;
  final double jumpStrength;

  PhysicsManager({
    this.velocity = _initialVelocity,
    this.fallSpeedLimit = _maxFallSpeed,
    this.jumpStrength = _jumpVelocity,
  });

  /// Updates the physics of the player based on the delta time and falling state.
  void updatePhysics(double deltaTime, bool isFallingPaused, PlayerM player) {
    if (!isFallingPaused) {
      velocity = (velocity + _defaultGravity * deltaTime).clamp(-double.infinity, fallSpeedLimit);
    } else {
      velocity = 0;
    }

    final double newY = player.bird.pos.dy + (velocity * deltaTime);
    player.bird.pos = Offset(player.bird.pos.dx, newY);
  }

  /// Resets the physics properties of the player to their initial values.
  void resetPhysics(PlayerM player) {
    velocity = _initialVelocity;
    player.bird.pos = _initialPosition;
  }

  /// Makes the player bird jump by setting the velocity to the jump strength.
  void jump() {
    velocity = jumpStrength;
  }
}
