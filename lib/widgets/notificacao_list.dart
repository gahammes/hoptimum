import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../models/notificacao.dart';
import '../globals.dart' as globals;

class NotificacaoList extends StatefulWidget {
  final List<Notificacao> notificacaoLogs;

  const NotificacaoList(this.notificacaoLogs, {Key? key}) : super(key: key);

  @override
  State<NotificacaoList> createState() => _NotificacaoListState();
}

class _NotificacaoListState extends State<NotificacaoList> {
  final listKey = GlobalKey<AnimatedListState>();

  SizeTransition buildCardAni(BuildContext context, String title, String info,
      String date, String tag, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: tag == 'serv'
            ? const Color(0xfff5f5f5)
            : Theme.of(context).colorScheme.secondary,
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: ListTile(
          leading: SizedBox(
            height: 55,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 135, 108),
                      Color.fromARGB(255, 248, 128, 101),
                      Color.fromARGB(255, 246, 106, 75),
                      Color(0xffF75E3B),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FittedBox(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: tag == 'serv'
                        ? const Icon(
                            Icons.king_bed,
                            color: Colors.black,
                            size: 50,
                          )
                        : const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                            size: 50,
                          ),
                  ),
                ),
              ),
            ),
          ),
          title: AutoSizeText(
            title,
            style: TextStyle(
              color: tag == 'serv' ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info,
                style: TextStyle(
                    color: tag == 'serv' ? Colors.black : Colors.white),
              ),
              AutoSizeText(
                DateFormat.MMMMEEEEd('pt_BR').add_Hms().format(
                    DateTime.parse(date).subtract(const Duration(hours: 3))),
                style: TextStyle(
                    color: tag == 'serv' ? Colors.black : Colors.white),
                maxLines: 1,
              ),
            ],
          ),
          trailing: null,
        ),
      ),
    );
  }

  String _getStatusText(String status, String tag) {
    switch (status) {
      case 'espera':
        return tag == 'serv'
            ? 'Solicitação em espera...'
            : 'Pedido em espera...';

      case 'recebido':
        return tag == 'serv' ? 'Solicitação recebida...' : 'Pedido recebido';
      case 'preparando':
        return tag == 'serv'
            ? 'Realizando serviço de quarto...'
            : "Pedido em preparo";
      case 'caminho':
        return 'Pedido à caminho';
      case 'entregue':
        return 'Pedido entregue';
      case 'finalizado':
        return tag == 'serv'
            ? 'Solicitação finalizada...'
            : 'Pedido finalizado';
      default:
        return 'Pedido em espera...';
    }
  }

  AnimatedList animatedList() {
    var listItems = widget.notificacaoLogs;
    return AnimatedList(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      key: globals.listKeyNotif,
      initialItemCount: widget.notificacaoLogs.length,
      itemBuilder: (context, index, animation) {
        return buildCardAni(
          context,
          listItems[index].title,
          _getStatusText(listItems[index].status, listItems[index].tag),
          listItems[index].date.toIso8601String(),
          listItems[index].tag,
          animation,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          setState(() {});
        });
      },
      child: animatedList(),
    );
  }
}
