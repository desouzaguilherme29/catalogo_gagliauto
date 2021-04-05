import 'dart:async';
import 'dart:convert';
import 'package:catalogo_gagliauto/carrinho_screen/carrinho.dart';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/widgets/ListViewEquivalencias.dart';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/widgets/gesture_informacoes_tecnicas.dart';
import 'package:catalogo_gagliauto/detalhes_produtos_screen/widgets/gesturedescricaoproduto.dart';
import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProdutoDetalhe extends StatefulWidget {
  String codigo_pro;
  bool tp_favorito;

  ProdutoDetalhe({@required this.codigo_pro, @required this.tp_favorito});

  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {
  TextEditingController _controllerQuantidade = TextEditingController();
  int quantidade = 1;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future _getProdutoDetalhes() async {
    try {
      http.Response response;

      response = await http.get(getUrlDadosProduto(codigo: widget.codigo_pro));

      return json.decode(response.body);
    } on IntegerDivisionByZeroException catch (e) {
      print(e);
    }
  }

  Future _getFotosProduto() async {
    try {
      http.Response response;

      response = await http.get(getUrlFotosProduto(codigo: widget.codigo_pro));

      return json.decode(response.body);
    } on IntegerDivisionByZeroException catch (e) {
      print(e);
    }
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

  _addCarrinho(String produto, num quantidade) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    http.Response response;

    Map data = {
      'codigo_car': prefs.getString("code_user"),
      'produt_car': produto,
      'quanti_car': quantidade
    };

    var body = json.encode(data);

    response = await http.post(getUrlAddProdutoCarrinho(), body: body);

    if (response.statusCode == 201) {
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text('Produto adicionado ao carrinho!'),
      ));

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Carrinho()));
    } else {}
  }

  _addFavorito() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    http.Response response;

    response = await http.get(getUrlAddProdutoFavorito(
        cliente: prefs.getString("code_user"), produto: widget.codigo_pro));

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _controllerQuantidade.text = quantidade.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("Produto"),
        centerTitle: true,
        actions: <Widget>[
          widget.tp_favorito
              ? IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    size: 30,
                  ),
                  color: Colors.red,
                  tooltip: 'Adicionar aos Favoritos',
                  onPressed: _addFavorito,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 30,
                  ),
                  tooltip: 'Adicionar aos Favoritos',
                  onPressed: _addFavorito,
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
      ),
    );
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            /*Container(
              height: MediaQuery.of(context).size.width / 2,
              child: FutureBuilder(
                future: _getFotosProduto(),
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
                        return _createSlideImagens(context, snapshot);
                  }
                },
              ),
            ),*/
            Text(
              snapshot.data[0]["DESCRI_PRO"],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "(Ref.: " +
                      snapshot.data[0]["RFABRI_PRO"].toString() +
                      " Cód.: " +
                      snapshot.data[0]["CODIGO_PRO"].toString() +
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
              snapshot.data[0]["PVENDA_SLD"],
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
                onTap: () {
                  _addCarrinho(snapshot.data[0]["CODIGO_PRO"].toString(),
                      num.parse(_controllerQuantidade.text));
                },
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
                                child: Icon(
                                  Icons.shopping_cart,
                                  size: 35,
                                  color: Colors.white,
                                )),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Adicionar ao carrinho",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3),
                                ),
                              ),
                            ),
                          ],
                        ) //_buildInside(context),
                        )),
              ),
            ),
            GestureDescricaoProduto(
                detalhes:
                    snapshot.data[0]["DESCRI_APL"].toString().toString() ==
                            "null"
                        ? "Produto sem descrição... :("
                        : snapshot.data[0]["DESCRI_APL"]),
            GestureInformacoesTecnicas(
              snapshot: snapshot,
            ),
            ListviewEquivalencias(codigo_pro: widget.codigo_pro)
          ],
        );
      },
    );
  }

  Widget _createSlideImagens(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return FadeInImage(
            height: 50,
            image: Image.memory(Base64Decoder().convert(snapshot.data[0]["FOTO"]
                    .toString()
                    .replaceAll("\n", "")
                    .replaceAll("\r", "")))
                .image,
            placeholder: AssetImage('imagens/carrega_produtos.GIF'));
      },
    );
  }
}
