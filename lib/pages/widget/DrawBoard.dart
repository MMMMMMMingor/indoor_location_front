import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawBoard extends StatefulWidget {
  final DrawBoardState _drawBoardState = DrawBoardState();
  DrawBoardState createState() {
    return _drawBoardState;
  }

  void clear() => _drawBoardState.clear();
  void addAP(double x, double y) => _drawBoardState.addAP(x, y);
  void addTrace(double x, double y) => _drawBoardState.addTrace(x, y);
  void setScaleFactor(double factor) => _drawBoardState.setScaleFactor(factor);
}

class DrawBoardState extends State<DrawBoard> {
  List<Offset> _points = <Offset>[];
  int ap_len = 0;
  double _scaleFactor = 10; // 缩放因子
  Offset _startPosition;
  double _xOffsetTotal = 0;
  double _yOffsetTotal = 0;

  void clear() {
    ap_len = 0;
    _scaleFactor = 10;
    _xOffsetTotal = 0;
    _yOffsetTotal = 0;
    _points = <Offset>[];
  }

  void addAP(double x, double y) {
    var offset = Offset(x * _scaleFactor, y * _scaleFactor);
    this.setState(() {
      ap_len = ap_len + 1;
      _points = new List.from(_points)..add(offset);
    });
  }

  void addTrace(double x, double y) {
    var offset = Offset(x * _scaleFactor + _xOffsetTotal, y * _scaleFactor + _yOffsetTotal);
    print(offset);
    this.setState(() {
      _points = new List.from(_points)..add(offset);
    });
  }

  void setScaleFactor(double factor) {
    this.setState(() {
      _scaleFactor *= factor;
      _xOffsetTotal *= factor;
      _yOffsetTotal *= factor;
      _points =
          _points.map((e) => Offset(e.dx * factor, e.dy * factor)).toList();
    });
  }

  void offset(double x, double y) {
    this.setState(() {
      _points = _points.map((e) => Offset(e.dx + x, e.dy + y)).toList();
    });
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        //手势探测器，一个特殊的widget，想要给一个widge添加手势，直接用这货包裹起来
        GestureDetector(
          onPanDown: (details) {
            RenderBox referenceBox = context.findRenderObject();
            _startPosition = referenceBox.globalToLocal(details.globalPosition);
          },
          onPanUpdate: (DragUpdateDetails details) {
            //按下
            RenderBox referenceBox = context.findRenderObject();
            var endPosition =
                referenceBox.globalToLocal(details.globalPosition);
            double x_offset = (endPosition.dx - _startPosition.dx);
            double y_offset = (endPosition.dy - _startPosition.dy);

            _xOffsetTotal += x_offset;
            _yOffsetTotal += y_offset;

            // print("$_xOffsetTotal       $_yOffsetTotal");

            _startPosition = endPosition;

            offset(x_offset, y_offset);
          },
          onLongPress: () {
            addTrace(10, 10);
          },
        ),
        CustomPaint(
          painter: new SignaturePainter(
              _points.sublist(0, ap_len), _points.sublist(ap_len)),
        ),
      ],
    );
  }
}


class SignaturePainter extends CustomPainter {
  final List<Offset> points; // Offset:一个不可变的2D浮点偏移。
  final List<Offset> ap_points; // Offset:一个不可变的2D浮点偏移。

  Paint ap = new Paint() //设置ap笔的属性
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 20
    ..strokeJoin = StrokeJoin.bevel;

  Paint p = new Paint() //设置行踪笔的属性
    ..color = Colors.green
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 12.0
    ..strokeJoin = StrokeJoin.bevel;

  Paint cur_p = new Paint() //设置当前位置笔的属性
    ..color = Colors.yellow
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 12.0
    ..strokeJoin = StrokeJoin.bevel;

  SignaturePainter(this.ap_points, this.points);

  void paint(Canvas canvas, Size size) {
    //画ap
    canvas.drawPoints(PointMode.points, ap_points, ap);

    //画路径
    if (points.length >= 1) {
      canvas.drawPoints(
          PointMode.points, points.sublist(0, points.length - 1), p);
      canvas.drawPoints(PointMode.points, [points.last], cur_p);
    }
  }

  /*
   * 是否重绘
   */
  bool shouldRepaint(SignaturePainter other) => other.points != points;
//  bool shouldRepaint(SignaturePainter other) =>true;
}
