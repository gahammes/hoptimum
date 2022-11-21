import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../globals.dart' as globals;
import '../models/http_exception.dart';
import '../models/providers/auth.dart';

enum AuthMode { signup, login }

class CadastroCarroScreen extends StatelessWidget {
  static const routeName = '/cadastro-carro-screen';

  const CadastroCarroScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 248, 141, 117),
                      Color.fromARGB(255, 248, 128, 101),
                      Color.fromARGB(255, 246, 106, 75),
                      Color(0xffF75E3B),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 50),
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10.0,
              //     vertical: 10.0,
              //   ),
              //   height: 200,
              //   child: const Image(
              //     image: AssetImage('assets/images/logo-black.png'),
              //   ),
              // ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    bottom: 80.0,
                    top: 0.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // Text(
                      //   'Entrar',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 30.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Authenticate(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  final AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'placa': '',
    'cor': '',
    'modelo': '',
  };
  var _isLoading = false;

  void _showErrorDiaglog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _isLoading = false;
              });
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void tryCadastro() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final url = Uri.parse(globals.getUrl('http', 'api/carro'));
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(
          {
            'cor': _authData['cor'].toString(),
            'placa': _authData['placa'].toString(),
            'modelo': _authData['modelo'].toString(),
          },
        ),
      );
      var res = json.decode(response.body);
      print('😶‍🌫️ $res');
      globals.carrosArray.add(res['_id']);
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  final kLabelStyle = const TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: const Color.fromARGB(255, 255, 129, 101),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final kHintTextStyle = const TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  Widget _buildCorTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cor', style: kLabelStyle),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            //onSubmitted: (_) => _loginDirection(),
            keyboardType: TextInputType.name,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            //decoration: InputDecoration(labelText: 'email'),
            onSaved: (value) {
              _authData['cor'] = value!;
            },

            //controller: emailController,

            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.brush,
                color: Colors.white,
              ),
              hintText: 'Digite a cor do carro',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlacaTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Placa', style: kLabelStyle),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            //onSubmitted: (_) => _loginDirection(),
            //keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            //decoration: InputDecoration(labelText: 'email'),
            onSaved: (value) {
              _authData['placa'] = value!;
            },

            //controller: emailController,

            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.abc,
                color: Colors.white,
              ),
              hintText: 'Digite a placa do carro',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeloTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Modelo', style: kLabelStyle),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            //onSubmitted: (_) => _loginDirection(),
            //keyboardType: TextInputType.,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            //decoration: InputDecoration(labelText: 'email'),
            // validator: (value) {
            //   if (value!.isEmpty || !value.contains('@')) {
            //     return 'Email invalido';
            //   }
            //   return null;
            // },
            onSaved: (value) {
              _authData['modelo'] = value!;
            },

            //controller: emailController,

            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.king_bed,
                color: Colors.white,
              ),
              hintText: 'Digite o modelo do carro',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCadastrarButton(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        //TODO:pegar os dados aqui
        onPressed: tryCadastro,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Text(
                'Cadastrar Carro',
                style: TextStyle(
                  color: Color.fromARGB(255, 246, 106, 75),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          elevation: MaterialStateProperty.all(5.0),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 60.0),
          const Text(
            'CADASTRO DE CARRO',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30.0),
          _buildPlacaTF(),
          const SizedBox(height: 30.0),
          _buildModeloTF(),
          const SizedBox(height: 30.0),
          _buildCorTF(),
          const SizedBox(height: 30.0),
          _buildCadastrarButton(_isLoading),
        ],
      ),
    );
  }
}