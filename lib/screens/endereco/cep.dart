import 'package:flutter/material.dart';

class Cep extends StatefulWidget {
  @override
  State<Cep> createState() {
    return _CepState();
  }
}

class _CepState extends State<Cep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CEP")),
      body: Text("Código de Endereçamento Postal"),
    );
  }
}
