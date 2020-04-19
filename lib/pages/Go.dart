import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/APMetaPage.dart';
import 'package:my_flutter_app1/model/successAndMessage.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Go extends StatefulWidget {
  const Go({Key key}) : super(key: key);

  GoState createState() => GoState();
}

class GoState extends State<Go> {
  List<Widget> _listView = new List();

  // 删除metadata
  void _deleteMetaData(String metadataId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("确认删除操作"),
          content: SizedBox(
            height: ScreenUtil().setHeight(50.0),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("您确定删除该指纹库记录吗？"),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text("确定"),
              onPressed: () async {
                // 获取本地token
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String token = prefs.getString("token");

                // 若 token存在
                if (token != null) {
                  // 获取用户信息
                  var response = await http.delete(
                      Config.url + "api/location/$metadataId",
                      headers: {"Authorization": "Bearer $token"});

                  SuccessAndMessage successAndMessage =
                      SuccessAndMessage.fromJson(
                          utf8JsonDecode(response.bodyBytes));

                  if (successAndMessage.success == true) {
                    _getdata(1, 10);
                    Toast.show("删除成功", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    Navigator.pop(context);
                  } else {
                    Toast.show("删除失败", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _getdata(int pageNo, int pageSize) async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      // 获取用户信息
      var response = await http.get(
          Config.url + "api/location/query/$pageNo/$pageSize",
          headers: {"Authorization": "Bearer $token"});

      APMetaPage apMetaPage =
          APMetaPage.fromJson(utf8JsonDecode(response.bodyBytes));

      List<APMeta> apMetas = apMetaPage.records;

      final List<Widget> listView = new List();

      if (apMetas == null || apMetas.length == 0) {
        listView.add(
          ListTile(
            title: Center(
              child: Text("您未添加任何指纹信息，请点击右下方按钮进行添加。"),
            ),
            leading: Icon(Icons.help),
          ),
        );
      }

      for (var apMeta in apMetas) {
        listView.add(Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("${apMeta.remark}    "),
                subtitle: Text("${dateTimeSimpler(apMeta.createTime)}"),
                leading: Icon(Icons.receipt),
                trailing: Text("指纹数: ${apMeta.count}"),
              ),
              ButtonBar(
                children: <Widget>[
                  Offstage(
                    offstage: apMeta.count < 10,
                    child: MaterialButton(
                      child: Text(
                        "选择",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      colorBrightness: Brightness.light,
                      onPressed: () {
                        Navigator.pop(context, apMeta);
                      },
                    ),
                  ),
                  MaterialButton(
                    child: Text(
                      "添加指纹",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    colorBrightness: Brightness.light,
                    onPressed: () async {
                      // await Navigator.pushNamed(context, '/collect',
                      //     arguments: apMeta);
                      //跳到新的指纹收集页面
                           await Navigator.pushNamed(context, '/collect',arguments: apMeta);
                      await Future.delayed(new Duration(seconds: 1));
                      this._getdata(1, 10);
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "删除",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.redAccent,
                    colorBrightness: Brightness.light,
                    onPressed: () {
                      this._deleteMetaData(apMeta.metaId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
      }
      this.setState(() {
        this._listView = listView;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的指纹库信息"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/createLocationService');
          await Future.delayed(new Duration(seconds: 1));
          this._getdata(1, 10);
        },
      ),
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                        ScreenUtil().setWidth(20), 0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              key: ValueKey("text"),
                              child: Text("历史记录"),
                              onPressed: () {},
                              textTheme: ButtonTextTheme.normal,
                              textColor: Colors.blue,
                              disabledTextColor: Colors.red,
                              color: Colors.white,
                              disabledColor: Colors.grey,
                              highlightColor: Colors.grey,
                              // 按下的背景色
                              splashColor: Colors.green,
                              // 水波纹颜色
                              colorBrightness: Brightness.light,
                              // 主题
                              elevation: 10,
                              highlightElevation: 10,
                              disabledElevation: 10,
                              padding: EdgeInsets.all(10),
//       MaterialButton shape 子类才起效
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(
                                      color: Color(0xFFFFFFFF),
                                      style: BorderStyle.solid,
                                      width: 1)),
                              clipBehavior: Clip.antiAlias,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              animationDuration: Duration(seconds: 1),
                              minWidth: 200,
                              height: 50,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              key: ValueKey("text"),
                              child: Text("我的收藏"),
                              onPressed: () {},
                              textTheme: ButtonTextTheme.normal,
                              textColor: Colors.blue,
                              disabledTextColor: Colors.red,
                              color: Colors.white,
                              disabledColor: Colors.grey,
                              highlightColor: Colors.grey,
                              // 按下的背景色
                              splashColor: Colors.green,
                              // 水波纹颜色
                              colorBrightness: Brightness.light,
                              // 主题
                              elevation: 10,
                              highlightElevation: 10,
                              disabledElevation: 10,
                              padding: EdgeInsets.all(10),
//       MaterialButton shape 子类才起效
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(
                                      color: Color(0xFFFFFFFF),
                                      style: BorderStyle.solid,
                                      width: 1)),
                              clipBehavior: Clip.antiAlias,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              animationDuration: Duration(seconds: 1),
                              minWidth: 200,
                              height: 50,
                            ),
                          )
                        ],
                      ),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(20), 0, 20, 10),
                      child: Container(
                        child: ListView(children: this._listView),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0XFFF0F0F0),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
