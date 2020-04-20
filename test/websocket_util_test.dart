import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // test("websocket manager test", () async {
  //   Timer timer;
  //   const Logger log = Logger("websocket_test");
  //   const String metadataId = "2c1228f377914272be3ab76ef6c4b8cf";
  //   const String token =
  //       "eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIxMDJmMGM2MmM0YjhkNTE4YzhiYzk5NGNhMzE2OWIyZCIsInN1YiI6Im1pbmdvciIsImV4cCI6MTU4NjkzODI1MSwiaWF0IjoxNTg2ODUxODUxfQ.8FzKo4jxPEn182P2yHvnc2z4H0US9n8rBhQQaX0l_xA";

  //   WebSocketManager webSocketManager = new WebSocketManager();

  //   webSocketManager.connectWithServer(token, metadataId);

  //   timer = Timer.periodic(Duration(seconds: 3), (timer) async {
  //     int i1 = -Random().nextInt(100);
  //     int i2 = -Random().nextInt(100);
  //     int i3 = -Random().nextInt(100);
  //     var locationRequest = new LocationRequest(intensities: <int>[i1, i2, i3]);
  //     log.debug(locationRequest.toJson().toString());
  //     webSocketManager.sendMessage(locationRequest.toJson());

  //     if(timer.tick > 10){
  //       webSocketManager.disconnectWithServer();
  //       timer.cancel();
  //     }

  //   });
  //   sleep(Duration(seconds: 30));
  // });

}
