import 'package:dio/dio.dart';
import 'package:financas/core/meu_dio.dart';

class FinancasService {
  Dio get _dio => MeuDio.instance;
  Future<List> getHistorico({String? dataI, String? dataF}) async {
    Response r = await _dio.get(
      "/financas/historico",
      queryParameters: {"dataI": dataI, "dataF": dataF},
    );
    if (r.statusCode != 200 || r.data['ok'] == false) return [];

    return r.data["movimentos"];
  }

  Future<Map> getNecessario() async {
    Response r = await _dio.get("/financas/necessario");
    if (r.statusCode != 200 || r.data['ok'] == false) return r.data;

    return {
      "ok": true,
      'categorias': r.data['categorias'],
      'contas': r.data['contas'],
      'formas_pagamento': r.data['formas_pagamento'],
    };
  }

  Future<Map> setRegistro(
    int? categoriaId,
    int? contaId,
    int? formPagId,
    double? valor,
    String? tipo,
    String? desc,
  ) async {
    Response r = await _dio.post(
      "/financas/registrar",
      data: {
        "conta_id": contaId,
        "categoria_id": categoriaId,
        "forma_pagamento_id": formPagId,
        "tipo": tipo,
        "valor": valor,
        "descricao": desc,
      },
    );

    return r.data;
  }

  Future<Map> rmRegistro(int registroId) async {
    Response r = await _dio.post(
      "/financas/deletar",
      data: {"lancId": registroId},
    );

    return r.data;
  }

  Future<String?> getSaldo() async {
    Response r = await _dio.get("/financas/atual");
    if (r.statusCode != 200) return null;
    return r.data;
  }
}
