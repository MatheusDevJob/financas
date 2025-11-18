import 'package:financas/services/financas_service.dart';
import 'package:financas/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Historico extends StatefulWidget {
  final bool eRemover;
  const Historico({super.key, this.eRemover = false});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  void solicitarApagar(id) async {
    final r = await showAdaptiveDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          title: Text("Kofoi maluco, vai me apagar mesmo?"),
          actions: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () => context.pop(false),
              child: Text("NÃO! ME DESCULPA"),
            ),
            FilledButton(
              onPressed: () => context.pop(true),
              child: Text("FODASSE?!?!"),
            ),
          ],
        );
      },
    );

    if (!r) return;

    Map rf = await FinancasService().rmRegistro(id);
    if (mounted) {
      if (!rf["ok"]) {
        toast(context, rf['msg'], type: "erro");
        return;
      }

      toast(context, rf['msg']);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FinancasService().getHistorico(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Nenhum dado'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final m = snapshot.data![index];

            final tipo = (m['tipo'] ?? '').toString(); // entrada / saida
            final isEntrada = tipo == 'entrada';

            final cor = isEntrada ? Colors.green : Colors.red;
            final sinal = isEntrada ? '+' : '-';

            final descricao = (m['descricao'] ?? '').toString();
            final data = (m['data'] ?? '').toString();
            final valor = (m['valor'] ?? '').toString();
            final saldoApos = (m['saldoApos'] ?? '').toString();

            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: cor.withOpacity(0.1),
                  child: Icon(
                    isEntrada ? Icons.arrow_downward : Icons.arrow_upward,
                    color: cor,
                    size: 20,
                  ),
                ),
                title: Text(
                  descricao,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.isNotEmpty)
                      Text(
                        data, // já manda formatado do jeito que você quiser
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (saldoApos.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Saldo após: R\$ $saldoApos',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '$sinal R\$ $valor',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cor,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.eRemover)
                      IconButton.filledTonal(
                        onPressed: () => solicitarApagar(m['id']),
                        icon: Icon(Icons.delete),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
