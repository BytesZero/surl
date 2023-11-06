import 'package:dio/dio.dart';

final dio = Dio();

/// 初始化 http
void initHttp() {
  // dio.options.baseUrl = "http://116.62.237.65:8080/";
  dio.options.baseUrl = "http://192.168.1.6:8080/";
  dio.options.contentType = Headers.textPlainContentType;
  dio.interceptors.add(LogInterceptor()); // Log 日志
}

/// 生成短链
Future<String> genSurl(String url) async {
  try {
    final response = await dio.post("/s", data: url);
    return response.data;
  } catch (e) {
    print("❌ 生成失败");
    return "";
  }
}
