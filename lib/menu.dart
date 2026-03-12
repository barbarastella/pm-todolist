import 'package:flutter/material.dart';
import 'screens/endereco/cep.dart';
import 'screens/tarefa/lista_tarefa.dart';
import 'screens/gif/gifs.dart';
import 'screens/paleta/paleta.dart';

class MenuOptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MenuOptionsState();
  }
}

class MenuOptionsState extends State<MenuOptions>{
  int paginaAtual = 0;
  PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: setPaginaAtual,
        children: [
          ListaTarefa(),
          Cep(),
          GifsPage(),
          Paleta()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        backgroundColor: Colors.orange[100],
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined),
              label: "Tarefas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office_outlined),
              label: "CEP"),
          BottomNavigationBarItem(
              icon: Icon(Icons.gif_box_outlined),
              label: "Gifs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.palette_outlined),
              label: "Cores"),
        ],
        onTap: (pagina) {
          pageController?.animateToPage(pagina,
              duration: Duration(microseconds: 400),
              curve: Curves.ease);
        },
      ),

    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage:  paginaAtual);
  }

  setPaginaAtual(pagina){
    setState(() {
      paginaAtual = pagina;
    });
  }
}
