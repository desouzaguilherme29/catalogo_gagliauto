import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProdutoDetalhe extends StatefulWidget {
  AsyncSnapshot snapshot;

  ProdutoDetalhe(this.snapshot);


  @override
  _ProdutoDetalheState createState() => _ProdutoDetalheState();
}

class _ProdutoDetalheState extends State<ProdutoDetalhe> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produto"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Carousel(
              images: widget.snapshot.data[0]["fotos"].map((url){
                print(url);
                return FadeInImage(
                    image: Image.memory(Base64Decoder().convert(url
                        .toString()
                        .replaceAll("\n", "").replaceAll("{foto: ", "").replaceAll("}", "")))
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.snapshot.data[0]["descri_pro"],
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${widget.snapshot.data[0]["pvenda_sld"].toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 16.0,),
                /*Text(
                  "Tamanho",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5
                    ),
                    children: product.sizes.map(
                            (s){
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                size = s;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  border: Border.all(
                                      color: s == size ? primaryColor : Colors.grey[500],
                                      width: 3.0
                                  )
                              ),
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Text(s),
                            ),
                          );
                        }
                    ).toList(),
                  ),
                ),*/

                SizedBox(height: 16.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  widget.snapshot.data[0]["descri_pro"],
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
