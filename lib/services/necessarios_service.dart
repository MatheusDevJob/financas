import 'package:dio/dio.dart';
import 'package:financas/core/meu_dio.dart';

class NecessariosService {
  Dio get _dio => MeuDio.instance;

  Future<Map> setCategoria(String categoria) async {
    Response r = await _dio.post(
      '/financas/categoria',
      data: {'categoria': categoria},
    );

    return r.data;
  }

  Future<Map> setConta(String conta, String desc) async {
    Response r = await _dio.post(
      '/financas/conta',
      data: {'conta': conta, 'descricao': desc},
    );

    return r.data;
  }

  Future<Map> setFormPag(String formPag) async {
    Response r = await _dio.post(
      '/financas/forma_pagamento',
      data: {'forma_pagamento': formPag},
    );

    return r.data;
  }
}
