import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:catalogo_gagliauto/carrinho_screen/widgets/stagger_animation.dart';
import 'package:catalogo_gagliauto/templates/loading.dart';
import 'package:catalogo_gagliauto/templates/template_error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

Future _getCarrinho() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  http.Response response;

  response =
  await http.get(getUrlCarrinho(codigo_cli: prefs.getString("code_user")));

  return json.decode(response.body);
}

Future _getTotalCarrinho() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  http.Response response;

  response =
  await http.get(getUrlTotalCarrinho(codigo_cli: prefs.getString("code_user")));

  return json.decode(response.body);
}

class _CarrinhoState extends State<Carrinho>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        /*Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));*/
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Carrinho"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _getCarrinho(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Loading();
                      break;
                    default:
                      if (snapshot.hasError)
                        return ErroCarregarDados();
                      else
                        return _createGradeTable(context, snapshot);
                  }
                },
              ),
            ),
            Container(
                height: 180,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          2.0,
                          2.0,
                        ),
                      )
                    ]),
                child:
                FutureBuilder(
                  future: _getTotalCarrinho(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loading();
                        break;
                      default:
                        if (snapshot.hasError)
                          return ErroCarregarDados();
                        else
                          return Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 25),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 35.0),
                                        child: Text(
                                          "Total do pedido",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("  "),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        margin: EdgeInsets.all(25),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "R\$ ${snapshot.data[0]["total"]
                                              .toString()}",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(""),
                                    ),
                                  ],
                                ),
                              ),
                              StaggerAnimation(
                                controller: _animationController,
                              )
                            ],
                          )
                    ;
                  }
                  },
                )
            )
          ],
        ));
  }

  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          //_editingController.value = _editingController.value + double.parse(snapshot.data[index]["pvenda_sld"].toString());
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
                margin: EdgeInsets.all(2),
                color: Colors.white,
                child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: FadeInImage(
                              height: 120,
                              width: 160,
                              image: snapshot.data[index]["fotos"].toString() == "0" ? AssetImage('imagens/sem_imagem.jpg') : Image.memory(Base64Decoder()
                                  .convert(snapshot
                                  .data[index]["fotos"][0]
                              ["foto"]
                                  .toString()
                                  .replaceAll("\n", "")
                                  .replaceAll("\r", "")
                              ))
                                  .image,
                              placeholder: AssetImage('imagens/carrega_produtos.GIF')),
                          title: Text(
                            snapshot.data[index]["descri_pro"],
                            style: TextStyle(fontSize: 16),
                          ),
                          //trailing: Text(snapshot.data[index]["quanti_car"].toString()),
                          subtitle: Text("Cód.: " +
                              snapshot.data[index]["codigo_pro"].toString() +
                              " Marca: " +
                              snapshot.data[index]["descri_mar"].toString() +
                              " Ref.: " +
                              snapshot.data[index]["rfabri_pro"].toString()),
                          onTap: () {},
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  snapshot.data[index]["quanti_car"]
                                      .toString() +
                                      " Unidades",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(""),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  "R\$ ${snapshot.data[index]["total"]
                                      .toString()}",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ))),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: 'Apagar',
                  color: Colors.red,
                  iconWidget: Icon(
                    Icons.delete, size: 35, color: Colors.white,),
                  onTap: () {}),
            ],
          );
        });
  }
}
