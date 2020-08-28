import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/page/cart_page.dart';
import 'package:jd_app/page/category_page.dart';
import 'package:jd_app/page/home_page.dart';
import 'package:jd_app/page/user_page.dart';
import 'package:jd_app/provider/bottom_navi_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Consumer<BottomNaviProvider>(
          builder: (_, mProvider, __) {
            return BottomNavigationBar(
              currentIndex: mProvider.bottomNaviIndex,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('Home')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category), title: Text('Category')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    title: Text('Shopping Cart')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), title: Text('User')),
              ],
              onTap: (index) => {mProvider.changeBottomNaviIndex(index)},
            );
          },
        ),
        body: Consumer<BottomNaviProvider>(
            builder: (_, mProvider, __) => IndexedStack(
                  index: mProvider.bottomNaviIndex,
                  //El control de capa solo muestra uno
                  children: <Widget>[
                    HomePage(),
                    CategoryPage(),
                    CartPage(),
                    UserPage()
                  ],
                )));
  }
}
