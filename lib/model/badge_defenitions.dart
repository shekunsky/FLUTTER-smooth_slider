class BadgePosition {
  double topPosition;
  double bottomPosition;
  double leftPosition;
  double rightPosition;
  double leftControlPosition;
  double rightControlPosition;

  BadgePosition(this.topPosition, this.bottomPosition, this.leftPosition,
      this.rightPosition, this.leftControlPosition, this.rightControlPosition);
}

class BadgeSizes {
  double minHeight;
  double minWeight;
  double halfHeight;
  double controlHeight;

  BadgeSizes(
      this.controlHeight, this.halfHeight, this.minHeight, this.minWeight);
}

class BadgeDefenitions {
  double radius;
  double progress;
  BadgeSizes sizes;
  BadgePosition position;

  BadgeDefenitions(this.radius, this.progress, this.sizes, this.position);
}
