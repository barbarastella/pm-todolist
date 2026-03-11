import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String hint;
  final IconData? icone;

  Editor(this.controlador, this.rotulo, this.hint, [this.icone]);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: (value) {
        if (value == null || value.isEmpty) {
          print("\n\n ENTROU NO CAMPO NULL \n\n");
          return 'ERRO: preencha todos os campos!'; }

        if (value.length > 100) {
          print("\n\n ENTROU NO CAMPO > 100 \n\n");
          return 'ERRO: o tamanho da tarefa não pode ultrapassar 100 caracteres!';
        }

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