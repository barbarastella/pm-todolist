import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String hint;
  final IconData? icone;

  final TextInputType? teclado;
  final String? Function(String?)? validador;

  Editor(this.controlador, this.rotulo, this.hint, {this.icone, this.teclado, this.validador}); // {} indica parâmetros nomeados

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      keyboardType: teclado ?? TextInputType.text,
      validator: (value) {

        if (value == null || value.isEmpty) return 'Campo obrigatório'; // regra geral
        if (validador != null) return validador!(value); // regra customizada
        if (value.length > 100) return 'Digite até 100 caracteres'; // regra default

        return null;
      },
      style: TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        icon: icone != null ? Icon(icone) : null,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        labelText: rotulo,
        hintText: hint),
      );
  }
}