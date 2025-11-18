import 'package:dio/dio.dart';
import 'package:financas/services/pref_service.dart';

class MeuDio {
  static final Dio instance = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:1212/api',
        validateStatus: (status) {
          // aqui vale pra TODAS as requisições
          return status != null && status < 500;
        },
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefService().getToken();

          if (token != "" && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
}
