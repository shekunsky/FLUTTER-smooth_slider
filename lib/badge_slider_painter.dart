import 'dart:ui';

import 'package:flutter/material.dart';
import 'model/badge_defenitions.dart';
import 'model/slider_state.dart';

class BadgeSliderPainter extends CustomPainter {
  static const double fontSize = 14; //Size for font

  final double maxProgress;
  final double sliderPosition;
  final double animationProgress;
  final SliderState sliderState;
  final Color color;
  final Color valueColor;

  double _previewsSliderPosition = 0;

  final Paint backgroundPaintBadge = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  Color textColors = Colors.white;
  Color limitsTextColors = Colors.black;

  BadgeSliderPainter(this.sliderPosition, this.color, this.animationProgress,
      this.sliderState, this.maxProgress, this.valueColor);

  @override
  void paint(Canvas canvas, Size size) {
    switch (sliderState) {
      case SliderState.starting:
        _paintStart(canvas, size);
        break;
      case SliderState.resting:
        _paintResting(canvas, size);
        break;
      case SliderState.sliding:
        _paintSliding(canvas, size);
        break;
      case SliderState.stopping:
        _paintStopping(canvas, size);
        break;
      default:
        _paintSliding(canvas, size);
        break;
    }
  }

  @override
  bool shouldRepaint(BadgeSliderPainter oldDelegate) {
    _previewsSliderPosition = oldDelegate.sliderPosition;
    return true;
  }

  void _paintBadgeBackground(
      Canvas canvas, Size size, double centerPosition, BadgeDefenitions defen) {
    defen.position
      ..topPosition += defen.sizes.controlHeight / 2
      ..bottomPosition += defen.sizes.controlHeight / 2;

    final path = Path()
      ..moveTo(defen.position.leftPosition + defen.radius,
          defen.position.topPosition)
      ..lineTo(defen.position.rightPosition - defen.radius,
          defen.position.topPosition)
      ..quadraticBezierTo(
          defen.position.rightPosition,
          defen.position.topPosition,
          defen.position.rightPosition,
          defen.position.topPosition + defen.radius)
      ..quadraticBezierTo(
          defen.position.rightControlPosition,
          defen.sizes.halfHeight,
          defen.position.rightPosition,
          defen.position.bottomPosition - defen.radius)
      ..quadraticBezierTo(
          defen.position.rightPosition,
          defen.position.bottomPosition,
          defen.position.rightPosition - defen.radius,
          defen.position.bottomPosition)
      ..lineTo(defen.position.leftPosition + defen.radius,
          defen.position.bottomPosition)
      ..quadraticBezierTo(
          defen.position.leftPosition,
          defen.position.bottomPosition,
          defen.position.leftPosition,
          defen.position.bottomPosition - defen.radius)
      ..quadraticBezierTo(
          defen.position.leftControlPosition,
          defen.sizes.halfHeight,
          defen.position.leftPosition,
          defen.position.topPosition + defen.radius)
      ..quadraticBezierTo(
          defen.position.leftPosition,
          defen.position.topPosition,
          defen.position.leftPosition + defen.radius,
          defen.position.topPosition);

    canvas.drawPath(path, backgroundPaintBadge);

    _textPainter(defen.progress, defen.sizes.minHeight, defen.sizes.minWeight)
        .paint(canvas,
            Offset(defen.position.leftPosition, defen.position.topPosition));

    _textPainterForLimits(0.0, defen.sizes.minHeight, 0.0)
        .paint(canvas, const Offset(-5, 60));

    _textPainterForLimits(maxProgress, defen.sizes.minHeight, 0.0)
        .paint(canvas, Offset(size.width - _offsetForMaxLimitLabel(), 60));
  }

  double _offsetForMaxLimitLabel() {
    const widthForDigit = 3.75;
    final numberOfDigits = maxProgress.toInt().toString().length - 1;
    return 5 + numberOfDigits * widthForDigit;
  }

