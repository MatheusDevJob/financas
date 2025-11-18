import 'package:financas/services/financas_service.dart';
import 'package:financas/services/helper.dart';
import 'package:financas/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://a.storyblok.com/f/178900/1504x846/2a6685e7ed/sword-art-online-episode-13-kirito.jpg/m/1200x0/filters:quality(95)format(webp)",
              ),
            ),
            accountName: Text(PrefService().globalNome ?? ""),
            accountEmail: Text(PrefService().globalEmail ?? ""),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await PrefService().rmToken();
                  if (context.mounted) context.go('/');
                },
              ),
            ],
          ),

          // ExpansionTile(
          //   title: Text("Finanças"),
          //   shape: Border.all(color: Colors.transparent),
          //   initiallyExpanded: true,
          //   childrenPadding: EdgeInsets.only(left: 10),
          //   children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text("Finanças"),
            onTap: () async {
              final router = GoRouter.of(context);
              if (router.state.fullPath == '/financas') {
                Navigator.pop(context);
                return;
              }

              showFullScreenLoader(context);
              final dados = await FinancasService().getHistorico();
              if (context.mounted) {
                Navigator.pop(context);
                context.push('/financas', extra: dados);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.category_outlined),
            onTap: () => context.push('/categoria'),
            title: const Text("Categoria"),
          ),

          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            onTap: () => context.push('/conta'),
            title: const Text("Conta"),
          ),

          ListTile(
            leading: const Icon(Icons.credit_card),
            onTap: () => context.push('/formaPagamento'),
            title: const Text("Formas de Pagamento"),
          ),

          //   ],
          // ),
        ],
      ),
    );
  }
}
