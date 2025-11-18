import 'package:financas/services/financas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class Adicionar extends StatefulWidget {
  final Function(Map) onSaved;

  const Adicionar({super.key, required this.onSaved});

  @override
  State<Adicionar> createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  int? categoriaId;
  int? contaId;
  int? formPagId;
  String tipo = 'entrada';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(120),
        child: Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(80, 20, 80, 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Title(
                  color: Colors.black,
                  child: Text(
                    "Detalhes do registro",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Divider(),
                FutureBuilder(
                  future: FinancasService().getNecessario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data?['ok'] != true) {
                      return const Center(child: Text('Nenhum dado'));
                    }

                    final dados = snapshot.data!;
                    final categorias =
                        (dados['categorias'] as List)
                            .map((e) => (e as Map).cast<String, dynamic>())
                            .toList();
                    final contas =
                        (dados['contas'] as List)
                            .map((e) => (e as Map).cast<String, dynamic>())
                            .toList();
                    final formasP =
                        (dados['formas_pagamento'] as List)
                            .map((e) => (e as Map).cast<String, dynamic>())
                            .toList();

                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int>(
                            onSaved: (newValue) {
                              widget.onSaved({'categoria': newValue});
                            },
                            value: categoriaId,
                            decoration: InputDecoration(
                              labelText: "Categoria",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items:
                                categorias.map((e) {
                                  return DropdownMenuItem(
                                    value: e['id'] as int,
                                    child: Text(
                                      e['nome'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                            onChanged: (a) {
                              if (a == null) return;
                              categoriaId = a;
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Qual a categoria?";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int>(
                            onSaved: (newValue) {
                              widget.onSaved({'conta': newValue});
                            },
                            value: contaId,
                            decoration: InputDecoration(
                              labelText: "Qual Conta?",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items:
                                contas
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e['id'] as int,
                                        child: Text(
                                          e['nome'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            validator: (value) {
                              if (value == null) return "De onde?";
                              return null;
                            },
                            onChanged: (e) {
                              if (e == null) return;
                              contaId = e;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<int>(
                            onSaved: (newValue) {
                              widget.onSaved({'formPag': newValue});
                            },
                            value: formPagId,
                            decoration: InputDecoration(
                              labelText: "Transação",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items:
                                formasP
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e['id'] as int,
                                        child: Text(
                                          e['nome'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            validator: (value) {
                              if (value == null) return "De que forma?";
                              return null;
                            },
                            onChanged: (e) {
                              if (e == null) return;
                              formPagId = e;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<String>(
                            onSaved: (newValue) {
                              widget.onSaved({'tipo': newValue});
                            },
                            value: tipo,
                            decoration: InputDecoration(
                              labelText: "Tipo",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'entrada',
                                child: Text(
                                  'Entrada',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'saida',
                                child: Text(
                                  'Saída',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                            onChanged: (a) {
                              if (a == null) return;
                              tipo = a;
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  autofocus: true,
                  onSaved: (newValue) {
                    widget.onSaved({'desc': newValue});
                  },
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Descreva";
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  onSaved: (newValue) {
                    widget.onSaved({'valor': newValue});
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    CurrencyInputFormatter(
                      thousandSeparator: ThousandSeparator.None,
                      mantissaLength: 2, // casas decimais
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Quanto?";
                    double v = double.parse(value);
                    if (v < .01) return "Um valor válido, animal";
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Valor",
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
