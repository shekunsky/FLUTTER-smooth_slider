class LineCurveDefinitions {
  double startOfBend;
  double startOfBezier;

  double endOfBend;
  double endOfBezier;

  double controlHeight;
  double centerPosition;

  double leftControlPointOne;
  double leftControlPointTwo;

  double rightControlPointOne;
  double rightControlPointTwo;

  LineCurveDefinitions(
      this.controlHeight,
      this.centerPosition,
      this.startOfBend,
      this.startOfBezier,
      this.endOfBend,
      this.endOfBezier,
      this.leftControlPointOne,
      this.leftControlPointTwo,
      this.rightControlPointOne,
      this.rightControlPointTwo);
}
