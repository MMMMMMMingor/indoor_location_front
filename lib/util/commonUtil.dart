import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;
import 'jsonUtil.dart';

Future<String> getToken() async {
  // 获取token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");

  return Future(() => token);
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

    return new Future(() => info);
  }
}