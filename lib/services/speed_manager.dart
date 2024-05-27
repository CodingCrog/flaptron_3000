const double startObstacleSpeedMultiplier = 0.5;

class SpeedManager {
  static double baseMoveSpeed = 5.0;
  static double speedMultiplier = startObstacleSpeedMultiplier;
  static double get speed => baseMoveSpeed * speedMultiplier;

  static void resetObstacleSpeed() {
    updateObstacleSpeed(speed: startObstacleSpeedMultiplier);
  }

  static void updateObstacleSpeed({double? speed}) {
    speedMultiplier =
        speed ?? startObstacleSpeedMultiplier; // Reset to normal speed
  }

  static void increaseSpeedBy({required double speed}) {
    updateObstacleSpeed(speed: speedMultiplier + speed);
  }
}
