# 华南理工大学室内定位系统数据采集

包名称：Indoor Data Collection (indoor_data_collection)  
版本：0.3.0 (2020.02.26)  

## 类
* `WiFiCollector` - 采集器
* `WiFiDataManager` - 管理器
* `WiFiMessageSender` - 发送器
* `MessageReceiver` - 接收器

### 数据流
(WiFi Data ->) `Collector` -> `Manager` -> `Sender` (-> MQTT broker)  
(MQTT broker ->) `Receiver`


## WiFiCollector

数据采集器类。**一般情况下，使用此类，结合简单的配置，即可自动完成周期性的数据采集、预处理和发送工作。**（详见样例）  

### 构造函数
#### WiFiCollector({int setSeconds, WiFiDataManager manager, List\<String> knownAPs})
创建一个采集器。  
* setSeconds: 可选，指定采集WiFi数据的周期。默认为5秒钟采集一次。
* manager: 可选，指定一个数据管理器。这样可以把采集到的数据交给`manager`管理。如果不指定，则为空，collector仅采集数据。
* knownAPs: 可选，指定采集器要关注的WiFi AP列表。如果设置，那么采集器将仅采集所给的AP的信号强度（其他不在表中的AP数据会被丢弃，如果表中某个AP没有扫描到，则会以`0`填充）。如果未指定或指定的是空表，将采集所有的WiFi数据。

### 属性
#### setSeconds -> *int*
定时器的数据采集周期。请不要单独修改此属性。
#### manager <-> *WiFiDataManager*
采集器所使用的数据管理器。
#### knownAPs <-> *List\<String>*
指定采集器要关注哪些无线AP并仅采集它们的数据。如果为空表或者`null`，则会采集全部的数据。

### 方法
#### startCollect() async -> *void*
按照设定好的时间周期、`manager`等开始数据采集。会自动申请位置权限，因此需要`async`。
#### stopCollect() -> *void*
停止采集数据。
#### setTimer(int duration) -> *void*
为采集器设置一个新的时间周期。如果采集正在进行，则会按新的周期重启。但如果采集没有在进行，也不会启动采集。
#### collectWiFi() -> *Map\<String, int>*
返回当前采集到的最新一组WiFi数据。其中键类型`String`是BSSID，值类型`int`是对应的RSSI。如果还没有采集到数据，返回一个空`Map`。

  
## WiFiDataManager

数据管理器类。这个类的主要作用是对采集数据进行简单的预处理：如果连续采集到的WiFi信号强度变化不大，那么会视为没有明显的移动，会减少发送消息的频率或者不发送，以减轻服务器负担。  
要发送信息，需要指定一个`WiFiMessageSender`。

### 构造函数
#### WiFiDataManager({WiFiMessageSender sender, bool preprocess = true})
创建一个管理器。  
* sender: 可选，指定manager使用的消息发送器。如果不指定，则不会发送位置指纹消息。
* preprocess: 可选，指定是否需要预处理。如果不需要（`false`），所有接收到的数据都会立即通过`sender`发送。默认为`true`。

### 属性
#### sender <-> *WiFiMessageSender*
管理器所使用的发送器。
#### preprocess <-> *bool*
预处理开关。

### 方法
#### addData(Map\<String, int> newData) -> *void*
将采集到的WiFi数据输入管理器的内部列表并进行处理。如果不是没有明显移动且`sender`不为空，就会通过`sender`尝试发送数据。它可以被`collector`自动调用。

#### getCurrentData() -> *Map\<String, int>*
返回管理器内最新的一组WiFi数据。如果没有数据，返回新的空白`Map`。


## WiFiMessageSender / MessageReceiver
消息发送器及接收器类。其中`Sender`可以MQTT协议发送类型为`Map<String, int>`的位置指纹信息。`Receiver`可接收指定主题的消息。由于两者有公共父类，大部分属性及方法都相同，故将两个类一并介绍。只能用于其中某个类的属性和方法会特别注明。

### 构造函数
#### WiFiMessageSender(String broker, String topic, {int port = 1883, int connectTimes = 10, bool autoConnect = true, String identifier})
创建一个消息发送器。  
* broker: 必需，指定MQTT服务器。例如`39.99.131.85`、`test.mosquitto.org`等。
* topic: 必需，指定发送消息使用的主题。例如“`/fingerprint`”、“`test`”等。
* port: 可选，指定服务器的连接端口，默认为`1883`。
* connectTimes: 可选，指定每次连接尝试的最大次数。默认为`10`。如果经过`connectTimes`次尝试仍没有连上，就返回连接失败。  
* autoConnect: 可选，指定在构造时是否自动尝试连接。默认为`true`。如果设置为`false`，需要后续手动连接。
* identifier: 可选，指定客户端标识符。默认为`"indoor-data-collection-sender"`。如需设置，不能为空。

