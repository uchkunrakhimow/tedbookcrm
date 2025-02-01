class NotificationModel {
  String? title;
  List<String>? titleLocArgs;
  String? titleLocKey;
  String? body;
  List<String>? bodyLocArgs;
  String? bodyLocKey;
  Android? android;
  String? apple;
  String? web;

  NotificationModel({
    this.title,
    this.titleLocArgs,
    this.titleLocKey,
    this.body,
    this.bodyLocArgs,
    this.bodyLocKey,
    this.android,
    this.apple,
    this.web,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    titleLocArgs = json['titleLocArgs'] != null
        ? json['titleLocArgs'].cast<String>()
        : null;
    titleLocKey = json['titleLocKey'];
    body = json['body'];
    bodyLocArgs =
        json['bodyLocArgs'] != null ? json['bodyLocArgs'].cast<String>() : null;
    bodyLocKey = json['bodyLocKey'];
    android =
        json['android'] != null ? new Android.fromJson(json['android']) : null;
    apple = json['apple'];
    web = json['web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['titleLocArgs'] = this.titleLocArgs;
    data['titleLocKey'] = this.titleLocKey;
    data['body'] = this.body;
    data['bodyLocArgs'] = this.bodyLocArgs;
    data['bodyLocKey'] = this.bodyLocKey;
    if (this.android != null) {
      data['android'] = this.android!.toJson();
    }
    data['apple'] = this.apple;
    data['web'] = this.web;
    return data;
  }
}

class Android {
  String? channelId;
  String? clickAction;
  String? color;
  String? count;
  String? imageUrl;
  String? link;
  int? priority;
  String? smallIcon;
  String? sound;
  String? ticker;
  String? tag;
  int? visibility;

  Android({
    this.channelId,
    this.clickAction,
    this.color,
    this.count,
    this.imageUrl,
    this.link,
    this.priority,
    this.smallIcon,
    this.sound,
    this.ticker,
    this.tag,
    this.visibility,
  });

  Android.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    clickAction = json['clickAction'];
    color = json['color'];
    count = json['count'];
    imageUrl = json['imageUrl'];
    link = json['link'];
    priority = json['priority'];
    smallIcon = json['smallIcon'];
    sound = json['sound'];
    ticker = json['ticker'];
    tag = json['tag'];
    visibility = json['visibility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['clickAction'] = this.clickAction;
    data['color'] = this.color;
    data['count'] = this.count;
    data['imageUrl'] = this.imageUrl;
    data['link'] = this.link;
    data['priority'] = this.priority;
    data['smallIcon'] = this.smallIcon;
    data['sound'] = this.sound;
    data['ticker'] = this.ticker;
    data['tag'] = this.tag;
    data['visibility'] = this.visibility;
    return data;
  }
}
