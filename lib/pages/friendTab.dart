import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/friendPage.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;

class FriendTab extends StatefulWidget {
  @override
  _FriendTabState createState() => _FriendTabState();
}

class _FriendTabState extends State<FriendTab> {
  FriendPage _friendList;

//拿到好友数组数组
  void _getdata(int pageNum, int pageSize) async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(
        Config.url + "api/friend/query/$pageNum/$pageSize",
        headers: {"Authorization": "Bearer $token"});

    print(response.body);

    FriendPage friendPage =
        FriendPage.fromJson(utf8JsonDecode(response.bodyBytes));

    this.setState(() {
      this._friendList = friendPage;
    });
    return;
  }

//制作每个List item 的样式
  Widget getItem(int position, List<Friend> list) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(1, 0, 6, 5),
      child: Container(
          height: 80,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              //头像栏
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(

                      // decoration: BoxDecoration(color: Colors.green),
                      child: Image.asset(
                    'images/head_portraits.jpg',
                    fit: BoxFit.fill,
                  )),
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      //朋友姓名栏
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Container(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5, 0, 0, 0), //修改名字的左边间隔
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            // list[position].name,
                                            list[position].createTime,
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ],
                                      ))))),
                      Divider(
                        height: 1.0,
                        indent: 0,
                        color: Colors.black,
                      ),
                      //朋友位置状态栏
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Container(
                                  //  decoration: BoxDecoration(color: Colors.purple),
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          5, 0, 0, 0), //修改名字的左边间隔
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            "状态是: ",
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          //获取当前朋友的位置信息
                                          new Text(
                                            // list[position].job,
                                            list[position].friendId,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ))))),
                    ],
                  )),
                ),
              )
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    _getdata(1, 10);
  }

  @override
  Widget build(BuildContext context) {
    //返回一个好友的listview,通过Listview.builder
    var FriendListView = new ListView.builder(
        itemCount:
            (this._friendList == null) ? 0 : this._friendList.records.length,
        itemBuilder: (BuildContext context, int position) {
          // return ListTile (title:Text(friendList[position].name),);
          return getItem(position, this._friendList.records);
        });

    return Scaffold(
        appBar: AppBar(
          title: Text("好友列表"),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: FriendListView,
        )
        // body:Padding(
        //   padding:EdgeInsets.all(0),
        //   child:Container(
        //     child:Padding(
        //       padding: EdgeInsets.all(10.0),
        //      child: Container(
        //   child:Row(
        //     children: <Widget>[
        //       FriendListView,
        //     ],
        //     )

        //          ),
        //       ),

        //   ),
        // ),
        );
  }
}
