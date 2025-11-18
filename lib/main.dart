import 'dart:io';

import 'package:financas/services/pref_service.dart';
import 'package:financas/views/auth/login.dart';
import 'package:financas/views/categoria.dart';
import 'package:financas/views/conta.dart';
import 'package:financas/views/financas.dart';
import 'package:financas/views/formas_pagamento.dart';
import 'package:financas/views/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(800, 600),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  await PrefService().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<String?> validarRedirect(context, state) async {
    final token = await PrefService().getToken();
    if (token == '' || token.isEmpty) return '/';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 214, 214, 214),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) async {
              final token = await PrefService().getToken();
              if (token == '' || token.isEmpty) return null;
              return '/home';
            },
            builder: (_, __) {
              return const Login();
            },
          ),
          GoRoute(path: '/home', builder: (_, __) => const Home()),
          GoRoute(
            path: '/financas',
            redirect: validarRedirect,
            builder: (_, __) => Financas(),
          ),
          GoRoute(
            path: '/categoria',
            redirect: validarRedirect,
            builder: (_, __) => Categoria(),
          ),
          GoRoute(
            path: '/conta',
            redirect: validarRedirect,
            builder: (_, __) => Conta(),
          ),
          GoRoute(
            path: '/formaPagamento',
            redirect: validarRedirect,
            builder: (_, __) => FormasPagamento(),
          ),
        ],
      ),
    );
  }
}
