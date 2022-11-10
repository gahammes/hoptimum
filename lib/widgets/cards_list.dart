// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dashboard_tcc/screens/info_hospede_screen.dart';
import 'package:dashboard_tcc/screens/info_sceen.dart';
import 'package:flutter/material.dart';

// List<Info> lista = [
//   Info('Nome', 'Titular', '3 dependentes', '1 carro e 4 tags'),
//   Info('Nome', 'Dependente', 'Adulto', ''),
//   Info('Nome', 'Dependente', 'Adulto', ''),
//   Info('Nome', 'Dependente', 'Criança', ''),
// ];

class CardsList extends StatelessWidget {
  final String nome;
  final String tipo;
  final String info;
  final String carro;

  CardsList(this.nome, this.tipo, this.info, this.carro);

  void _selectInfoHosp(BuildContext context) {
    Navigator.of(context).pushNamed(InfoHospedeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: EdgeInsets.fromLTRB(70, 16, 10, 0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
          ),
          FittedBox(
            child: Text(
              nome,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            height: 2,
          ),
          Text(
            tipo,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 14.0),
            height: 1.0,
            width: 25.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Text(
            info,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),
          Container(
            height: 6,
          ),
          Text(
            carro,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 24,
        right: 20,
        left: 5,
      ),
      child: Stack(
        children: [
          Container(
            child: InkWell(
              onTap: () => _selectInfoHosp(context),
              child: content,
            ),
            height: 155.0,
            margin: EdgeInsets.only(
              top: 20.0,
              left: 50,
            ),
            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.primary,
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color.fromARGB(255, 255, 135, 108),
                  Color.fromARGB(255, 248, 128, 101),
                  Color.fromARGB(255, 246, 106, 75),
                  Color(0xffF75E3B),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: FractionalOffset.centerLeft,
            child: Image(
              image: AssetImage('assets/images/profile.png'),
              height: 120,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }
}
