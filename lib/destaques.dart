import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Destaques extends StatefulWidget {
  @override
  _DestaquesState createState() => _DestaquesState();
}

class _DestaquesState extends State<Destaques> {
  String _search;

  Future _getProdutos() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(
          "http://187.60.219.28:8830/MOBILE/MBSERVER.V/?FUNCAO=GETSCRIPT&VERSAO=20191030&ROTINA=PRODUTO&FILTRO=false");
    else
      response = await http.get(
          "http://187.60.219.28:8830/MOBILE/MBSERVER.V/?FUNCAO=GETSCRIPT&VERSAO=20191030&ROTINA=PRODUTO&FILTRO=false");

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Destaques"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _getProdutos(),
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 168,
                              child: Image.asset("imagens/loading.GIF"),
                            ),
                            //Text("")
                          ],
                        ),
                      ),
                    );
                    break;
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGradeTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
  //Image.asset("imagens/promocao.jpg"),
  return GridView.builder(
    padding: EdgeInsets.all(5),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10),
    itemCount: snapshot.data.length,
    itemBuilder: (context, index) {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FadeInImage(
                  image: Image.memory(Base64Decoder().convert(snapshot
                      .data[index]["fotos"][0]["foto"]
                      .toString()
                      .replaceAll("\n", "")))
                      .image,
                  placeholder: AssetImage('imagens/carrega_produtos.GIF')),
            ),
            Padding(
              padding: EdgeInsets.all(1),
              child: Text(snapshot.data[index]["descri_pro"].toString(), style: TextStyle(fontSize: 12, fontFamily: "sans-serif"),),
            )
          ],
        ),
      );
    },
  );
}
}
