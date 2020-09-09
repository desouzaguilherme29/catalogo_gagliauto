import 'dart:async';
import 'dart:convert';
import 'package:catalogo_gagliauto/produto_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Teste extends StatefulWidget {
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  Future _getProdutos() async {
    http.Response response;

    response = await http.get(
        "http://187.60.219.28:8830/MOBILE/MBSERVER.V/?FUNCAO=GETSCRIPT&VERSAO=20191030&ROTINA=PRODUTO&FILTRO=false");

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Bem Vindo!', style: TextStyle(fontWeight: FontWeight.bold),),
                background: Image.network(
                  "https://images.tcdn.com.br/img/img_prod/675792/6l_oleo_motorcraft_5w30_sintetico_filtro_tm1_linha_ford_763_1_20190308164900.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            FutureBuilder(
              future: _getProdutos(),
              builder: (context, projectSnap) {
                var childCount = 0;
                if (projectSnap.connectionState != ConnectionState.done ||
                    projectSnap.hasData == null)
                  childCount = 1;
                else
                  childCount = projectSnap.data.length;
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (projectSnap.connectionState != ConnectionState.done) {
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
                    }
                    if (projectSnap.hasData == null) {
                      return Container();
                    }
                    /*return GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10),
                  itemCount: projectSnap.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: FadeInImage(
                                image: Image.memory(Base64Decoder().convert(projectSnap
                                    .data[index]["fotos"][0]["foto"]
                                    .toString()
                                    .replaceAll("\n", "")))
                                    .image,
                                placeholder: AssetImage('imagens/carrega_produtos.GIF')),
                          ),
                          Padding(
                            padding: EdgeInsets.all(1),
                            child: Text(projectSnap.data[index]["descri_pro"].toString(), style: TextStyle(fontSize: 12, fontFamily: "sans-serif"),),
                          )
                        ],
                      ),
                    );
                  },
                );*/
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: projectSnap.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        ProdutoDetalhe(projectSnap))
                                );
                              },
                              child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      AspectRatio(
                                        aspectRatio: 1.0,
                                        child: FadeInImage(
                                            image: Image
                                                .memory(Base64Decoder().convert(
                                                projectSnap
                                                    .data[index]["fotos"][0]["foto"]
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
                                                projectSnap
                                                    .data[index]["descri_pro"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .w500),
                                              ),
                                              Text(
                                                "R\$ ${projectSnap
                                                    .data[index]["pvenda_sld"]
                                                    .toString()}",
                                                style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor,
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          );
                        }
                    );
                  }, childCount: childCount),
                );
              },
            ),
          ],
        ));
  }
}
