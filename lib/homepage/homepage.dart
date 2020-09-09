import 'package:catalogo_gagliauto/carrinho.dart';
import 'package:catalogo_gagliauto/destaques.dart';
import 'package:catalogo_gagliauto/favoritos.dart';
import 'package:catalogo_gagliauto/grupos_produtos.dart';
import 'package:catalogo_gagliauto/homepage/widgets/stagger_animation.dart';
import 'package:catalogo_gagliauto/teste.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  int currentTab = 0;
  final List<Widget> screens = [
    Destaques(),
    Grupos_Produtos(),
    Carrinho(),
    Favoritos(),
  ]; 
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Teste();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000)
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StaggerAnimation(controller: _controller.view,),
        Scaffold(
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.shopping_cart),
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Carrinho()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Teste(); // if user taps on this dashboard tab will be active
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              color:
                                  currentTab == 0 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              'Início',
                              style: TextStyle(
                                color: currentTab == 0
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Grupos_Produtos(); // if user taps on this dashboard tab will be active
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.format_list_bulleted,
                              color:
                                  currentTab == 1 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              'Categorias',
                              style: TextStyle(
                                color: currentTab == 1
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Favoritos(); // if user taps on this dashboard tab will be active
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color:
                                  currentTab == 2 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              'Favoritos',
                              style: TextStyle(
                                color: currentTab == 2
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                Carrinho(); // if user taps on this dashboard tab will be active
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.more_horiz,
                              color:
                                  currentTab == 3 ? Colors.blue : Colors.black,
                            ),
                            Text(
                              'Mais',
                              style: TextStyle(
                                color: currentTab == 3
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
