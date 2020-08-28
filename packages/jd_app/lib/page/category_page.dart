import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/model/category_content_model.dart';
import 'package:jd_app/page/product_list_page.dart';
import 'package:jd_app/provider/category_page_provider.dart';
import 'package:jd_app/provider/product_list_provider.dart';
import 'package:jd_app/utils/responsive.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return ChangeNotifierProvider<CategoryPageProvider>(
      create: (context) {
        var provider = new CategoryPageProvider();
        provider.loadCategoryPageData();
        return provider;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Category'),
          ),
          body: Container(
            color: Color(0xFFf4f4f4),
            child: Consumer<CategoryPageProvider>(
              builder: (_, provider, __) {
                // print(provider.isLoading);
                if (provider.isLoading && provider.categoryNavList.length == 0)
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                if (provider.isError)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(provider.errorMsg),
                        OutlineButton(
                          child: Text('Actualizar'),
                          onPressed: () {
                            provider.loadCategoryPageData();
                          },
                        )
                      ],
                    ),
                  );

                // print(provider.categoryNavList);
                return Row(
                  children: <Widget>[
                    buildNavLeftContainer(provider, responsive),
                    Expanded(
                      child: Stack(
                        children: [
                          buildCategoryContent(
                              provider.categoryContentList, responsive),
                          provider.isLoading
                              ? Center(child: CupertinoActivityIndicator())
                              : Container()
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          )),
    );
  }

  Widget buildCategoryContent(
      List<CategoryContentModel> contentList, Responsive responsive) {
    List<Widget> list = List<Widget>();

    for (var i = 0; i < contentList.length; i++) {
      list.add(Container(
        height: responsive.dp(3),
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: Text(
          "${contentList[i].title}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ));
      List<Widget> descList = List<Widget>();
      for (var j = 0; j < contentList[i].desc.length; j++) {
        descList.add(InkWell(
          child: Container(
            width: responsive.wp(17),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets${contentList[i].desc[j].img}",
                  width: responsive.wp(15),
                  height: responsive.hp(10),
                ),
                Text("${contentList[i].desc[j].text}"),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<ProductListProvider>(
                create: (context) {
                  ProductListProvider provider = ProductListProvider();
                  provider.loadProductList();
                  return provider;
                },
                child: Consumer<ProductListProvider>(
                  builder: (_, provider, __) {
                    return Container(
                      child:
                          ProductListPage(title: contentList[i].desc[j].text),
                    );
                  },
                ),
              ),
            ));
          },
        ));
      }

      list.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 7.0,
          runSpacing: 10,
          alignment: WrapAlignment.start,
          children: descList,
        ),
      ));
    }
    return Container(
        width: responsive.wp(75),
        color: Colors.white,
        child: ListView(
          children: list,
        ));
  }

  Container buildNavLeftContainer(
      CategoryPageProvider provider, Responsive responsive) {
    return Container(
      width: responsive.wp(25),
      child: ListView.builder(
          itemCount: provider.categoryNavList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Container(
                height: responsive.dp(5),
                padding: const EdgeInsets.only(top: 25),
                color: provider.tabIndex == index
                    ? Colors.white
                    : Color(0xFFF8F8F8),
                child: Text(provider.categoryNavList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: provider.tabIndex == index
                            ? Color(0xFFe93b3d)
                            : Color(0xFF333333),
                        fontWeight: FontWeight.w500)),
              ),
              onTap: () {
                // print(index);
                provider.loadCategoryContentData(index);
              },
            );
          }),
    );
  }
}
