import 'package:dio/dio.dart';
import 'package:financas/core/meu_dio.dart';
import 'package:financas/services/pref_service.dart';

class AuthService {
  Dio get _dio => MeuDio.instance;
  Future<Map> login(String email, String senha) async {
    try {
      Response r = await _dio.post(
        "/auth/login",
        data: {'email': email, 'senha': senha},
      );

      if (r.statusCode != 200 || r.data['ok'] == false) {
        return {'ok': false, 'msg': r.data['msg'] ?? "Erro interno"};
      }
      await PrefService().setToken(r.data['token']);
      await PrefService().setEmail(r.data['user']['email']);
      await PrefService().setNome(r.data['user']['nome']);
      return r.data;
    } catch (e) {
      return {"ok": false, "msg": e.toString()};
    }
  }
}
