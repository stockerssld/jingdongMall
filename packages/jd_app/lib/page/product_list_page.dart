import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/model/product_info_model.dart';
import 'package:jd_app/provider/product_list_provider.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  final String title;
  ProductListPage({Key key, this.title}) : super(key: key);
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: Container(
        color: Color(0xFFF7f7f7),
        child: Consumer<ProductListProvider>(
          builder: (_, provider, __) {
            if (provider.isLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (provider.isError) {
              return Center(
                child: Column(
                  children: [
                    Text("Ha ocurrido un error."),
                    OutlineButton(
                      child: Text("Actualizar"),
                      onPressed: provider.loadProductList(),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                ProductInfoModel model = provider.list[index];
                // print(model.toJson());
              },
            );
          },
        ),
      ),
    );
  }
}
