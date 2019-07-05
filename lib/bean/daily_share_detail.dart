import 'dart:convert' show json;

class ShareDetailBean {

  ShareDetailData data;

  ShareDetailBean.fromParams({this.data});

  factory ShareDetailBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ShareDetailBean.fromJson(json.decode(jsonStr)) : new ShareDetailBean.fromJson(jsonStr);

  ShareDetailBean.fromJson(jsonRes) {
    data = jsonRes['data'] == null ? null : new ShareDetailData.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"data": $data}';
  }
}

class ShareDetailData {

  Object music;
  String coverImage;
  String id;
  String publicationDate;
  String title;
  List<ShareDetailContent> mainContent;

  ShareDetailData.fromParams({this.music, this.coverImage, this.id, this.publicationDate, this.title, this.mainContent});

  ShareDetailData.fromJson(jsonRes) {
    music = jsonRes['music'];
    coverImage = jsonRes['cover_image'];
    id = jsonRes['id'];
    publicationDate = jsonRes['publication_date'];
    title = jsonRes['title'];
    mainContent = jsonRes['main_content'] == null ? null : [];

    for (var mainContentItem in mainContent == null ? [] : jsonRes['main_content']){
      mainContent.add(mainContentItem == null ? null : new ShareDetailContent.fromJson(mainContentItem));
    }
  }

  @override
  String toString() {
    return '{"music": $music,"cover_image": ${coverImage != null?'${json.encode(coverImage)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"publication_date": ${publicationDate != null?'${json.encode(publicationDate)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"main_content": $mainContent}';
  }
}

class ShareDetailContent {

  ShareDetailContentBean textual;
  ShareDetailContentImage image;

  ShareDetailContent.fromParams({this.textual, this.image});

  ShareDetailContent.fromJson(jsonRes) {
    textual = jsonRes['textual'] == null ? null : new ShareDetailContentBean.fromJson(jsonRes['textual']);
    image = jsonRes['captioned_picture'] == null ? null : new ShareDetailContentImage.fromJson(jsonRes['captioned_picture']);
  }

  @override
  String toString() {
    return '{"textual": $textual}';
  }
}

class ShareDetailContentBean {

  String content;
  String id;

  ShareDetailContentBean.fromParams({this.content, this.id});

  ShareDetailContentBean.fromJson(jsonRes) {
    content = jsonRes['content'];
    id = jsonRes['id'];
  }

  @override
  String toString() {
    return '{"content": ${content != null?'${json.encode(content)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'}}';
  }
}


class ShareDetailContentImage {

  String url;
  String id;
  String description;
  String caption;

  ShareDetailContentImage.fromParams({this.url, this.id, this.description, this.caption});

  ShareDetailContentImage.fromJson(jsonRes) {
    url = jsonRes['url'];
    id = jsonRes['id'];
    id = jsonRes['caption'];
    id = jsonRes['description'];
  }

  @override
  String toString() {
    return '{"url": ${url != null?'${json.encode(url)}':'null'}'
        ',"id": ${id != null?'${json.encode(id)}':'null'}}';
  }
}