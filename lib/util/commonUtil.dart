import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../conf/Config.dart' as Config;
import 'jsonUtil.dart';

Future<String> getToken() async {
  // 获取token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");

  return token;
}

// 展示对话框
void showMessageDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text('提示'),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text("ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<UserInfo> getUserInfo() async {
  // 获取token
  String token = await getToken();
  // 若 token存在
  if (token != null) {
    // 获取用户信息
    var response = await http.get(Config.url + "api/user/info",
        headers: {"Authorization": "Bearer $token"});

    UserInfo info = UserInfo.fromJson(utf8JsonDecode(response.bodyBytes));

    return info;
  }
}

// 检查是否登录
void validateLogin(BuildContext context) async {
  // 获取本地token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");

  // 若 token存在
  if (token == null) {
    Toast.show("请先登录", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

    Navigator.pushNamed(context, '/login');
  } else {
    var decodeToken = new JWT.parse(token);
    int nowTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
    int expTimeStamp = decodeToken.claims["exp"];

    if (nowTimeStamp > expTimeStamp) {
      Toast.show("登录已过期，请重新登录！", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

      Navigator.pushNamed(context, '/login');
    }
  }
}

// 日期解析工具
String dateTimeSimpler(String input) {
  DateTime date = DateTime.parse(input);

  Duration diff = DateTime.now().difference(date);

  if (diff.inSeconds < 30) return "刚刚";

  if (diff.inMinutes < 1) return "${diff.inSeconds}秒前";

  if (diff.inHours < 1) return "${diff.inMinutes}分钟前";

  if (diff.inDays < 1) return "${diff.inHours}小时前";

  if (diff.inDays < 30) return "${diff.inDays}天前";

  return date.toIso8601String().split("T")[0];
}
