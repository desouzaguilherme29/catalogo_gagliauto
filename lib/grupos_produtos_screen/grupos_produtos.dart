import 'package:catalogo_gagliauto/list_produtos_screen/produtos_list.dart';
import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:catalogo_gagliauto/templates/template_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:side_header_list_view/side_header_list_view.dart'
    show SideHeaderListView;

class Grupos_Produtos extends StatefulWidget {
  @override
  _Grupos_ProdutosState createState() => _Grupos_ProdutosState();
}

class _Grupos_ProdutosState extends State<Grupos_Produtos> {
  TextEditingController _controllerPesquisa = new TextEditingController();
  var list;

  @override
  Future _getGrupos() async {
    http.Response response;

    if (_controllerPesquisa.text == null || _controllerPesquisa.text.isEmpty)
      response = await http.get(getUrlListaDeGrupos(filtro: ""));
    else
      response =
          await http.get(getUrlListaDeGrupos(filtro: _controllerPesquisa.text));

    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupos de Produtos"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white10,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 55,
                child: TextField(
                  style: TextStyle(fontSize: 15),
                  controller: _controllerPesquisa,
                  decoration: InputDecoration(
                      hintText: "Pesquisar...",
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  onSubmitted: (pesquisa) {
                    setState(() {});
                  },
                  onChanged: (pesquisa) {
                    if (pesquisa.isEmpty || pesquisa == "") setState(() {});
                  },
                ),
              )),
          Expanded(
            child: FutureBuilder(
              future: _getGrupos(),
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
                      return ErroCarregarDados();
                    else
                      return _carregaGrupos(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.all(3),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    snapshot.data[index]["nome01_gru"].toString(),
                    style: TextStyle(fontSize: 14, fontFamily: "sans-serif"),
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _carregaGrupos(BuildContext context, AsyncSnapshot snapshot) {
    return new SideHeaderListView(
      itemCount: snapshot.data.length,
      padding: new EdgeInsets.all(16.0),
      itemExtend: 48.0,
      headerBuilder: (BuildContext context, int index) {
        return new SizedBox(
            width: 32.0,
            child: new Text(snapshot.data[index]["nome01_gru"].substring(0, 1),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)));
      },
      itemBuilder: (BuildContext context, int index) {
        return new Container(
            margin: EdgeInsets.all(3),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Produtos_list(
                              snapshot.data[index]["nome01_gru"].toString())));
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snapshot.data[index]["nome01_gru"].toString(),
                        style:
                            TextStyle(fontSize: 14, fontFamily: "sans-serif"),
                      ),
                    ),
                  ],
                )));
      },
      hasSameHeader: (int a, int b) {
        return snapshot.data[a]["nome01_gru"].substring(0, 1) ==
            snapshot.data[b]["nome01_gru"].substring(0, 1);
      },
    );
  }
}
