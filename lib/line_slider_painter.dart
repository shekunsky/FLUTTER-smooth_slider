import 'dart:ui';

import 'package:flutter/material.dart';
import 'model/slider_state.dart';
import 'model/line_defenitions.dart';

class LineSliderPainter extends CustomPainter {
  final double sliderPosition;
  final double animationProgress;
  final SliderState sliderState;
  final Color color;
  final Color circlesColor;

  double _previewsSliderPosition = 0;

  Paint paintCircle = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  Paint paintLine = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  LineSliderPainter(this.sliderPosition, this.color, this.animationProgress,
      this.sliderState, this.circlesColor) {
    paintLine.color = color;
    paintCircle.color = circlesColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height / 2;
    final width = size.width;

    switch (sliderState) {
      case SliderState.starting:
        _paintStartupWave(canvas, height, width);
        break;
      case SliderState.resting:
        _paintRestingWave(canvas, height, width);
        break;
      case SliderState.sliding:
        _paintSlidingWave(canvas, height, width);
        break;
      case SliderState.stopping:
        _paintStoppingWave(canvas, height, width);
        break;
      default:
        _paintSlidingWave(canvas, height, width);
        break;
    }

    _paintDots(canvas, height, width, 5, paintCircle);
  }

  void _paintDots(
      Canvas canvas, double height, double width, double radius, Paint paint) {
    final circlePaint = paint..color = Colors.black;
    canvas
      ..drawCircle(Offset(0, height), radius, paint)
      ..drawCircle(Offset(width, height), radius, circlePaint);
  }

  void _paintMarker(Canvas canvas, Offset offset, double radius, paint) {
    canvas.drawCircle(offset, radius, paint);
  }

  void _paintWaveLine(
      Canvas canvas, double height, double width, LineCurveDefinitions wave) {
    final path = Path()
      ..moveTo(0, height)
      ..lineTo(wave.startOfBezier, height)
      ..cubicTo(wave.leftControlPointOne, height, wave.leftControlPointTwo,
          wave.controlHeight, wave.centerPosition, wave.controlHeight)
      ..cubicTo(wave.rightControlPointOne, wave.controlHeight,
          wave.rightControlPointTwo, height, wave.endOfBezier, height)
      ..lineTo(width, height);

    canvas.drawPath(path, paintLine);
  }

  LineCurveDefinitions _calculateLineDefenitions(double height, double width) {
    const bendWidth = 20.0;
    const bezierWidth = 20.0;

    const controlHeight = 0.0;
    final centerPosition = sliderPosition;

    var startOfBend = sliderPosition - bendWidth / 2;
    var startOfBezier = startOfBend - bezierWidth;
    var endOfBend = sliderPosition + bendWidth / 2;
    var endOfBezier = endOfBend + bezierWidth;

    startOfBend = (startOfBend <= 0.0) ? 0.0 : startOfBend;
    startOfBezier = (startOfBezier <= 0.0) ? 0.0 : startOfBezier;
    endOfBend = (endOfBend > width) ? width : endOfBend;
    endOfBezier = (endOfBezier > width) ? width : endOfBezier;

    var leftControlPointOne = startOfBend;
    var leftControlPointTwo = startOfBend;

    var rightControlPointOne = endOfBend;
    var rightControlPointTwo = endOfBend;

    const bendability = 5.0;
    const maxSlideDifference = 5.0;

    var slideDifference = (sliderPosition - _previewsSliderPosition).abs();

    slideDifference = (slideDifference > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    var bend =
        lerpDouble(0.0, bendability, slideDifference / maxSlideDifference);

    final moveLeft = sliderPosition < _previewsSliderPosition;

    bend = moveLeft ? -bend : bend;

    leftControlPointOne += bend;
    leftControlPointTwo += -bend;
    rightControlPointOne += -bend;
    rightControlPointTwo += bend;

    final wave = LineCurveDefinitions(
        controlHeight,
        centerPosition,
        startOfBend,
        startOfBezier,
        endOfBend,
        endOfBezier,
        leftControlPointOne,
        leftControlPointTwo,
        rightControlPointOne,
        rightControlPointTwo);
    return wave;
  }

  void _paintStartupWave(Canvas canvas, double height, double width) {
    final line = _calculateLineDefenitions(height, width);

    final lineHeight = _lerpLine(height, line.controlHeight, animationProgress);

    line.controlHeight = lineHeight;

    _paintWaveLine(canvas, height, width, line);
    _paintMarker(canvas, Offset(sliderPosition, height / 2 + lineHeight), 5,
        paintCircle);
  }

  void _paintRestingWave(Canvas canvas, double height, double width) {
    final path = Path()
      ..moveTo(0.0, height)
      ..lineTo(width, height);
    canvas.drawPath(path, paintLine);

    _paintMarker(canvas, Offset(sliderPosition, 1.75 * height), 5, paintCircle);
  }

  void _paintSlidingWave(Canvas canvas, double height, double width) {
    final line = _calculateLineDefenitions(height, width);
    _paintWaveLine(canvas, height, width, line);
  }

  void _paintStoppingWave(Canvas canvas, double height, double width) {
    final line = _calculateLineDefenitions(height, width);

    final lineHeight = _lerpLine(line.controlHeight, height, animationProgress);

    line.controlHeight = lineHeight;

    _paintWaveLine(canvas, height, width, line);
    _paintMarker(canvas, Offset(sliderPosition, 1.75 * height), 5, paintCircle);
  }

  double _lerpLine(double heightStart, double heightEnd, double progress) =>
      lerpDouble(heightStart, heightEnd, Curves.elasticOut.transform(progress));

  @override
  bool shouldRepaint(LineSliderPainter oldDelegate) {
    _previewsSliderPosition = oldDelegate.sliderPosition;
    return true;
  }
}
