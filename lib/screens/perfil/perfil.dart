import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/editor.dart';
import '../../database/usuarioDao.dart';
import '../../model/usuario.dart';

class Perfil extends StatefulWidget {
  @override
  State<Perfil> createState() {
    return _PerfilState();
  }
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _resultado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preencha seus dados"),
        centerTitle: true,
        backgroundColor: Colors.pink[50],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Editor(
                              _nomeController,
                              "Nome",
                              "Digite seu primeiro nome",
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Editor(
                              _sobrenomeController,
                              "Sobrenome",
                              "Digite seu sobrenome",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "Digite o CEP para preencher o endereço automaticamente",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Editor(
                              _cepController,
                              "CEP",
                              "Digite o CEP (somente números)",
                              teclado: TextInputType.number,
                              validador: (value) {
                                if (value!.length != 8)
                                  return 'ERRO: Digite os 8 números do CEP!';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                setState(() { _buscaCep(); });
                              },
                              icon: Icon(Icons.search),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.orange[50],
                                foregroundColor: Colors.black54,
                                padding: EdgeInsets.all(14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Editor(
                              _logradouroController,
                              "Logradouro",
                              "Digite o logradouro",
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: Editor(
                              _numController,
                              "Número",
                              "Digite o número",
                              teclado: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Editor(_bairroController, "Bairro", "Digite o bairro"),
                      SizedBox(height: 8.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Editor(
                              _cidadeController,
                              "Cidade",
                              "Digite a cidade",
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: Editor(
                              _ufController,
                              "UF",
                              "Digite",
                              validador: (value) {
                                if (value!.length != 2)
                                  return 'ERRO: Digite a sigla do estado (2 letras)!';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                setState(() { _salvarPerfil(); });
                              },
                              icon: Icon(Icons.save_outlined),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.pink[50],
                                foregroundColor: Colors.black54,
                                padding: EdgeInsets.all(14.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        _resultado,
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buscaCep() async {
    final String cep = _cepController.text.trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _resultado = "ERRO: CEP inválido!";
      });

      return;
    }
    ;

    final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['erro'] == 'true') {
        setState(() {
          _resultado = "ERRO: Erro ao buscar CEP!";
        });

        return;
      }

      setState(() {
        _logradouroController.text = jsonResponse['logradouro'] ?? '';
        _numController.text = '';
        _bairroController.text = jsonResponse['bairro'] ?? '';
        _cidadeController.text = jsonResponse['localidade'] ?? '';
        _ufController.text = jsonResponse['uf'] ?? '';
      });
    } else
      _resultado = "ERRO: Não foi possível buscar CEP!";
  }

  Future<void> _salvarPerfil() async {
    if (_formKey.currentState!.validate()) {
      Usuario usuario = Usuario(
        0,
        _nomeController.text.trim(),
        _sobrenomeController.text.trim(),
        _logradouroController.text.trim(),
        _bairroController.text.trim(),
        _cidadeController.text.trim(),
        _ufController.text.trim(),
        _cepController.text.trim()
      );

      UsuarioDao _dao = UsuarioDao();
      await _dao.add(usuario);
      Navigator.pop(context);

      final SnackBar barraSnack = SnackBar(content: Text("Usuário cadastrado com sucesso!"),);
      ScaffoldMessenger.of(context).showSnackBar(barraSnack);

      _formKey.currentState!.reset();
      _nomeController.clear();
      _sobrenomeController.clear();
    } else _resultado = "Erro ao salvar perfil!";
  }
}
