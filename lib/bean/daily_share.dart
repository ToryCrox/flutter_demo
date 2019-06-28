import 'dart:convert' show json;

class DailyShareList {
  List<DailyShare> data;

  DailyShareList.fromParams({this.data});

  factory DailyShareList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DailyShareList.fromJson(json.decode(jsonStr))
          : new DailyShareList.fromJson(jsonStr);

  DailyShareList.fromJson(jsonRes) {
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']) {
      data.add(dataItem == null ? null : new DailyShare.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"data": $data}';
  }
}

class DailyShare {
  String coverImage;
  String id;
  String publicationDate;
  String title;

  DailyShare.fromParams(
      {this.coverImage, this.id, this.publicationDate, this.title});

  DailyShare.fromJson(jsonRes) {
    coverImage = jsonRes['cover_image'];
    id = jsonRes['id'];
    publicationDate = jsonRes['publication_date'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"cover_image": ${coverImage != null ? '${json.encode(coverImage)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"publication_date": ${publicationDate != null ? '${json.encode(publicationDate)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'}}';
  }
}
