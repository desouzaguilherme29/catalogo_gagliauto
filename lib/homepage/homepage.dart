import 'package:catalogo_gagliauto/carrinho_screen/carrinho.dart';
import 'package:catalogo_gagliauto/favoritos_screen/favoritos.dart';
import 'package:catalogo_gagliauto/grupos_produtos_screen/grupos_produtos.dart';
import 'package:catalogo_gagliauto/homepage/widgets/stagger_animation.dart';
import 'package:catalogo_gagliauto/destaques_screen/destaque_screen.dart';
import 'package:catalogo_gagliauto/right_menu/right_menu.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int currentTab = 0;
  final List<Widget> screens = [
    DestaquesScreen(
    ),
    Grupos_Produtos(),
    Carrinho(),
    Favoritos(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =
      DestaquesScreen();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      endDrawer: new Menu(),
      key: _scaffoldKey,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(38, 36, 99, 1.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Carrinho()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    minWidth: MediaQuery.of(context).size.width*0.20,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            DestaquesScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 0
                              ? Colors.blue
                              : Color.fromRGBO(38, 36, 99, 1.0),
                        ),
                        Text(
                          'Início',
                          style: TextStyle(
                            color: currentTab == 0
                                ? Colors.blue
                                : Color.fromRGBO(38, 36, 99, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.20,
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
                          color: currentTab == 1
                              ? Colors.blue
                              : Color.fromRGBO(38, 36, 99, 1.0),
                        ),
                        Text(
                          'Categorias',
                          style: TextStyle(
                            color: currentTab == 1
                                ? Colors.blue
                                : Color.fromRGBO(38, 36, 99, 1.0),
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
                    minWidth: MediaQuery.of(context).size.width*0.20,
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
                          Icons.favorite_border,
                          color: currentTab == 2
                              ? Colors.blue
                              : Color.fromRGBO(38, 36, 99, 1.0),
                        ),
                        Text(
                          'Favoritos',
                          style: TextStyle(
                            color: currentTab == 2
                                ? Colors.blue
                                : Color.fromRGBO(38, 36, 99, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.20,
                    onPressed: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.more_horiz,
                          color: currentTab == 3
                              ? Colors.blue
                              : Color.fromRGBO(38, 36, 99, 1.0),
                        ),
                        Text(
                          'Mais',
                          style: TextStyle(
                            color: currentTab == 3
                                ? Colors.blue
                                : Color.fromRGBO(38, 36, 99, 1.0),
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
    );
  }
}
