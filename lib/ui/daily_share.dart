// web: https://www.mimikko.cn/client/web_store/buzz/
// api: https://bms2.mimikko.cn/api/v1/public/daily_buzz/articles?offset=0&limit=25
// api: https://api1.mimikko.cn/booklet/daily_buzz/articles/latest


import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/bean/daily_share.dart';

import 'daily_share_detail.dart';

const dailyShareListUrl =
    "https://bms2.mimikko.cn/api/v1/public/daily_buzz/articles";

class DailyShareListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DailyShareListPageState();
  }
}

class DailyShareListPageState extends State<DailyShareListPage> {
  List<DailyShare> _dailyShares = [];
  ScrollController _scrollController;
  bool _isRequesting = false;
  bool _hasMore = true;
  static const int pageCount = 25;

  @override
  Widget build(BuildContext context) {
    if (_dailyShares.isEmpty) {
      return new Container(
        alignment: Alignment.center,
        child: new CircularProgressIndicator(),
      );
    }

    return new RefreshIndicator(
        onRefresh: _loadData,
        child: new ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildSectionTitle("今日分享");
            } else if (index == 1) {
              return _buildTop(_dailyShares[0]);
            } else if (index == 2) {
              return _buildSectionTitle("往期分享");
            }
            return _buildItem(_dailyShares[index - 2]);
          },
          separatorBuilder: (context, index) {
            if (index > 2) {
              return new Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  height: 1,
                ),
              );
            } else {
              return new Container();
            }
          },
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _dailyShares.length > 0 ? _dailyShares.length + 1 : 0,
          controller: _scrollController,
        ));
  }

  @override
  void initState() {
    super.initState();
    _loadData(false);
    _scrollController = new ScrollController();
    _scrollController.addListener(() => {
          if (!_isRequesting &&
              _scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent)
            {_loadData(true)}
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData([bool more = false]) async {
    Dio dio = new Dio();

    _isRequesting = true;
    Response response = await dio.get(dailyShareListUrl, queryParameters: {
      "offset": more ? _dailyShares.length : 0,
      "limit": pageCount
    });
    var list = DailyShareList(response.data);
    setState(() {
      if (list.data.length < pageCount) {
        _hasMore = false;
      }
      _isRequesting = false;
      if (!more) {
        _dailyShares.clear();
      }
      _dailyShares.addAll(list.data);
    });
    print(list.data);
  }

  Widget _buildSectionTitle(String text) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 5,
        ),
        ClipRRect(
          child: Container(
            width: 3,
            color: Colors.red,
            height: 20,
          ),
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        SizedBox(
          width: 3,
        ),
        Text(text,
            style: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildTop(DailyShare share) {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () => _turnDailyShare(share),
          child: _buildTopImage(share),
        ),
      ),
    );
  }

  Widget _buildTopImage(DailyShare share) {
    return new Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        new CachedNetworkImage(
          imageUrl:
              share.coverImage + "?x-oss-process=image/resize,m_mfit,w_300",
          fit: BoxFit.cover,
          width: double.infinity,
          height: 150,
        ),
        new Positioned(
          child: new Text(
            share.title,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: 5,
          left: 10,
          right: 10,
        )
      ],
    );
  }

  Widget _buildItem(DailyShare share) {
    return InkWell(
      onTap: () => _turnDailyShare(share),
      child: new Padding(
        padding: EdgeInsets.all(10),
        child: _getRow(share),
      ),
    );
  }

  Widget _getRow(DailyShare share) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new CachedNetworkImage(
          imageUrl:
              share.coverImage + "?x-oss-process=image/resize,m_mfit,w_160",
          //placeholder: (context, url) => new CircularProgressIndicator(),
          fit: BoxFit.fitWidth,
          width: 148,
          height: 80,
        ),
        new SizedBox(
          width: 5,
        ),
        new Expanded(
            flex: 1,
            child: new Container(
              height: 80,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    share.title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  new Text(
                    share.publicationDate,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  _turnDailyShare(DailyShare share) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => new DailyShareDetail(share.id)));
  }
}
