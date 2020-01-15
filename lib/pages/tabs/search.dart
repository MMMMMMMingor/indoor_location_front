

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    
    //构建按钮组件的函数
    Padding buildButtonColumn(IconData icon, String label) {
      Color color = Colors.blueGrey;
   
      return new Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
       child:Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // new Icon(icon, color: color,size: 30.0,),
          new IconButton(icon: Icon(icon),
          iconSize: 30,
          onPressed: (){
            print(label);
          }, 
           color : Colors.blueGrey),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
        )
      );
    }//构建上面icon下面有文字的按钮组件的函数

    //呈现整个页面的Scaffold
    return Scaffold(
     
    resizeToAvoidBottomPadding: false,
         body: Container(//整个界面的

         child:Column(
           children: <Widget>[

       Expanded(
         flex: 7,
      child: Container(//有背景图片的第一部分导航栏
      // height: 160,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/searchBack.jpg"),
            fit: BoxFit.cover,
          ),
        ),
         child:Container(
     
           child: Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child:Container( 
                  child:Column(
                           children: <Widget>[
                             Expanded(flex: 7,
                            
                             child:Container(//发现附近这一栏
                                 child: Row(
                                   children: <Widget>[
                                      Expanded(

                                      flex: 3,
                                        child: FlatButton(
                                         child: Text("发现附近" ,
                                         style: TextStyle(
                                           fontSize: 25,
                                           color: Colors.white,
                                    
                                         
                                           ),
                                        
                                           textAlign: TextAlign.center,
                                           
                                         ),
                                             onPressed: () {},
                                      )
                                    
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("")
                      ),
                      Expanded(
                        flex: 2,
                         child:Text("   26℃",
                         style: TextStyle(
                                   fontSize: 25,
                                   color: Colors.white,
                         ),
                         )
                      ),

                        ],
                           ),
                             ),
                             ),
                        Expanded(flex:5 ,
                        
                  child: Container(//搜索栏这一栏
                          child:Padding(
                            padding: EdgeInsets.fromLTRB(10,0,10,0),
                            
                       child: Column(

          children: <Widget>[
            Container(
              child: Row(
           
                children: <Widget>[
                Expanded(
                            flex: 5,
                            child: TextField(
                                style: TextStyle(fontSize: 25),
                                decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintText: "搜索地址",
                                    hintStyle: TextStyle())),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.search),
                                padding:EdgeInsets.all(8.0),
                              iconSize: 30,
                              
                              onPressed: (){

                                print("aa");
                              },
                                color: Colors.blueAccent,
                                highlightColor: Colors.black
                            ),
                          )
              ],
              ),
              //搜索框的样式
               decoration: BoxDecoration(
                
                          color: Colors.white70,
                          border: Border.all(color: Colors.white70, width: 2),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))
                              ),
                    
        
              )
          ],
        ),
       )
      ),
                        ),
                           ]
    ),
     ),
     
     
    )
    )
    )
    ),
       ),
    // ********************第一部分********
    Expanded(
      flex: 9,
child:Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
         child:Container(
     
          // height:210,
          decoration:BoxDecoration(
        // color: Colors.red,
                  color: Colors.white70,
                  border: Border.all(color: Colors.white70, width: 2),
                   borderRadius:
                  BorderRadius.all(Radius.circular(10.0))
      ),
     
      child:Container(
      child:Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           Wrap(

  spacing:20.0, // 主轴(水平)方向间距
  runSpacing:10.0, // 纵轴（垂直）方向间距
  alignment: WrapAlignment.center,

  children: <Widget>[

     buildButtonColumn(Icons.fastfood, '美食'),
     buildButtonColumn(Icons.directions_car, '停车位'),
     buildButtonColumn(Icons.shopping_cart, '超市'),
     buildButtonColumn(Icons.gamepad, '电玩'),
     buildButtonColumn(Icons.movie, '电影'),
     buildButtonColumn(Icons.music_video, 'KTV'),
     buildButtonColumn(Icons.home, '亲子'),
     buildButtonColumn(Icons.more_horiz, '更多'),

   
  ],
),
        ]
      )
      )
      
    ), //第二部分的container
 ),
    ),
    // ***************第二部分****************
    Expanded(
      flex: 10,
   child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
           child:Container(//第三部分的container，主要是轮播图
          // height: 220,
        decoration:BoxDecoration(

      ),

      child: Container(
        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).viewInsets.bottom,
          child: Swiper(
            itemBuilder: _swiperBuilder,
            itemCount: 3,
            pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
              color: Colors.black54,
              activeColor: Colors.white,
            )),
            control: new SwiperControl(),
            scrollDirection: Axis.horizontal,
            autoplay: true,
            onTap: (index) => print('点击了第$index个'),
      ),
    )
         ),
    )
    ),
           ]
     
      )//整个页面的列
         )//整个页面容器的container
    );
  }


//建立轮播图的函数
  Widget _swiperBuilder(BuildContext context, int index) {
    switch (index) {
      case 0 :
         return (Image.asset(
      'images/searchBack.jpg',
      fit: BoxFit.fill,
    ));
        break;
        case 1:
               return (Image.asset(
      'images/head_portraits.jpg',
      fit: BoxFit.fill,
    ));
    break;
  case 2:
   return (Image.asset(
      'images/head_portraits.jpg',
      fit: BoxFit.fill,
    ));
    break;
      default:
    }
   
  }

}
