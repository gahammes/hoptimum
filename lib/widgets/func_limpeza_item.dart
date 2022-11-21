import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../models/servico.dart';
import '../globals.dart' as globals;

class FuncLimpezaItem extends StatefulWidget {
  final List<Servico> solicitacoes;
  final List<Servico> soliFinalizados;
  const FuncLimpezaItem(this.solicitacoes, this.soliFinalizados, {Key? key})
      : super(key: key);
  @override
  State<FuncLimpezaItem> createState() => _FuncLimpezaItemState();
}

class _FuncLimpezaItemState extends State<FuncLimpezaItem> {
  //post com _id de servicos[i] status(string) /api/statusservico
  void _updateStatus(int index) async {
    var status = '';
    setState(() {
      switch (widget.solicitacoes[index].status) {
        case Status.espera:
          widget.solicitacoes[index].status = Status.recebido;
          status = 'recebido';
          break;
        case Status.recebido:
          widget.solicitacoes[index].status = Status.preparando;
          status = 'preparando';
          break;
        case Status.preparando:
          widget.solicitacoes[index].status = Status.finalizado;
          status = 'finalizado';
          widget.soliFinalizados.insert(0, widget.solicitacoes[index]);
          widget.solicitacoes.removeAt(index);
          break;
        case Status.finalizado:
          break;
        default:
          break;
      }
    });
    try {
      final url = Uri.parse(globals.getUrl('http', 'api/statusservico'));
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
          {
            'id': globals.loginData['funcionario']['servicos'][index]['_id'],
            'status': status,
          },
        ),
      );
      print(json.decode(response.body));
    } catch (error) {
      print(error);
    }
  }

  Widget _buildExpansionTile(int index, Color color) {
    var rng = Random();
    return ExpansionTile(
      //maintainState: true,
      collapsedBackgroundColor: const Color(0xfff5f5f5),
      backgroundColor: const Color(0xfff5f5f5),
      //collapsedBackgroundColor: Colors.white,
      title: const Text(
        'Detalhes',
        style: TextStyle(fontSize: 16),
      ),
      textColor: Theme.of(context).colorScheme.primary,
      childrenPadding:
          const EdgeInsets.only(left: 16.0, bottom: 10.0, right: 10.0),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, fontFamily: 'Quicksand', color: Colors.black),
            children: [
              const TextSpan(
                text: 'Número do pedido: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              //'${(widget.pedidos[index].id.toString().length - (rng.nextInt(5))) * (rng.nextInt(100) + 1)}.'
              TextSpan(
                  text:
                      '${(widget.solicitacoes[index].id.toString().length - (rng.nextInt(5))) * (rng.nextInt(100) + 1)}.'),
            ],
          ),
        ),
        const SizedBox(height: 7.0),
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, fontFamily: 'Quicksand', color: Colors.black),
            children: [
              const TextSpan(
                text: 'Data: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                  text:
                      '${DateFormat.MMMMd('pt_BR').format(widget.solicitacoes[index].data)}.'),
            ],
          ),
        ),
        const SizedBox(height: 7.0),
        RichText(
          text: TextSpan(
            style: const TextStyle(
                fontSize: 16, fontFamily: 'Quicksand', color: Colors.black),
            children: [
              const TextSpan(
                text: 'Hora: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                  text:
                      '${DateFormat.Hm('pt_BR').format(widget.solicitacoes[index].data)}.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getText(int index, Color color) {
    switch (widget.solicitacoes[index].status) {
      case Status.espera:
        return const Text('Solicitação em espera...',
            style: TextStyle(color: Colors.red));
      case Status.recebido:
        return const Text('Solicitação recebida',
            style: TextStyle(color: Colors.yellow));
      case Status.preparando:
        return const Text("Realizando serviço de quarto",
            style: TextStyle(color: Colors.yellow));
      case Status.finalizado:
        return Text('Solicitação finalizada', style: TextStyle(color: color));
      default:
        return Text('Solicitação em espera...', style: TextStyle(color: color));
    }
  }

  Widget _buildCard(int index) {
    var bgColor = Theme.of(context).colorScheme.secondary;
    var fontColor = Colors.white;

    return Container(
      margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: bgColor,
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            ListTile(
              leading: SizedBox(
                //width: 85,
                height: 60,
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: FittedBox(
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      child: const Icon(
                        Icons.airline_seat_individual_suite_rounded,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                'Quarto ${widget.solicitacoes[index].numQuarto.toString()}',
                style: TextStyle(
                  color: fontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: _getText(
                index,
                fontColor,
              ),
              trailing: widget.solicitacoes[index].status != Status.finalizado
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      color: Colors.white,
                      onPressed: () => _updateStatus(index),
                    )
                  : null,
            ),
            _buildExpansionTile(
              index,
              fontColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          setState(() {});
        });
      },
      child: ListView.builder(
          itemCount: widget.solicitacoes.length,
          itemBuilder: (context, index) {
            return _buildCard(index);
          }),
    );
  }
}
