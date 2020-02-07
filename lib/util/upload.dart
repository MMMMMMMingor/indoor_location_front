import 'dart:convert';

import 'package:my_flutter_app1/model/imageUrl.dart';
import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../conf/Config.dart' as Config;
import 'jsonUtil.dart';


// 上传图片
Future<String> uploadImage(String imagePath, String fieldName) async {

  File imageFile = new File(imagePath);

  // 获取token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token");


  var stream =  new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();

  var uri = Uri.parse(Config.url + "api/upload/image");

  var request = new http.MultipartRequest("POST", uri)
    ..headers['Authorization'] = "Bearer $token";

  var multipartFile = new http.MultipartFile(fieldName, stream, length,
      filename: basename(imageFile.path));

  request.files.add(multipartFile);
  var response = await request.send();

  ImageUrl imageUrl = ImageUrl.fromJson(utf8JsonDecode(await response.stream.toBytes()));
  print(imageUrl.toJson());

  return Future(() => imageUrl.imageUrl);
}
