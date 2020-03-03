import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_slider/smooth_slider.dart';

void main() {
  testWidgets('Widget changed his value on tap and callback is executed',
      (WidgetTester tester) async {
    double _startValue = 4;
    double _newValue = 4;
    bool _callbackWasExecuted = false;

    // Create the widget by telling the tester to build it.
    SmoothSlider _slider = SmoothSlider(
      maxvalue: 25.0,
      startvalue: _startValue,
      width: 300,
      sliderColor: Colors.green,
      valueColor: Colors.red,
      valueChanged: (value) {
        print('Slider value is ${value.toStringAsFixed(0)}');
        _callbackWasExecuted = true;
        _newValue = value;
      },
    );

    // Build the widget.
    await tester.pumpWidget(_slider);

    // Tap the slider.
    await tester.tap(find.byType(SmoothSlider));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expect to start value changed and callback executed
    expect(_callbackWasExecuted, true);
    expect(_startValue, isNot(equals(_newValue)));
  });
}
