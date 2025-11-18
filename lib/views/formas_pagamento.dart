import 'package:financas/services/helper.dart';
import 'package:financas/services/necessarios_service.dart';
import 'package:financas/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormasPagamento extends StatefulWidget {
  const FormasPagamento({super.key});

  @override
  State<FormasPagamento> createState() => _FormasPagamentoState();
}

class _FormasPagamentoState extends State<FormasPagamento> {
  GlobalKey<FormState> formK = GlobalKey<FormState>();
  TextEditingController formPagC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Manipulação das Formas de Pagamento"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!formK.currentState!.validate()) return;
          showFullScreenLoader(context);
          Map r = await NecessariosService().setFormPag(formPagC.text.trim());
          if (context.mounted) context.pop();

          if (!r['ok'] && context.mounted) {
            toast(context, r['error'], type: 'erro');
            return;
          }

          if (context.mounted) toast(context, r['msg']);
          formK.currentState!.reset();
        },
        child: Icon(Icons.send_rounded),
      ),
      body: Center(
        child: Card(
          child: Form(
            key: formK,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 400,
                child: TextFormField(
                  controller: formPagC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Eita meu deus... mas é burro, viu?";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Forma de Pagamento"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
