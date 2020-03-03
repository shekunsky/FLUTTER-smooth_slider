library smooth_slider;

import 'package:flutter/material.dart';
import 'model/wave_slider_controler.dart';
import 'badge_slider_painter.dart';
import 'line_slider_painter.dart';

typedef ValueChanged = Function(double value);

class SmoothSlider extends StatefulWidget {
  static const double maxValueDefault = 100.0; //default max value
  static const double startValueDefault = 25.0; //default start value
  static const double widthDefault = 350.0; //default slider width
  static const double heightDefault = 30.0; //default slider height
  static const Color sliderColorDefault = Colors.grey; //default color for line
  static const Color valueColorDefault = Colors.black; //default color for value

  final double maxvalue;
  final double startvalue;
  final double width;
  final double height;
  final Color sliderColor;
  final Color valueColor;
  final ValueChanged valueChanged;

  const SmoothSlider(
      {@required this.valueChanged,
      this.maxvalue = maxValueDefault,
      this.startvalue = startValueDefault,
      this.width = widthDefault,
      this.height = heightDefault,
      this.sliderColor = sliderColorDefault,
      this.valueColor = valueColorDefault});

  @override
  _SmoothSliderState createState() => _SmoothSliderState();
}

class _SmoothSliderState extends State<SmoothSlider>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  double _dragPosition;
  double _dragPercentage;

  WaveSliderController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
    _dragPercentage = widget.startvalue / widget.maxvalue;
    _dragPosition = _dragPercentage * widget.width;
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _updateDragPosition(Offset value) {
    var newDragPosition = 0.0;

    if (value.dx <= 0) {
      newDragPosition = 0;
    } else if (value.dx >= widget.width) {
      newDragPosition = widget.width;
    } else {
      newDragPosition = value.dx;
    }

    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.width;
    });
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    final RenderBox box = context.findRenderObject();
    final offset = box.globalToLocal(start.globalPosition);
    _slideController.setStateToStart();
    _updateDragPosition(offset);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    final RenderBox box = context.findRenderObject();
    final offset = box.globalToLocal(update.globalPosition);
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    _slideController.setStateToStopping();
    setState(() {});
    widget.valueChanged(_dragPercentage * widget.maxvalue);
  }

  void _onTapUp(BuildContext context, TapUpDetails details) {
    _slideController.setStateToStopping();
    setState(() {});
  }

  void _onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox box = context.findRenderObject();
    final offset = box.globalToLocal(details.globalPosition);
    _slideController.setStateToStart();
    _updateDragPosition(offset);
    setState(() {});
    widget.valueChanged(_dragPercentage * widget.maxvalue);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: GestureDetector(
        onTapUp: (TapUpDetails details) => _onTapUp(context, details),
        onTapDown: (TapDownDetails details) => _onTapDown(context, details),
        onHorizontalDragUpdate: (DragUpdateDetails update) =>
            _onDragUpdate(context, update),
        onHorizontalDragStart: (DragStartDetails start) =>
            _onDragStart(context, start),
        onHorizontalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: widget.height,
            width: widget.width,
            child: CustomPaint(
              painter: BadgeSliderPainter(
                  _dragPosition,
                  widget.sliderColor,
                  _slideController.progress,
                  _slideController.state,
                  widget.maxvalue,
                  widget.valueColor),
            ),
          ),
          Container(
            height: widget.height,
            width: widget.width,
            child: CustomPaint(
              painter: LineSliderPainter(
                  _dragPosition,
                  widget.sliderColor,
                  _slideController.progress,
                  _slideController.state,
                  widget.valueColor),
            ),
          ),
        ]),
      ),
    );
  }
}
