import 'package:flutter/material.dart';
import 'sidebar.dart';
import '../screens/perfil/perfil.dart';
import '../screens/paleta/paleta.dart';

class MenuOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuOptionsState();
  }
}

class MenuOptionsState extends State<MenuOptions> {
  int paginaAtual = 0;
  PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.cake_outlined),
        centerTitle: true,
        backgroundColor: Colors.green[100],
      ),
      drawer: Sidebar(),
      body: PageView(
        controller: pageController,
        onPageChanged: setPaginaAtual,
        children: [Perfil(), Paleta()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        backgroundColor: Colors.orange[100],
        type: BottomNavigationBarType.fixed,
        items: [
          /*BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: "Tarefas",
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Perfil",
          ),
         /* BottomNavigationBarItem(
            icon: Icon(Icons.gif_box_outlined),
            label: "Gifs",
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.palette_outlined),
            label: "Cores",
          ),
        ],
        onTap: (pagina) {
          pageController?.animateToPage(
            pagina,
            duration: Duration(microseconds: 400),
            curve: Curves.ease,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
}
