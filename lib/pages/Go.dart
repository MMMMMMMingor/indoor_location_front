import 'package:flutter/material.dart';

class Go extends StatelessWidget {
  const Go({Key key}) : super(key: key);

  List<Widget> _getdata()
  {
    List<Widget> listView=new List();
    for(var i=0;i<5;i++)
    {
      listView.add(
        ListTile(
          title: Text("我的位置——xxxxxx"),

        ),
      );
    }
    return listView;
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(

      body: Padding(
         padding: EdgeInsets.all(0),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                   child: Row(
                     children: <Widget>[
                       Expanded(
                         flex: 4,
                           child: Column(
                             children: <Widget>[
                               Expanded(
                                 flex: 1,
                                 child: Padding(
                                   padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                   child: Container(
                                     child: Column(
                                       children: <Widget>[
                                         Expanded(
                                           flex:4,
                                         child:Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Container(
                                                      width: 15,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        border: Border.all(color: Colors.white70, width: 1),
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(150.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Center(
                                                    child: Container(
                                                      child:TextField(
                                                          style: TextStyle(fontSize: 20),
                                                          decoration: InputDecoration.collapsed(
                                                              border: InputBorder.none,
                                                              hintText: "输入起点",
                                                              hintStyle: TextStyle())),
                                                    ),
                                                  ),
                                                )
                                              ],
                                         )
                                         ),
                                         Divider(height: 1.0,indent: 30.0,color: Colors.black,),
                                         Expanded(
                                           flex: 4,
                                             child:Row(
                                               children: <Widget>[
                                                 Expanded(
                                                   flex: 1,
                                                   child: Center(
                                                     child: Container(
                                                       width: 15,
                                                       height: 15,
                                                       decoration: BoxDecoration(
                                                         color: Colors.red,
                                                         border: Border.all(color: Colors.white70, width: 1),
                                                         borderRadius:
                                                         BorderRadius.all(Radius.circular(150.0)),
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                 Expanded(
                                                   flex: 6,
                                                   child: Center(
                                                     child: Container(
                                                       child:TextField(
                                                           style: TextStyle(fontSize: 20),
                                                           decoration: InputDecoration.collapsed(
                                                               border: InputBorder.none,
                                                               hintText: "输入终点",
                                                               hintStyle: TextStyle())),
                                                     ),
                                                   ),
                                                 )
                                               ],
                                             )
                                         )
                                       ],
                                     ),
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.white70, width: 2),
                                       borderRadius:
                                       BorderRadius.all(Radius.circular(20.0)),
                                   ),
                                 )
                                 ),
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
                               decoration:BoxDecoration(
                                   color: Colors.white70,
                                   border: Border.all(color: Colors.black, width: 1),
                                   borderRadius:
                                   BorderRadius.all(Radius.circular(150.0))),
                             child: Center(
                               child:IconButton(
                                   icon: Icon(Icons.add),
                                   padding: EdgeInsets.all(4.0),
                                   iconSize: 30,
                                   onPressed: () {

                                   },
                                   color: Colors.blueAccent,
                                   highlightColor: Colors.black),
                             ),   ) ,
            ),
                       ),

                     ],
                   ),
                    height:120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                        borderRadius:
                        BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                            child:Container(
                              child: FlatButton(
                                color: Colors.white,
                                child: Text("历史记录"),
                                onPressed: (){},
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            ),
                        ),
                        ),
                        Expanded(
                          flex: 1,
                          child:Container(
                            child: FlatButton(
                              color: Colors.white,
                              child: Text("我的收藏"),
                              onPressed: (){},
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                        )
                      ],
                    ),
                    height:50,
                    decoration: BoxDecoration(


                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Expanded(
                    flex: 1,
                      child:Container(
                        child: ListView(
                          children: this._getdata()
                        ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  ),

          ],

              ),
                 decoration: BoxDecoration(
            )
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
