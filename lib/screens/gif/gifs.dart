import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_todolist/components/editor.dart';
import 'gifs_detail.dart';
import 'package:transparent_image/transparent_image.dart';

class GifsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GifsPageState();
  }
}

class GifsPageState extends State<GifsPage> {
  static const String _key = 'As9UpHZT7mwIhrr1jPhG6VsJ4LA9GwyO'; // chave teste

  TextEditingController _controllerGif = TextEditingController();
  String? _search = null;
  int _offset = 0;

  final url = Uri.parse(
    "https://api.giphy.com/v1/gifs/trending?api_key=$_key&limit=19&offset=0&rating=gbundle=messaging_non_clips",
  );

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search!.isEmpty)
      response = await http.get(url);
    else {
      final url2 = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=$_key&q=$_search!&limit=19&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips",
      );
      response = await http.get(url2);
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Busca de gifs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[50],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Editor(
                    _controllerGif,
                    "Pesquisar",
                    "Digite um termo (ex: cats)",
                  ),
                ),
                SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _search = _controllerGif.text.trim();
                      _offset = 0;
                    });
                  },
                  icon: Icon(Icons.search),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.purple,
                        ),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 100.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifDetail(snapshot.data["data"][index]),
                ),
              );
            },
          );
        else
          return Container(
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12.0)
            ),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.black54, size: 50.0),
                  Text(
                    "Mostrar mais",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      },
    );
  }
}
