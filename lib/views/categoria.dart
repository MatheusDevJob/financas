import 'package:financas/services/helper.dart';
import 'package:financas/services/necessarios_service.dart';
import 'package:financas/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Categoria extends StatefulWidget {
  const Categoria({super.key});

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  GlobalKey<FormState> formK = GlobalKey<FormState>();
  TextEditingController categC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Manipulação das Categorias"),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!formK.currentState!.validate()) return;
          showFullScreenLoader(context);
          Map r = await NecessariosService().setCategoria(categC.text.trim());
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
                  controller: categC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bota o nome, tabacudo";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Categoria"),
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