  BadgeDefenitions _calculateBadgetDefenition(
      double height, double width, double centerPosition) {
    const radius = 3.0;
    final halfHeight = height / 2;
    const heightToWidthRatio = 16 / 9;

    final progress = sliderPosition / width * maxProgress;

    final plusHeight = halfHeight / maxProgress * progress;

    final minHeight = halfHeight + plusHeight / 2;
    final minWeight = minHeight * heightToWidthRatio;

    final topPosition = halfHeight - minHeight / 2;
    final bottomPosition = halfHeight + minHeight / 2;

    final leftPosition = centerPosition - minWeight / 2;
    final rightPosition = centerPosition + minWeight / 2;

    const bendability = 5.0;
    const maxSlideDifference = 5.0;

    const controlHeight = 0.0;

    var slideDifference = (sliderPosition - _previewsSliderPosition).abs();

    slideDifference = (slideDifference > maxSlideDifference)
        ? maxSlideDifference
        : slideDifference;

    var bend =
        lerpDouble(0.0, bendability, slideDifference / maxSlideDifference);

    final moveLeft = sliderPosition < _previewsSliderPosition;

    bend = moveLeft ? -bend : bend;

    var leftControlPosition = leftPosition;
    var rightControlPosition = rightPosition;

    if (moveLeft) {
      leftControlPosition = leftPosition;
      rightControlPosition = rightPosition - bend;
    } else {
      leftControlPosition = leftPosition - bend;
      rightControlPosition = rightPosition;
    }

    return BadgeDefenitions(
        radius,
        progress,
        BadgeSizes(controlHeight, halfHeight, minHeight, minWeight),
        BadgePosition(topPosition, bottomPosition, leftPosition, rightPosition,
            leftControlPosition, rightControlPosition));
  }

  TextPainter _textPainter(double value, double height, double width) {
    final textStyle = TextStyle(
        fontSize: fontSize, color: textColors, fontWeight: FontWeight.bold);

    final textSpan = TextSpan(text: value.round().toString(), style: textStyle);

    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: width);

    return textPainter;
  }

  TextPainter _textPainterForLimits(double value, double height, double width) {
    final textStyle = TextStyle(
        fontSize: fontSize,
        color: limitsTextColors,
        fontWeight: FontWeight.bold);

    final textSpan = TextSpan(text: value.round().toString(), style: textStyle);

    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: width);

    return textPainter;
  }

  void _paintStopping(Canvas canvas, Size size) {
    final line =
        _calculateBadgetDefenition(size.height, size.width, sliderPosition);

    final lineHeight =
        _lerpLine(line.sizes.controlHeight, size.height, animationProgress);

    backgroundPaintBadge.color = const Color(0x00000000);

    textColors = valueColor;
    line.sizes.controlHeight = lineHeight;

    _paintBadgeBackground(canvas, size, sliderPosition, line);
  }

  void _paintSliding(Canvas canvas, Size size) {
    final defen =
        _calculateBadgetDefenition(size.height, size.width, sliderPosition);

    backgroundPaintBadge.color =
        const Color(0x00000000).withOpacity(1 - animationProgress);
    textColors = const Color(0xFFFFFFFF);

    _paintBadgeBackground(canvas, size, sliderPosition, defen);
  }

  void _paintResting(Canvas canvas, Size size) {
    final defen =
        _calculateBadgetDefenition(size.height, size.width, sliderPosition);
    defen.sizes.controlHeight += size.height;

    backgroundPaintBadge.color = const Color(0x00000000);
    textColors = valueColor;

    _paintBadgeBackground(canvas, size, sliderPosition, defen);
  }

  void _paintStart(Canvas canvas, Size size) {
    final defen =
        _calculateBadgetDefenition(size.height, size.width, sliderPosition);

    backgroundPaintBadge.color = const Color(0xFF000000);
    textColors = const Color(0xFFFFFFFF);

    backgroundPaintBadge.color =
        const Color(0x00000000).withOpacity(animationProgress);

    textColors = const Color(0xFFFFFFFF);

    _paintBadgeBackground(canvas, size, sliderPosition, defen);
  }

  double _lerpLine(double heightStart, double heightEnd, double progress) =>
      lerpDouble(heightStart, heightEnd, Curves.elasticOut.transform(progress));
}
