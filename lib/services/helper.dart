import 'dart:ui';
import 'package:flutter/material.dart';

void toast(
  BuildContext context,
  String mensagem, {
  String type = "sucesso",
}) async {
  final overlay = Overlay.of(context);

  late OverlayEntry overlayEntry;
  final animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
    vsync: Navigator.of(context),
  );

  final animation = Tween<Offset>(
    begin: const Offset(0, 1), // Vem de baixo
    end: const Offset(0, 0),
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ),
  );

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        bottom: 60,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: animation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: type == "sucesso" ? const Color(0xFF702283) : Colors.red,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      mensagem,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      await animationController.reverse();
                      overlayEntry.remove();
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(overlayEntry);
  animationController.forward();
  Duration duracao = Duration(seconds: 3);

  // Remove automaticamente após a duração
  Future.delayed(duracao).then((_) async {
    if (animationController.status == AnimationStatus.completed) {
      await animationController.reverse();
      overlayEntry.remove();
    }
  });
}

void showFullScreenLoader(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false, // não deixa clicar fora
    barrierLabel: 'Carregando',
    barrierColor: Colors.transparent,
    pageBuilder: (context, _, __) {
      return const _FullScreenLoader();
    },
  );
}

class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // bloqueia botão "voltar"
      onPopInvokedWithResult: (didPop, result) => false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fundo embaçado + escurecido
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
            // Spinner no centro
            const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(strokeWidth: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
