import 'package:financas/services/auth_service.dart';
import 'package:financas/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formK = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  bool mostrarSenha = true;

  void entrar() async {
    if (!formK.currentState!.validate()) return;
    final String email = emailC.text;
    final String pass = passC.text;

    Map r = await AuthService().login(email, pass);
    if (!r['ok'] && mounted) toast(context, r["msg"], type: "erro");
    if (mounted) context.pushReplacement('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          Icon(Icons.sentiment_satisfied_outlined),
          SizedBox(width: 15),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 550,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formK,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Title(
                      color: Colors.black,
                      child: Text("Bem Vindo!", style: TextStyle(fontSize: 22)),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailC,
                      decoration: InputDecoration(
                        labelText: "Email",
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Informe o E-mail';

                        if (!v.contains('@') || !v.contains('.')) {
                          return 'E-mail inválido';
                        }

                        if (v.isEmpty) {
                          return "Informe o usuário";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passC,
                      obscureText: mostrarSenha,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            mostrarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(() {
                                mostrarSenha = !mostrarSenha;
                              }),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Informe a senha";
                        } else if (value.length < 8) {
                          return "Senha pequena";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(onPressed: entrar, child: Text("Entrar")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
