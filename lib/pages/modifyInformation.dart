import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/successAndMessage.dart';
import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:my_flutter_app1/util/upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;

class ModifyInformation extends StatefulWidget {
  @override
  ModifyInformationState createState() => ModifyInformationState();
}

class ModifyInformationState extends State<ModifyInformation> {
  GlobalKey<FormState> saveKey = new GlobalKey<FormState>();

  //_imagePath存储用户临时选择尚未确认的头像图片路径
  var _imagePath;
  UserInfo _userInfo = UserInfo();

  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(image != null){

      setState(() {
        this._imagePath = image.path;
      });

      try {
        String avatarUrl = await uploadImage(image.path, "image");

        this._userInfo.avatarUrl = avatarUrl;

      } catch (exception) {
        Toast.show("头像上传错误， 请重新选择", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      }

    }

  }

  // 保存
  void save() async {
    var saveForm = saveKey.currentState;

    if (saveForm.validate()) {
      saveForm.save();

//      print(this._userInfo.toJson());

      var response = await http.post(Config.url + "api/user/modify", headers: {
        "Authorization": "Bearer ${await getToken()}",
        "Content-Type": "application/json"
      }, body: """
        {
          "age": ${this._userInfo.age},
          "avatarUrl": "${this._userInfo.avatarUrl}",
          "gender": "${this._userInfo.gender}",
          "nickname": "${this._userInfo.nickname}",
          "personLabel": "${this._userInfo.personLabel}",
          "vocation": "${this._userInfo.vocation}"
        }
        """);

      var data = SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));


      if(data.success){
        Navigator.popAndPushNamed(context, "/tab");
        Toast.show(data.message, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      }

    }

  }

  void getUserInfo() async {
    // 获取token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      // 获取用户信息
      var response = await http.get(Config.url + "api/user/info",
          headers: {"Authorization": "Bearer $token"});

      UserInfo info = UserInfo.fromJson(utf8JsonDecode(response.bodyBytes));

      this.setState(() {
        this._userInfo = info;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('修改个人信息'),
        ),
        body: new SingleChildScrollView(
            child: new Form(
          key: saveKey,
          child: new Column(children: <Widget>[
            new Container(
                width: 150.0,
                height: 150.0,
                child: Center(
                    child: new GestureDetector(
                  child: new ClipOval(
                    child: new SizedBox(
                        width: 120,
                        height: 120,
                        child: _imagePath == null
                            ? _userInfo == null || _userInfo.avatarUrl == null
                                ? Image.asset("images/head_portraits.jpg",
                                    fit: BoxFit.fill)
                                : Image.network(
                                    this._userInfo.avatarUrl,
                                    fit: BoxFit.fill,
                                  )
                            : Image.file(File(_imagePath), fit: BoxFit.fill)),
                  ),
                  onTap: _openGallery,
                ))),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '昵称  ',
                  style: new TextStyle(fontSize: 20, color: Colors.grey),
                ),
                new SizedBox(
                  width: 245,
                  child: new TextFormField(
                    onSaved: (value) {
                      if (value != "") {
                        this._userInfo.nickname = value;
                      }
                    },
                    style: new TextStyle(fontSize: 20),
                    decoration:
                        new InputDecoration(hintText: this._userInfo.nickname),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '性别  ',
                  style: new TextStyle(fontSize: 20, color: Colors.grey),
                ),
                new SizedBox(
                  width: 245,
                  child: new TextFormField(
                    onSaved: (value) {
                      if (value != "") {
                        this._userInfo.gender = value;
                      }
                    },
                    style: new TextStyle(fontSize: 20),
                    decoration:
                        new InputDecoration(hintText: this._userInfo.gender),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '年龄  ',
                  style: new TextStyle(fontSize: 20, color: Colors.grey),
                ),
                new SizedBox(
                  width: 245,
                  child: new TextFormField(
                    onSaved: (value) {
                      if (value != "") {
                        this._userInfo.age = int.parse(value);
                      }
                    },
                    style: new TextStyle(fontSize: 20),
                    decoration: new InputDecoration(
                        hintText: this._userInfo.age.toString()),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '职业  ',
                  style: new TextStyle(fontSize: 20, color: Colors.grey),
                ),
                new SizedBox(
                  width: 245,
                  child: new TextFormField(
                    onSaved: (value) {
                      if (value != "") {
                        this._userInfo.vocation = value;
                      }
                    },
                    style: new TextStyle(fontSize: 20),
                    decoration:
                        new InputDecoration(hintText: this._userInfo.vocation),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '个人标签  ',
                  style: new TextStyle(fontSize: 20, color: Colors.grey),
                ),
                new SizedBox(
                  width: 205,
                  child: new TextFormField(
                    onSaved: (value) {
                      if (value != "") {
                        this._userInfo.personLabel = value;
                      }
                    },
                    style: new TextStyle(fontSize: 20),
                    decoration:
                        new InputDecoration(hintText: this._userInfo.personLabel),
                  ),
                )
              ],
            ),
            new SizedBox(
              height: 10,
            ),
            new Container(
              width: 260,
              height: 50,
              child: new CupertinoButton(
                child: Text('保存修改'),
                color: Colors.blue,
                disabledColor: Colors.blue,
                onPressed: save,
              ),
            )
          ]),
        )));
  }
}
