import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Paleta extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaletaState();
  }
}

class _PaletaState extends State<Paleta> {
  final TextEditingController _paletaController = TextEditingController();

  List<dynamic> _paletas = [];
  bool _carregando = false;
  String _mensagem = "";

  Color _hexToColor(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerador de paletas de cores"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                "Busque por cores, moods, características em inglês. Exemplos: green, soft, fun, happy.",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _paletaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Digite aqui (somente uma palavra)",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: _buscaPaleta,
                      icon: Icon(Icons.search),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              if (_carregando) CircularProgressIndicator(),
              if (_mensagem.isNotEmpty && !_carregando)
                Text(_mensagem,
                  style: TextStyle(fontSize: 16.0, color: Colors.red),
                ),
              if (!_carregando && _paletas.isNotEmpty)
                Column(
                  children: _paletas.map((paleta) {
                    final String titulo = paleta['text'] ?? "Sem título";
                    final List<dynamic> coresHex = paleta['colors'] ?? [];
                    return Container (
                      padding: const EdgeInsets.all(12.0),
                        margin: EdgeInsets.only(bottom: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo.trim(),
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Row(
                              children: coresHex.map((hex) {
                                return Expanded(
                                  child: Container(
                                    height: 50.0,
                                    color: _hexToColor(hex.toString()),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buscaPaleta() async {
    FocusScope.of(context).unfocus();

    final String busca = _paletaController.text.trim();
    final response = await http.get(Uri.parse('https://colormagic.app/api/palette/search?q=$busca'));

    if (busca.isEmpty) return;

    setState(() {
      _carregando = true;
      _mensagem = "";
      _paletas = [];
    });

    try {
      final response = await http.get(Uri.parse('https://colormagic.app/api/palette/search?q=$busca'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        print("\n\n\njsonresponse___$jsonResponse");

        setState(() {
          if (jsonResponse.isEmpty) _mensagem = "ERRO: Nenhuma paleta encontrada para este termo!";
          else _paletas = jsonResponse.take(4).toList();

          _carregando = false;
        });
      } else {
        setState(() {
          _mensagem = "ERRO: Não foi possível buscar as paletas!";
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensagem = "Erro de conexão. Verifique sua internet.";
        _carregando = false;
      });
    }
  }
}
