import 'dart:convert';
import 'dart:typed_data';


//适用于 utf-8 的json解码工具
Map<String, dynamic> utf8JsonDecode(Uint8List bytes){
  return jsonDecode(Utf8Decoder().convert(bytes));
}