import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/model/home_page_model.dart';
import 'package:jd_app/provider/home_page_provider.dart';
import 'package:jd_app/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return ChangeNotifierProvider<HomePageProvider>(
      create: (context) {
        var provider = new HomePageProvider();
        provider.loadHomePageData();
        return provider;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('HOME'),
          ),
          body: Container(
            color: Color(0xFFf4f4f4),
            child: Consumer<HomePageProvider>(
              builder: (_, provider, __) {
                // print(provider.isLoading);
                if (provider.isLoading)
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
                            provider.loadHomePageData();
                          },
                        )
                      ],
                    ),
                  );
                HomePageModel model = provider.model;
                return ListView(children: <Widget>[
                  buildAspectRatio(model, responsive),
                  buildLogos(model, responsive),
                  buildMSHeaderContainer(responsive),
                  buildMSBodyContainer(model, responsive),
                  buildAds(model.pageRow.ad1, responsive),
                  buildAds(model.pageRow.ad2, responsive),
                ]);

                // return Container();
              },
            ),
          )),
    );
  }

  // ignore: missing_return
  Widget buildAds(List<String> ads, Responsive responsive) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < ads.length; i++) {
      list.add(Expanded(
        child: Image.asset("assets${ads[i]}"),
      ));
    }
    return Row(
      children: list,
    );
  }

  Column buildMSBodyContainer(HomePageModel model, Responsive responsive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: responsive.dp(15),
          color: Colors.white,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: model.quicks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets${model.quicks[index].image}",
                        width: responsive.dp(15),
                        height: responsive.dp(10),
                      ),
                      Text(
                        '${model.quicks[index].price}',
                        style: TextStyle(
                            color: Colors.red, fontSize: responsive.dp(2)),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Container buildMSHeaderContainer(Responsive responsive) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      height: responsive.dp(5),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/image/bej.png",
            width: responsive.wp(20),
            height: responsive.dp(90),
          ),
          Spacer(),
          Text('More spikes'),
          Icon(CupertinoIcons.right_chevron, size: responsive.dp(1))
        ],
      ),
    );
  }

  Widget buildLogos(HomePageModel model, Responsive responsive) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < model.logos.length; i++) {
      list.add(Container(
          width: responsive.wp(16),
          // height: responsive.hp(16),
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets${model.logos[i].image}",
                width: responsive.wp(20),
                height: responsive.dp(5),
              ),
              Text(
                "${model.logos[i].title}",
                style: TextStyle(fontSize: responsive.dp(1.5)),
              )
            ],
          )));
    }
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: responsive.dp(20),
      padding: const EdgeInsets.all(10),
      child: Wrap(
          spacing: 7.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.spaceBetween,
          children: list),
    );
  }

  AspectRatio buildAspectRatio(HomePageModel model, Responsive responsive) {
    return AspectRatio(
      aspectRatio: 72 / 35,
      child: Swiper(
        itemCount: model.swipers.length,
        pagination: SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset("assets${model.swipers[index].image}");
        },
      ),
    );
  }
}
