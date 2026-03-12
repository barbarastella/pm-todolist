import 'package:flutter/material.dart';

class GifDetail extends StatelessWidget {

  final Map _gifData;

  GifDetail(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
      ),
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
