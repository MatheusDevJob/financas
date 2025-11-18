import 'package:financas/services/financas_service.dart';
import 'package:financas/services/helper.dart';
import 'package:financas/views/adicionar.dart';
import 'package:financas/views/historico.dart';
import 'package:financas/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class Financas extends StatefulWidget {
  const Financas({super.key});

  @override
  State<Financas> createState() => _FinancasState();
}

class _FinancasState extends State<Financas> {
  int paginaAtual = 0;
  int? categoriaId;
  int? contaId;
  int? formPagId;
  double? valor;
  String? tipo;
  String? desc;

  GlobalKey<FormState> formK = GlobalKey<FormState>();

  void mandar() async {
    if (!formK.currentState!.validate()) return;
    formK.currentState?.save();

    Map r = await FinancasService().setRegistro(
      categoriaId,
      contaId,
      formPagId,
      valor,
      tipo,
      desc,
    );

    if (!r['ok'] && mounted) {
      toast(context, r['msg'], type: "erro");
      return;
    }

    formK.currentState!.reset();
    if (mounted) toast(context, r['msg']);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> corpo = [
      Historico(),
      Form(
        key: formK,
        child: Adicionar(
          onSaved: (v) {
            v.forEach((key, value) {
              switch (key) {
                case 'categoria':
                  categoriaId = value as int?;
                  break;
                case 'conta':
                  contaId = value as int?;
                  break;
                case 'formPag':
                  formPagId = value as int?;
                  break;
                case 'tipo':
                  tipo = value as String?;
                  break;
                case 'desc':
                  desc = value as String?;
                  break;
                case 'valor':
                  if (value != null) {
                    valor = double.tryParse(
                      value.toString().replaceAll(',', '.'),
                    );
                  }
                  break;
              }
            });
          },
        ),
      ),
      Historico(eRemover: true),
    ];

    return Scaffold(
      appBar: MyAppBar(title: "Finanças"),
      floatingActionButton:
          paginaAtual == 1
              ? FloatingActionButton(onPressed: mandar, child: Icon(Icons.send))
              : null,
      body: corpo[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (value) => setState(() => paginaAtual = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historico",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Adicionar Registro",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: "Estorno Registro",
          ),
        ],
      ),
    );
  }
}
