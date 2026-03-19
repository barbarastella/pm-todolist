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
  int? _idAtualizaUsuario = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
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
                      Text("Digite o CEP para preencher o endereço automaticamente",
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
                                if (value!.length != 8) return 'Apenas 8 dígitos';
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
                                setState(() {
                                  _buscaCep();
                                });
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
                                if (value!.length != 2) return 'Digite 2 letras';
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
                                await _salvarPerfil();
                              },
                              icon: Icon(Icons.save_outlined),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.pink[50],
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
                      if (_resultado.isNotEmpty)
                        Text(_resultado,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _listarUsuarios(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listarUsuarios() {
    return Column(
      children: [
        Divider(thickness: 4, height: 20, color: Colors.white),
        SizedBox(height: 16.0),
        Text("Usuários cadastrados", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        SizedBox(height: 16.0),

        FutureBuilder<List<Usuario>>(
          future: UsuarioDao().findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Text("Erro ao carregar dados!");
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Nenhum usuário cadastrado"),
              );
            }

            final List<Usuario> usuarios = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.only(bottom: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple[100],
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      "${usuario.nome} ${usuario.sobrenome}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${usuario.logradouro}, ${usuario.numero} - ${usuario.bairro}. ${usuario.cep}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.black54,
                          ),
                          onPressed: () async {
                            setState(() { _confirmarExclusao(context, usuario); });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.black54,
                          ),
                          onPressed: () async {
                            _atualizarUsuario(context, usuario);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _deletarUsuario(BuildContext context, Usuario usuario) async {
    await UsuarioDao().delete(usuario.id);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário removido", style: TextStyle(color: Colors.black54)), backgroundColor: Colors.red[200])
    );

    setState(() {});
  }

  void _confirmarExclusao(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Atenção!"),
          content: Text("Tem certeza que deseja excluir o usuário ${usuario.nome} ${usuario.sobrenome}?"),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(dialogContext).pop();},
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deletarUsuario(context, usuario);
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _atualizarUsuario(BuildContext context, Usuario usuario) {
    _idAtualizaUsuario = usuario.id;

    _nomeController.text = usuario.nome;
    _sobrenomeController.text = usuario.sobrenome;
    _logradouroController.text = usuario.logradouro;
    _numController.text = usuario.numero;
    _bairroController.text = usuario.bairro;
    _cidadeController.text = usuario.cidade;
    _ufController.text = usuario.uf;
    _cepController.text = usuario.cep;
  }

  Future<void> _buscaCep() async {
    final String cep = _cepController.text.trim();
    _resultado = '';

    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() {
        _resultado = "ERRO: CEP inválido!";
      });

      return;
    }

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
        _idAtualizaUsuario ?? 0,
        _nomeController.text.trim(),
        _sobrenomeController.text.trim(),
        _logradouroController.text.trim(),
        _numController.text.trim(),
        _bairroController.text.trim(),
        _cidadeController.text.trim(),
        _ufController.text.trim(),
        _cepController.text.trim(),
      );

      UsuarioDao _dao = UsuarioDao();

      if (_idAtualizaUsuario == null) {
        await _dao.add(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário criado", style: TextStyle(color: Colors.black54)),
                backgroundColor: Colors.green[200]));
      } else {
        await _dao.update(usuario);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário atualizado", style: TextStyle(color: Colors.black54)),
                backgroundColor: Colors.green[200]));

        _idAtualizaUsuario = null;
      }

      _formKey.currentState!.reset();
      _nomeController.clear();
      _sobrenomeController.clear();
      _logradouroController.clear();
      _numController.clear();
      _bairroController.clear();
      _cidadeController.clear();
      _ufController.clear();
      _cepController.clear();

      setState(() {});
    } else
      setState(() {
        _resultado = "Erro ao salvar perfil, verifique se todos os campos estão preenchidos corretamente!";
      });
  }
}
