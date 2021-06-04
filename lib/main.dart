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
  // final draggableKey = GlobalKey();
  // final feedbackKey = GlobalKey();
  // final targetKey = GlobalKey();
  final double size = 56;
  final double padding = 40;
  // Offset _origin = Offset.zero;
  // double _height = 0, _width = 0;
  int _acceptedData = 0;
  List<Map> _balls = [
    {
      'id': 1,
      'name': 'A',
      'paraphernalia_id': 1,
      'origin': Offset.zero,
      'path_painter_width': 0,
      'path_painter_height': 0,
    },
    {
      'id': 2,
      'name': 'B',
      'paraphernalia_id': 2,
      'origin': Offset.zero,
      'path_painter_width': 0,
      'path_painter_height': 0,
    },
    {
      'id': 3,
      'name': 'C',
      'paraphernalia_id': 3,
      'origin': Offset.zero,
      'path_painter_width': 0,
      'path_painter_height': 0,
    },
    {
      'id': 4,
      'name': 'D',
      'paraphernalia_id': 4,
      'origin': Offset.zero,
      'path_painter_width': 0,
      'path_painter_height': 0,
    },
    {
      'id': 5,
      'name': 'E',
      'paraphernalia_id': 5,
      'origin': Offset.zero,
      'path_painter_width': 0,
      'path_painter_height': 0,
    },
  ];
  List<GlobalKey> draggableKeys = [];
  List<GlobalKey> feedbackKeys = [];
  List<Map> _paraphernalia = [
    {
      'id': 1,
      'name': 'I',
      'ball_id': 1,
    },
    {
      'id': 2,
      'name': 'II',
      'ball_id': 2,
    },
    {
      'id': 3,
      'name': 'III',
      'ball_id': 3,
    },
    {
      'id': 4,
      'name': 'IV',
      'ball_id': 4,
    },
    {
      'id': 5,
      'name': 'V',
      'ball_id': 5,
    },
  ];
  List<GlobalKey> targetKeys = [];
  Map _ball_paraphernalia = new Map();

  @override
  void initState() {
    draggableKeys = _balls.map((each) => GlobalKey()).toList();
    feedbackKeys = _balls.map((each) => GlobalKey()).toList();
    targetKeys = _paraphernalia.map((each) => GlobalKey()).toList();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _balls = _balls.asMap().entries.map((each) {
          double bottom =
              draggableKeys[each.key].globalPaintBounds?.bottom ?? 0;
          double left = draggableKeys[each.key].globalPaintBounds?.left ?? 0;
          each.value['origin'] = Offset(left + (size / 2), bottom);
          return each.value;
        }).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _balls
                    .asMap()
                    .entries
                    .map((each) => Draggable<int>(
                          // Data is the value this Draggable stores.
                          data: each.value['id'],
                          child: Container(
                            key: draggableKeys[each.key],
                            color: _ball_paraphernalia[each.value['id']] != null
                                ? Color(0xffecd823)
                                : Color(0xff9b9e0c),
                            height: size,
                            width: size,
                            child: Center(child: Text(each.value['name'])),
                          ),
                          feedback: Container(
                            key: feedbackKeys[each.key],
                            color: Color(0xffecd823),
                            height: size,
                            width: size,
                          ),
                          childWhenDragging: Container(
                            color: Color(0xffecd823),
                            height: size,
                            width: size,
                            child: Center(child: Text(each.value['name'])),
                          ),
                          onDragStarted: () {
                            _ball_paraphernalia.remove(each.value['id']);
                          },
                          onDragUpdate: (DragUpdateDetails updateDetails) {
                            setState(() {
                              double top = feedbackKeys[each.key]
                                      .globalPaintBounds
                                      ?.top ??
                                  0;
                              double left = feedbackKeys[each.key]
                                      .globalPaintBounds
                                      ?.left ??
                                  0;
                              if (_acceptedData > 0) {
                                top = feedbackKeys[each.key]
                                        .globalPaintBounds
                                        ?.top ??
                                    0;
                                left = feedbackKeys[each.key]
                                        .globalPaintBounds
                                        ?.left ??
                                    0;
                              }
                              each.value['path_painter_height'] =
                                  top - each.value['origin'].dy;
                              each.value['path_painter_width'] =
                                  left - each.value['origin'].dx + (size / 2);
                            });
                          },
                          onDraggableCanceled: (Velocity v, Offset o) {
                            _ball_paraphernalia.remove(each.value['id']);
                            setState(() {
                              each.value['path_painter_height'] = 0;
                              each.value['path_painter_width'] = 0;
                            });
                          },
                          onDragCompleted: () {
                            var paraphernaliaId =
                                _ball_paraphernalia[each.value['id']];
                            var key = _paraphernalia.asMap().keys.firstWhere(
                                (k) =>
                                    _paraphernalia[k]['id'] == paraphernaliaId);
                            double top =
                                targetKeys[key].globalPaintBounds?.top ?? 0;
                            double left =
                                targetKeys[key].globalPaintBounds?.left ?? 0;
                            setState(() {
                              each.value['path_painter_height'] =
                                  top - each.value['origin'].dy;
                              each.value['path_painter_width'] =
                                  left - each.value['origin'].dx + (size / 2);
                            });
                          },
                        ))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _paraphernalia
                    .asMap()
                    .entries
                    .map((each) => DragTarget<int>(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return Container(
                              key: targetKeys[each.key],
                              color: _ball_paraphernalia.keys.firstWhere(
                                          (k) =>
                                              _ball_paraphernalia[k] ==
                                              each.value['id'],
                                          orElse: () => null) !=
                                      null
                                  ? Color(0xffecd823)
                                  : Color(0xff9b9e0c),
                              height: size,
                              width: size,
                              child: Center(
                                child: Text(each.value['name']),
                              ),
                            );
                          },
                          onAccept: (int ballId) {
                            _ball_paraphernalia[ballId] = each.value['id'];
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        ..._balls.map((each) {
          var painterColor = Color(0xfff0c733);
          var paraphernaliaId = _ball_paraphernalia[each['id']];
          if (paraphernaliaId != null) {
            // var paraphernalia = _paraphernalia.firstWhere((k) => k['id'] == paraphernaliaId);
            painterColor = each['paraphernalia_id'] == paraphernaliaId
                ? Color(0xff29ef25)
                : Color(0xffef2525);
          }
          return Positioned(
            left: each['origin'].dx,
            top: each['origin'].dy,
            child: Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.rotationY(
                  each['path_painter_width'] < 0 ? math.pi : 0),
              child: CustomPaint(
                painter: PathPainter(color: painterColor),
                child: each['path_painter_height'] > 0
                    ? SizedBox(
                        width: each['path_painter_width'].abs(),
                        height: each['path_painter_height'],
                        // child: Container(color: Colors.red),
                      )
                    : Container(),
              ),
            ),
          );
        }).toList()
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
