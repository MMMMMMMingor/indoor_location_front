import 'package:flutter_test/flutter_test.dart';
import 'function_test.dart';

/// 这个文件主要用于各功能模块的内部测试，要在 App 上进行整体测试，请前往 testapp 子目录查看 lib\main.dart。

/// ↓ 这玩意儿是自动生成的，可以拿来做代码注释参考，也可以看看下面用到它的测试范例 ↓
/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

void main() {
  /// 测试范例
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  /// 在 test 目录下新建 function_test.dart 文件（这个文件不同步），并在里面定义 runTest() 函数
  /// 测试用例根据自己负责的部分设计，写在 runTest() 里面
  runTest();
}