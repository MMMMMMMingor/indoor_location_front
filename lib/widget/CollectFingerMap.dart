import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/provider/mapProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

class CollectFingerMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    List<Offset> points= <Offset>[];
    return new Stack(
      children: [
        //手势探测器，一个特殊的widget，想要给一个widge添加手势，直接用这货包裹起来
        GestureDetector(
          onPanDown: (details) {
            RenderBox referenceBox = context.findRenderObject();
            mapProvider.startPosition =
                referenceBox.globalToLocal(details.globalPosition);
          },
          onPanUpdate: (DragUpdateDetails details) {
            //按下
            RenderBox referenceBox = context.findRenderObject();
            var endPosition =
                referenceBox.globalToLocal(details.globalPosition);
            double xOffset = (endPosition.dx - mapProvider.startPosition.dx);
            double yOffset = (endPosition.dy - mapProvider.startPosition.dy);

            mapProvider.xOffsetTotal += xOffset;
            mapProvider.yOffsetTotal += yOffset;

            // print("$_xOffsetTotal       $_yOffsetTotal");

            mapProvider.startPosition = endPosition;

            mapProvider.offset(xOffset, yOffset);
          },
          // onLongPress: () {
          //   mapProvider.addTrace(10, 10);
          // },
          onLongPressEnd: (details){
             RenderBox referenceBox = context.findRenderObject();
             var pointPosition=referenceBox.globalToLocal(details.globalPosition);
           mapProvider.addTrace(pointPosition.dx, pointPosition.dy);
        
            Toast.show(pointPosition.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
          },
   
        ),
        
        CustomPaint(
          painter: new PointPainter(
            
              points
        ),
        )
      ],
    );
  }
}

class PointPainter extends CustomPainter {
  final List<Offset> points; // Offset:一个不可变的2D浮点偏移。
  

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

  Paint curP = new Paint() //设置当前位置笔的属性
    ..color = Colors.yellow
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..strokeWidth = 12.0
    ..strokeJoin = StrokeJoin.bevel;

  PointPainter(this.points);

  void paint(Canvas canvas, Size size) {
   
    //画用户自己长按的点
      canvas.drawPoints(PointMode.points, points, curP);
    
  }

  /*
   * 是否重绘
   */
  bool shouldRepaint(PointPainter other) => other.points != points;
//  bool shouldRepaint(SignaturePainter other) =>true;
}
