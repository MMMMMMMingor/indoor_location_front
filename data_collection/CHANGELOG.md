## [0.3.0] - 2020.2.26

* 增加消息接收器，将原来`Sender`中的消息接收功能独立出来
* 增加了简单的日志功能
* 升级`mqtt_client`版本至`6.0.0`

## [0.2.2] - 2020.2.25

* 修正`Manager`中的错误

## [0.2.1] - 2020.2.23

* 微调部分函数的返回值
* 更改版本号的表示方法

## [0.2.0] - 2020.2.22

* 修复了消息发送异常的漏洞
* 将`WiFiMessageSender`构造函数中的`theme`改为`topic`
* 增加预处理开关

## [0.1.1] - 2020.2.21

* 优化Sender
* 【已解决/0.2.0】**已知问题：NoConnectionException (The maximum allowed connection attempts ({3}) were exceeded; Missing connection acknowledgement)**
