import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.pexels.com/v1/",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "Authorization": "yzqnHbzYP2tCetw0OZIvrA0RkDUln8pGe2pHP4W5v9sHoRI9Y8k3TeNi"
      },
    ),
  );

  Dio get client => dio;
}