#### MessageReceiver(String broker, {int port = 1883, int connectTimes = 10, bool autoConnect = true, String identifier, Function(String, String) onData})
创建一个消息接收器。  
* broker: 必需，指定MQTT服务器。例如`39.99.131.85`、`test.mosquitto.org`等。
* port: 可选，指定服务器的连接端口，默认为`1883`。
* connectTimes: 可选，指定每次连接尝试的最大次数。默认为`10`。如果经过`connectTimes`次尝试仍没有连上，就返回连接失败。  
* autoConnect: 可选，指定在构造时是否自动尝试连接。默认为`true`。如果设置为`false`，需要后续手动连接。
* identifier: 可选，指定客户端标识符。默认为`"indoor-data-collection-receiver"`。如需设置，不能为空。
* onData: 可选，每次接收到消息时调用的函数。前一个`String`是消息体，后一个`String`是主题。除此之外，还可以给每个订阅的主题设置一个函数用于处理消息（见下）。


### 属性
#### broker <-> *String*
使用的MQTT服务器。如果更改，当前的连接会被断开，需要稍后手动重连。
#### port <-> *int*
连接的服务器端口。如果更改，当前的连接会被断开，需要稍后手动重连。
#### identifier -> *String*
客户端标识符。
#### connectTimes -> *final int*
调用一次连接函数所尝试的最大次数。一旦构造不可再更改。
#### connected -> *bool*
返回当前连接状态。已连接为`true`。
#### topic <-> *String*
【仅`Sender`】使用的MQTT主题。可以更改，之后的消息发送便会使用新的主题。
#### qos <-> *Qos*
【仅`Sender`】指定消息发送的质量。有以下枚举值可选：

`Qos` | 含义 | 默认  
---- | :--  | ----  
`atMostOnce` | 最多一次 |     
`atLeastOnce` | 最少一次 |   
`exactlyOnce` | 恰好一次 | 是  

对QoS的修改会体现在下一次的消息发送中。
#### topics -> *List\<String>*
【仅`Receiver`】已订阅的主题列表。
#### onData <-> *Function(String message, String topic)*
【仅`Receiver`】每次接收到消息时调用的函数。
#### log <-> *Function(String)*
日志函数，默认为`print`。

### 方法
#### connect() async -> *Future\<int>*
尝试连接。重复次数由`connectTimes`确定。如果经过`connectTimes`次尝试仍没有连上，就返回连接失败。  
如果要手动调用此函数，请根据实际情况考虑是否`await`。  

连接结果 | 返回值  
---- | :--  
成功 | 0  
超时 | 1  
未知错误 | 2  

#### disconnect() -> *void*
解除订阅并断开连接。  

#### sendMessage(Map\<String, int> data) async -> *Future\<bool>*
【仅`Sender`】发送编码为json的位置指纹消息。发送成功则返回`true`，否则返回`false`。如果还未连接，会首先尝试连接（最多重复`connectTimes`次）。它可以被`manager`自动调用。  
发送消息需要一定的时间（不会太长）。因此，如果在调用此函数后立即退出程序，可能无法完成消息的发送。  
编码的样例为：  
```json
{
    "78:44:fd:7f:f0:6d": -63,  
    "54:75:95:37:8f:d4": -56,  
    "b0:ac:d2:be:50:f0": -54  
}
```

#### subscribe(String topic, {Qos qos = Qos.exactlyOnce, Function(String) callOnData}) async -> *Future\<bool>*
【仅`Receiver`】订阅某个主题，可指定消息质量（默认为恰好一次）。如果订阅成功或者主题已订阅返回`true`。**如果设置了`callOnData`，则该主题消息到来时便会自动调用该函数并向其传递消息内容。因此，可以为每个主题定制一个处理函数。**

#### unsubscribe(String topic) -> *void*
【仅`Receiver`】退订某个主题。

#### isSubscribed(String topic) -> *bool*
【仅`Receiver`】查询某个主题是否已经订阅。



## 使用样例
如果使用过程中遇到任何问题，请尽快向开发者提出。
```dart
WiFiCollector collector = new WiFiCollector(seconds: 3);    // 每3秒采集一次
collector.knownAPs = aList;     // aList为提前设定好的AP列表
collector.manager = new WiFiDataManager();      // 管理器
collector.manager.sender = new WiFiMessageSender("39.99.131.85", "/fingerprint");   // 发送器
await Future.delayed(Duration(seconds: 3));    // 等待构造函数完成连接
collector.startCollect();   // 开始自动采集
```