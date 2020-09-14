import 'dart:async';
import 'dart:convert';
import 'package:catalogo_gagliauto/carrinho_screen/carrinho.dart';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/produto_detalhe.dart';
import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Produtos_list extends StatefulWidget {
  String codigo_gru;

  Produtos_list(this.codigo_gru);

  @override
  _Produtos_listState createState() => _Produtos_listState();
}

class _Produtos_listState extends State<Produtos_list> {
  @override
  String _search;

  Future _getProdutos() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(getUrlListaDeProdutos(filtro: "false"));
    else
      response = await http.get(getUrlListaDeProdutos(filtro: "false"));

    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.shopping_cart,color: Colors.white,),
            backgroundColor: Color.fromRGBO(38, 36, 99, 0.9),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Carrinho()));
            },
          ),
          appBar: AppBar(
            title: Text(widget.codigo_gru),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder(
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
        ));
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return TabBarView(physics: NeverScrollableScrollPhysics(), children: [
      GridView.builder(
          padding: EdgeInsets.all(4.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 0.65,
          ),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProdutoDetalhe(
                          codigo_pro:
                              snapshot.data[index]["codigo_pro"].toString())));
                },
                child: Card(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: FadeInImage(
                          image: Image.memory(Base64Decoder().convert(snapshot
                                  .data[index]["fotos"][0]["foto"]
                                  .toString()
                                  .replaceAll("\n", "")))
                              .image,
                          placeholder:
                              AssetImage('imagens/carrega_produtos.GIF')),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              snapshot.data[index]["descri_pro"].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ ${snapshot.data[index]["pvenda_sld"].toString()}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )));
          }),
      ListView.builder(
          padding: EdgeInsets.all(4.0),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: FadeInImage(
                      image: Image.memory(Base64Decoder().convert(snapshot
                              .data[index]["fotos"][0]["foto"]
                              .toString()
                              .replaceAll("\n", "")))
                          .image,
                      placeholder: AssetImage('imagens/carrega_produtos.GIF')),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot.data[index]["descri_pro"].toString(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "R\$ ${snapshot.data[index]["pvenda_sld"].toString()}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          })
    ]);
  }
}
