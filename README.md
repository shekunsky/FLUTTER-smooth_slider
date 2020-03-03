# smooth_slider

**smooth_slider** widget for Flutter project.

![](SmoothSlider.gif)

## Getting Started

For use **smooth_slider** widget in your project:
1. Add dependency in the **pubspec.yaml** file
```dart
    dependencies:
        flutter:
            sdk: flutter
        smooth_slider:
            git:
                url: git@github.com:shekunsky/FLUTTER-smooth_slider.git
```

2. Import widget in the dart file:
```dart
    import 'package:smooth_slider/smooth_slider.dart';
```

3. Make an instance of the widget.

    ```dart
         static const double paddingConst = 20.0;
         SmoothSlider(
                maxvalue: 25.0,
                startvalue: 4.0,
                width: _screenWidth() - paddingConst * 20,
                sliderColor: Colors.green,
                valueColor: Colors.red,
                valueChanged: (value) {
                  print('Slider value is ${value.toStringAsFixed(0)}');
                  _updateState();
                },
              )
    ```
    
    
    ## License

    Windmill Smart Solutions 2020 ©