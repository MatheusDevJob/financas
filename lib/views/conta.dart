import 'package:financas/services/helper.dart';
import 'package:financas/services/necessarios_service.dart';
import 'package:financas/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Conta extends StatefulWidget {
  const Conta({super.key});

  @override
  State<Conta> createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  GlobalKey<FormState> formK = GlobalKey<FormState>();
  TextEditingController contaC = TextEditingController();
  TextEditingController descC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Manipulação das Contas"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!formK.currentState!.validate()) return;
          showFullScreenLoader(context);

          Map r = await NecessariosService().setConta(
            contaC.text.trim(),
            descC.text.trim(),
          );
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: contaC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bota o nome, tabacudo";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Conta"),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 400,
                    child: TextFormField(
                      controller: descC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Descreve, mulesta. Caba preguiçoso da porra";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Descrição"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
