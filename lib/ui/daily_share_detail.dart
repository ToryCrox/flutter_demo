//https://www.mimikko.cn/client/web_store/buzz/article#12d2faef-9b97-4ccb-95e0-c9f6c34963e3
//api:  https://bms2.mimikko.cn/api/v1/public/daily_buzz/article/{id}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/daily_share_detail.dart';

class DailyShareDetail extends StatefulWidget {
  final String _detailId;

  const DailyShareDetail(this._detailId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DailyShareDetailState(_detailId);
  }
}

class DailyShareDetailState extends State<DailyShareDetail> {
  static final String url_pref =
      "https://bms2.mimikko.cn/api/v1/public/daily_buzz/article/";
  final String _detailId;

  var _isLoading = false;
  ShareDetailBean _detail;

  DailyShareDetailState(this._detailId);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          'Detail',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: _buildWidget(),
    );
  }

  Widget _buildWidget() {
    if (_detail == null) {
      return new Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return new Text(_detail.data.title);
        } else if (index == 1) {
          return new Row(
            children: <Widget>[
              new Text("兽耳安利姬"),
              new Text(_detail.data.publicationDate)
            ],
          );
        } else {
          ShareDetailContent content = _detail.data.mainContent[index - 2];
          if (content.image != null) {
            return new CachedNetworkImage(
              imageUrl: content.image.url +
                  "?x-oss-process=image/resize,m_mfit,w_400",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            );
          } else if (content.textual != null) {
            return Text(content.textual.content);
          } else {
            return new SizedBox(
              height: 1,
            );
          }
        }
      },
      itemCount: _detail.data.mainContent.length + 2,
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    print("loadData id=$_detailId");
    Dio dio = new Dio();
    Response response = await dio.get(url_pref + _detailId);
    ShareDetailBean bean = ShareDetailBean.fromJson(response.data);
    print("loadData data=$bean");
    setState(() {
      _detail = bean;
    });
  }
}
