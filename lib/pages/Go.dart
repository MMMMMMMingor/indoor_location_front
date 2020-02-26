import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;
import 'package:my_flutter_app1/model/APMeta.dart';
import 'package:my_flutter_app1/model/APMetaPage.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Go extends StatefulWidget {
  const Go({Key key}) : super(key: key);

  GoState createState() => GoState();
}

class GoState extends State<Go> {
  List<Widget> _listView = new List();

  void _getdata(int pageNo, int pageSize) async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      // 获取用户信息
      var response = await http.get(
          Config.url + "/api/location/query/$pageNo/$pageSize",
          headers: {"Authorization": "Bearer $token"});
      APMetaPage apMetaPage =
          APMetaPage.fromJson(utf8JsonDecode(response.bodyBytes));
      List<APMeta> apMetas = apMetaPage.records;

      final List<Widget> listView = new List();
      for (var apMeta in apMetas) {
        print(apMeta.toJson());

        String message = dateTimeAnalyze(apMeta.createTime);

        listView.add(
          ListTile(
            title: Text(
                "${apMeta.bssid1}    ${apMeta.bssid2}    ${apMeta.bssid3}"),
            subtitle: Text("$message"),
            leading: Icon(Icons.network_wifi),
          ),
        );
      }
      this.setState(() {
        this._listView = listView;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _getdata(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 10, 20),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 0, 5),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 4,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Container(
                                                            width: 15,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white70,
                                                                  width: 1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          150.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Center(
                                                          child: Container(
                                                            child: TextField(
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                                decoration: InputDecoration.collapsed(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "输入起点",
                                                                    hintStyle:
                                                                        TextStyle())),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              Divider(
                                                height: 1.0,
                                                indent: 30.0,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                  flex: 4,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Container(
                                                            width: 15,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white70,
                                                                  width: 1),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          150.0)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Center(
                                                          child: Container(
                                                            child: TextField(
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                                decoration: InputDecoration.collapsed(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "输入终点",
                                                                    hintStyle:
                                                                        TextStyle())),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF0F0F0),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(150.0))),
                                  child: Center(
                                    child: IconButton(
                                        icon: Icon(Icons.add),
                                        padding: EdgeInsets.all(4.0),
                                        iconSize: 30,
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              '/createLocationService');
                                        },
                                        color: Colors.blueAccent,
                                        highlightColor: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0XFFF0F0F0),
                          border: Border.all(color: Colors.white70, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
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

// class First extends StatelessWidget {
//   final List<Widget> _listView = new List();

//   void _getdata(int pageNo, int pageSize) async {
//     // 获取本地token
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString("token");

//     // 若 token存在
//     if (token != null) {
//       // 获取用户信息
//       var response = await http.get(
//           Config.url + "/api/location/query/$pageNo/$pageSize",
//           headers: {"Authorization": "Bearer $token"});
//       APMetaPage apMetaPage =
//           APMetaPage.fromJson(utf8JsonDecode(response.bodyBytes));
//       List<APMeta> apMetas = apMetaPage.records;

//       for (var apMeta in apMetas) {
//         print(apMeta.toJson());
//         _listView.add(
//           ListTile(
//             title: Text(
//                 "${apMeta.bssid1}    ${apMeta.bssid2}    ${apMeta.bssid3}"),
//             leading: Icon(Icons.network_wifi),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _getdata(1, 10);

//     // TODO: implement build
//     return Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(20, 30, 10, 20),
//                 child: Container(
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         flex: 4,
//                         child: Column(
//                           children: <Widget>[
//                             Expanded(
//                               flex: 1,
//                               child: Padding(
//                                   padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
//                                   child: Container(
//                                     child: Column(
//                                       children: <Widget>[
//                                         Expanded(
//                                             flex: 4,
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Center(
//                                                     child: Container(
//                                                       width: 15,
//                                                       height: 15,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.green,
//                                                         border: Border.all(
//                                                             color:
//                                                                 Colors.white70,
//                                                             width: 1),
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                                 Radius.circular(
//                                                                     150.0)),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 6,
//                                                   child: Center(
//                                                     child: Container(
//                                                       child: TextField(
//                                                           style: TextStyle(
//                                                               fontSize: 20),
//                                                           decoration: InputDecoration
//                                                               .collapsed(
//                                                                   border:
//                                                                       InputBorder
//                                                                           .none,
//                                                                   hintText:
//                                                                       "输入起点",
//                                                                   hintStyle:
//                                                                       TextStyle())),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             )),
//                                         Divider(
//                                           height: 1.0,
//                                           indent: 30.0,
//                                           color: Colors.black,
//                                         ),
//                                         Expanded(
//                                             flex: 4,
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Center(
//                                                     child: Container(
//                                                       width: 15,
//                                                       height: 15,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.red,
//                                                         border: Border.all(
//                                                             color:
//                                                                 Colors.white70,
//                                                             width: 1),
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                                 Radius.circular(
//                                                                     150.0)),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 6,
//                                                   child: Center(
//                                                     child: Container(
//                                                       child: TextField(
//                                                           style: TextStyle(
//                                                               fontSize: 20),
//                                                           decoration: InputDecoration
//                                                               .collapsed(
//                                                                   border:
//                                                                       InputBorder
//                                                                           .none,
//                                                                   hintText:
//                                                                       "输入终点",
//                                                                   hintStyle:
//                                                                       TextStyle())),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ))
//                                       ],
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Color(0XFFF0F0F0),
//                                     ),
//                                   )),
//                             )
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Center(
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border:
//                                     Border.all(color: Colors.black, width: 1),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(150.0))),
//                             child: Center(
//                               child: IconButton(
//                                   icon: Icon(Icons.add),
//                                   padding: EdgeInsets.all(4.0),
//                                   iconSize: 30,
//                                   onPressed: () {
//                                     Navigator.pushNamed(
//                                         context, '/createLocationService');
//                                   },
//                                   color: Colors.blueAccent,
//                                   highlightColor: Colors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Color(0XFFF0F0F0),
//                     border: Border.all(color: Colors.white70, width: 2),
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   ),
//                 ),
//               ),
//               height: 130,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//               child: Container(
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       flex: 1,
//                       child: MaterialButton(
//                         key: ValueKey("text"),
//                         child: Text("历史记录"),
//                         onPressed: () {},
//                         textTheme: ButtonTextTheme.normal,
//                         textColor: Colors.blue,
//                         disabledTextColor: Colors.red,
//                         color: Colors.white,
//                         disabledColor: Colors.grey,
//                         highlightColor: Colors.grey,
//                         // 按下的背景色
//                         splashColor: Colors.green,
//                         // 水波纹颜色
//                         colorBrightness: Brightness.light,
//                         // 主题
//                         elevation: 10,
//                         highlightElevation: 10,
//                         disabledElevation: 10,
//                         padding: EdgeInsets.all(10),
// //       MaterialButton shape 子类才起效
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             side: BorderSide(
//                                 color: Color(0xFFFFFFFF),
//                                 style: BorderStyle.solid,
//                                 width: 1)),
//                         clipBehavior: Clip.antiAlias,
//                         materialTapTargetSize: MaterialTapTargetSize.padded,
//                         animationDuration: Duration(seconds: 1),
//                         minWidth: 200,
//                         height: 50,
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: MaterialButton(
//                         key: ValueKey("text"),
//                         child: Text("我的收藏"),
//                         onPressed: () {},
//                         textTheme: ButtonTextTheme.normal,
//                         textColor: Colors.blue,
//                         disabledTextColor: Colors.red,
//                         color: Colors.white,
//                         disabledColor: Colors.grey,
//                         highlightColor: Colors.grey,
//                         // 按下的背景色
//                         splashColor: Colors.green,
//                         // 水波纹颜色
//                         colorBrightness: Brightness.light,
//                         // 主题
//                         elevation: 10,
//                         highlightElevation: 10,
//                         disabledElevation: 10,
//                         padding: EdgeInsets.all(10),
// //       MaterialButton shape 子类才起效
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(5)),
//                             side: BorderSide(
//                                 color: Color(0xFFFFFFFF),
//                                 style: BorderStyle.solid,
//                                 width: 1)),
//                         clipBehavior: Clip.antiAlias,
//                         materialTapTargetSize: MaterialTapTargetSize.padded,
//                         animationDuration: Duration(seconds: 1),
//                         minWidth: 200,
//                         height: 50,
//                       ),
//                     )
//                   ],
//                 ),
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 1,
//             ),
//             Expanded(
//               flex: 1,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
//                 child: Container(
//                   child: ListView(children: this._listView),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.white, width: 1),
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         decoration: BoxDecoration(
//           color: Color(0XFFF0F0F0),
//         ));
//   }
// }
