/// Flutter code sample for Draggable
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return MaterialApp(
      title: _title,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff282d30)),
      home: Scaffold(
        // appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final draggableKey = GlobalKey();
  final feedbackKey = GlobalKey();
  final targetKey = GlobalKey();
  final double size = 80;
  final double padding = 40;
  Offset _origin = Offset.zero;
  double _height = 0, _width = 0;
  int _acceptedData = 0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      double bottom = draggableKey.globalPaintBounds?.bottom ?? 0;
      double left = draggableKey.globalPaintBounds?.left ?? 0;
      setState(() {
        _origin = Offset(left + (size / 2), bottom);
      });
    });
    super.initState();
  }

  void _onDragUpdate(DragUpdateDetails updateDetails) {
    setState(() {
      double top = feedbackKey.globalPaintBounds?.top ?? 0;
      double left = feedbackKey.globalPaintBounds?.left ?? 0;
      if (_acceptedData > 0) {
        top = targetKey.globalPaintBounds?.top ?? 0;
        left = targetKey.globalPaintBounds?.left ?? 0;
      }
      _height = top - _origin.dy;
      _width = left - _origin.dx + (size / 2);
    });
  }

  void _onDragCanceled(Velocity v, Offset o) {
    if (_acceptedData == 0) {
      setState(() {
        _height = 0;
        _width = 0;
      });
    }
  }

  void _onDragCompleted() {
    double top = targetKey.globalPaintBounds?.top ?? 0;
    double left = targetKey.globalPaintBounds?.left ?? 0;
    _height = top - _origin.dy;
    _width = left - _origin.dx + (size / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Draggable<int>(
                  // Data is the value this Draggable stores.
                  data: 10,
                  child: Container(
                    key: draggableKey,
                    color: _acceptedData > 0
                        ? Color(0xffecd823)
                        : Color(0xff9b9e0c),
                    height: size,
                    width: size,
                  ),
                  feedback: Container(
                    key: feedbackKey,
                    color: Color(0xffecd823),
                    height: size,
                    width: size,
                  ),
                  childWhenDragging: Container(
                    color: Color(0xffecd823),
                    height: size,
                    width: size,
                    // child: const Center(
                    //   child: Text('Child When Dragging'),
                    // ),
                  ),
                  onDragUpdate: this._onDragUpdate,
                  onDraggableCanceled: this._onDragCanceled,
                  onDragCompleted: this._onDragCompleted,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: DragTarget<int>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return Container(
                      key: targetKey,
                      color: _acceptedData > 0
                          ? Color(0xffecd823)
                          : Color(0xff9b9e0c),
                      height: size,
                      width: size,
                      child: Center(
                        child: Text('Value is updated to: $_acceptedData'),
                      ),
                    );
                  },
                  onAccept: (int data) {
                    setState(() {
                      _acceptedData += data;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: _origin.dx,
          top: _origin.dy,
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.rotationY(_width < 0 ? math.pi : 0),
            child: CustomPaint(
              painter: PathPainter(
                  color: _acceptedData > 0
                      ? Color(0xff29ef25)
                      : Color(0xfff0c733)),
              child: _height > 0
                  ? SizedBox(
                      width: _width.abs(),
                      height: _height,
                      // child: Container(color: Colors.red),
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  PathPainter({this.color = const Color(0xfff0c733)}) : super();

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.56;

    Path path = Path();
    path.moveTo(0, 0);
    path.cubicTo(size.width * 0.0, size.height * 0.5, size.width * 1,
        size.height * 0.5, size.width * 1, size.height * 1);
    canvas.drawPath(path, paint);
    canvas.drawPath(
        path,
        paint
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(4)));
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject?.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
