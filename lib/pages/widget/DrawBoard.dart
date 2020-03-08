import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points; // Offset:一个不可变的2D浮点偏移。

  void paint(Canvas canvas, Size size) {
    Paint p = new Paint() //设置笔的属性
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 12.0
      ..strokeJoin = StrokeJoin.bevel;

    for (int i = 0; i < points.length - 1; i++) {
      //画线
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], p);
    }
  }

  /*
   * 是否重绘
   */
  bool shouldRepaint(SignaturePainter other) => other.points != points;
//  bool shouldRepaint(SignaturePainter other) =>true;
}

class DrawBoard extends StatefulWidget {
  final DrawBoardState _drawBoardState = DrawBoardState();
  DrawBoardState createState() {
    return _drawBoardState;
  }

  void addOffset(double x, double y) => _drawBoardState.addOffset(x, y);
  void setScaleFactor(double factor) => _drawBoardState.setScaleFactor(factor);
}

class DrawBoardState extends State<DrawBoard> {
  List<Offset> _points = <Offset>[];
  double _scaleFactor = 10; // 缩放因子

  void addOffset(double x, double y) {
    var offset = Offset(x * _scaleFactor, y * _scaleFactor);
    print(offset);
    this.setState(() {
      _points = new List.from(_points)..add(offset)..add(offset);
    });
  }

  void setScaleFactor(double factor) {
    _scaleFactor = _scaleFactor * factor;
    this.setState(() {
      this._points = this._points.map((e) {
        if (e != null)
          return new Offset(e.dx * _scaleFactor, e.dy * _scaleFactor);
        else
          return null;
      }).toList();
    });
  }

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          //手势探测器，一个特殊的widget，想要给一个widge添加手势，直接用这货包裹起来
          onPanUpdate: (DragUpdateDetails details) {
            //按下
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);
            print(localPosition);
            setState(() {
              _points = new List.from(_points)..add(localPosition);
            });
          },
          onLongPress: () {
            addOffset(10, 10);
          },
          onPanEnd: (DragEndDetails details) => _points.add(null), //抬起来
        ),
        CustomPaint(painter: new SignaturePainter(_points))
      ],
    );
  }
}
