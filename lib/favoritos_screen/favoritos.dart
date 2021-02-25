import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:catalogo_gagliauto/templates/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}


Future _getFavoritos() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  http.Response response;

  response =
  await http.get(getUrlFavoritos(codigo_cli: prefs.getString("code_user")));

  return json.decode(response.body);
}

class _FavoritosState extends State<Favoritos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),

      ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _getFavoritos(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Loading();
                      break;
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGradeTable(context, snapshot);
                  }
                },
              ),
            ),
          ],
        )
    );
  }
  Widget _createGradeTable(BuildContext context, AsyncSnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
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
                              width: 75,
                              image:
                              Image.memory(base64Decode(
                                  snapshot
                                      .data[index]["fotos"][0]["foto"]
                                      .toString().replaceAll("\n", "").replaceAll("\r", "")))
                                  .image,

                              placeholder:
                              AssetImage('imagens/carrega_produtos.GIF')
                          ),
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
                                child: Text("",
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
                                  "R\$ ${snapshot.data[index]["pvenda_sld"]
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
