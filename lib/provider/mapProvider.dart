import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MapProvider with ChangeNotifier {
  List<Offset> _points = <Offset>[];
  int _apLen = 0;
  double _scaleFactor = 5;  // 缩放因子
  Offset _startPosition;
  double _xOffsetTotal = 0; // X轴偏移量
  double _yOffsetTotal = 0; // Y轴偏移量

  List<Offset> get points => _points;
  int get apLen => _apLen;
  double get scaleFactor => _scaleFactor;
  Offset get startPosition => _startPosition;
  double get xOffsetTotal => _xOffsetTotal;
  double get yOffsetTotal => _yOffsetTotal;

  set startPosition(Offset offset) => this._startPosition = offset;
  set xOffsetTotal(double x) => this._xOffsetTotal = x;
  set yOffsetTotal(double y) => this._yOffsetTotal = y;

  void clear() {
    _apLen = 0;
    _scaleFactor = 5;
    _xOffsetTotal = 0;
    _yOffsetTotal = 0;
    _points = <Offset>[];

    notifyListeners();
  }

  void addAP(double x, double y) {
    var offset = Offset(x * _scaleFactor, y * _scaleFactor);
    _apLen = _apLen + 1;
    _points = new List.from(_points)..add(offset);

    notifyListeners();
  }

  void addTrace(double x, double y) {
    var offset = Offset(
        x * _scaleFactor + _xOffsetTotal, y * _scaleFactor + _yOffsetTotal);
    print(offset);
    _points = new List.from(_points)..add(offset);
print(_points);
    notifyListeners();
  }

  void setScaleFactor(double factor) {
    _scaleFactor *= factor;
    _xOffsetTotal *= factor;
    _yOffsetTotal *= factor;
    _points = _points.map((e) => Offset(e.dx * factor, e.dy * factor)).toList();
    notifyListeners();
  }

  void offset(double x, double y) {
    _points = _points.map((e) => Offset(e.dx + x, e.dy + y)).toList();
    notifyListeners();
  }
}
