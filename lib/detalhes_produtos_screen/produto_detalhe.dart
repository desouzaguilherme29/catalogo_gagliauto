import 'dart:async';
import 'dart:convert';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/produto_descricao_screen.dart';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/produto_info_tecnicas.dart';
import 'package:catalogo_gagliauto/url_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:carousel_pro/carousel_pro.dart';

class ProdutoDetalhe extends StatefulWidget {
  String codigo_pro;

  ProdutoDetalhe({@required this.codigo_pro});

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  TextEditingController _controllerQuantidade = TextEditingController();
  int quantidade = 1;

  Future _getProdutoDetalhes() async {
    http.Response response;

    response = await http.get(getUrlDadosProduto(codigo: widget.codigo_pro));

    return json.decode(response.body);
  }

  Future _getProdutos() async {
    http.Response response;

    response = await http.get(
        "http://187.60.219.28:8830/MOBILE/MBSERVER.V/?FUNCAO=GETSCRIPT&VERSAO=20191030&ROTINA=PRODUTO&FILTRO=false");
    print('passou');
    return json.decode(response.body);
  }

  _addQuantidade() {
    quantidade += 1;
    _controllerQuantidade.text = quantidade.toString();
  }

  _removeQuantidade() {
    if (quantidade > 1)
      quantidade -= 1;
    else
      quantidade = 1;

    _controllerQuantidade.text = quantidade.toString();
  }

  _addCarrinho() {}

  @override
  void initState() {
    super.initState();
    _controllerQuantidade.text = quantidade.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Produto"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                size: 30,
              ),
              tooltip: 'Adicionar aos Favoritos',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.share,
                size: 30,
              ),
              tooltip: 'Compartilhar',
              onPressed: () {},
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            FutureBuilder(
              future: _getProdutoDetalhes(),
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
          ],
        ));
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: snapshot.data[0]["fotos"].map((url) {
                  return FadeInImage(
                      image: Image
                          .memory(Base64Decoder().convert(url
                          .toString()
                          .replaceAll("\n", "")
                          .replaceAll("{foto: ", "")
                          .replaceAll("}", "")))
                          .image,
                      placeholder: AssetImage('imagens/carrega_produtos.GIF'));
                }).toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotBgColor: Colors.white,
                dotColor: Colors.white,
                autoplay: false,
                borderRadius: true,
              ),
            ),
            Text(
              snapshot.data[0]["descri_pro"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "(Ref.: " + snapshot.data[0]["rfabri_pro"].toString() +
                      " Cód.: " + snapshot.data[0]["codigo_pro"].toString() +
                      ")",
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.black12,
                        width: 1.0,
                      ))),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "R\$ ${snapshot.data[0]["pvenda_sld"].toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Quantidade",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 60,
                        child: ButtonTheme(
                          buttonColor: Color.fromRGBO(38, 36, 99, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: RaisedButton(
                            onPressed: _addQuantidade,
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )),
                  Container(
                    width: 50,
                    child: TextField(
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        controller: _controllerQuantidade,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 60,
                      child: ButtonTheme(
                        buttonColor: Color.fromRGBO(38, 36, 99, 1.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: RaisedButton(
                          onPressed: _removeQuantidade,
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: InkWell(
                onTap: _addCarrinho,
                child: Hero(
                    tag: "fade",
                    child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(38, 36, 99, 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(30.0))),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Icon(Icons.shopping_cart, size: 35,
                                  color: Colors.white,)
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "        Adicionar ao carrinho",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3),
                              ),
                            )


                          ],
                        ) //_buildInside(context),
                    )),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DescricaoProduto(descricao: snapshot
                                  .data[0]["descri_apl"].toString() == "null"
                                  ? "Produto sem descrição... :("
                                  : snapshot.data[0]["descri_apl"])));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  height: 65,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Descrição do Produto",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "sans-serif",
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Container(
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InformacoesTecnicas(snapshot: snapshot,)));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  height: 65,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Informações Técnicas",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "sans-serif",
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Container(
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )),
            FutureBuilder(
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
                              height: 300,
                              child: Image.asset("imagens/loading.GIF"),
                            ),
                          ],
                        ),
                      ),
                    );
                    break;
                  case ConnectionState.done:
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "produtos equivalentes a este",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(5),
                            height: 250,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //projectSnap.data[index][""]
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    width: 160.0,
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProdutoDetalhe(
                                                            codigo_pro: snapshot
                                                                .data[index]
                                                            ["codigo_pro"]
                                                                .toString())));
                                          },
                                          child: FadeInImage(
                                              height: 140,
                                              image: Image
                                                  .memory(Base64Decoder()
                                                  .convert(snapshot.data[index]
                                              ["fotos"][0]["foto"]
                                                  .toString()
                                                  .replaceAll("\n", "")))
                                                  .image,
                                              placeholder: AssetImage(
                                                  'imagens/carrega_produtos.GIF')),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  snapshot
                                                      .data[index]["descri_pro"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "R\$ ${snapshot
                                                .data[index]["pvenda_sld"]
                                                .toString()}",
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2.0,
                                            // has the effect of softening the shadow
                                            spreadRadius: 2.0,
                                            // has the effect of extending the shadow
                                            offset: Offset(
                                              2.0, // horizontal, move right 10
                                              2.0, // vertical, move down 10
                                            ),
                                          )
                                        ]),
                                  );
                                }))
                      ],
                    );
                    break;
                }
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildText(String campo, AsyncSnapshot snapshot) {
    return Container(
        decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              snapshot.data[0][campo].toString(),
              style: TextStyle(fontSize: 16.0),
            )));
  }

  Widget _buildTextDescricao(String texto) {
    return new Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: Text(
          texto,
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
          maxLines: 3,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
