/// manage data, determine movement.

import "MessageHandler.dart";

class WiFiDataManager {
  // 暂存wifi数据，以一个列表的形式（如链表）保存wifi数据
  List<Map<String, int>> _wifiData;

  // sender
  WiFiMessageSender sender;

  // 预处理控制开关
  bool preprocess = false;

  // wifi数据的队列深度，列表最多可保存的wifi数据组，如果只根据当前结果及上次结果确定是否移动，那么只用2
  // 暂时还不用到
  final int _maximumQueueDepth = 2;

  final int gap = 5;

  // 构造方法
  WiFiDataManager({this.sender, this.preprocess}) {
    _wifiData = new List<Map<String, int>>();
  }

  // 返回最新的一组wifi数据（用于消息发送）
  // 我感觉这个函数和我后面的addData功能上有重叠的部分
  Map<String, int> getCurrentData() {
    if (_wifiData.isNotEmpty) {
      return _wifiData.elementAt(_wifiData.length - 1);
    } else {
      return Map<String, int>();
    }
  }

  // 往列表里添加刚刚采集到的wifi数据
  void addData(Map<String, int> newData) {
    if (_wifiData.length == _maximumQueueDepth) {
      /// 当队列长度为2才适用
      // _wifiData = _wifiData.reversed;
      _wifiData[0] = _wifiData[1];
      _wifiData.removeLast();
    }
    _wifiData.add(newData);

    /// 如果移动了更新列表并且发送实时信息
    if (_determineMovement()) {
      if (sender != null) sender.sendMessage(_wifiData.last);
    }
  }

  // 判断用户是否移动，受preprocess控制
  bool _determineMovement() {
    if (preprocess == false || _wifiData.length <= 1) return true;

    // 允许信号强度在一定范围波动
    final int gap = 2;
    bool ismove = false, has = false;

    // 两个用来比较的工具人
    Map<String, int> map1 = _wifiData.elementAt(0);
    Map<String, int> map2 = _wifiData.elementAt(1);
    Iterator<MapEntry> it1 = map1.entries.iterator;
    while (it1.moveNext()) {
      MapEntry entry1 = it1.current;
      if (map2.containsKey(entry1.key)) {
        has = true;
        if (map2[entry1.key] >= 0 || entry1.value >= 0) continue;
        if ((map2[entry1.key] <= -60 &&
                (map2[entry1.key] - entry1.value).abs() > gap * 2) ||
            (map2[entry1.key] > -60 &&
                (map2[entry1.key] - entry1.value).abs() > gap)) {
          ismove = true;
          break;
        }
      }
    }

    /// if map2 is all new AP, then just return true to indicate movement
    if (has)
      return ismove;
    else
      return true;
  }
}
