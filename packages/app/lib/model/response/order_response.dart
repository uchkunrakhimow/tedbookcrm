class OrderResponse {
  String? message;
  Data? data;

  OrderResponse({this.message, this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? total;
  int? page;
  int? totalPages;
  List<OrderModel>? ordersList;

  Data({this.total, this.page, this.totalPages, this.ordersList});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    totalPages = json['totalPages'];
    if (json['orders'] != null) {
      ordersList = <OrderModel>[];
      json['orders'].forEach((v) {
        ordersList!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;
    if (this.ordersList != null) {
      data['orders'] = this.ordersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderModel {
  String? id;
  OperatorId? operatorId;
  OperatorId? courierId;
  OperatorId? logisticianId;
  String? fullName;
  String? phoneNumber;
  String? phoneNumber2;
  String? status;
  List<ProductsIds>? productsIds;
  String? region;
  String? address;
  bool? isArchive;
  List<MessageModel>? messages;
  List<Payments>? payments;
  String? createdAt;
  String? updatedAt;
  List<EditHistory>? editHistory;
  bool? isExpanded;

  OrderModel({
    this.id,
    this.operatorId,
    this.courierId,
    this.logisticianId,
    this.fullName,
    this.phoneNumber,
    this.phoneNumber2,
    this.status,
    this.productsIds,
    this.region,
    this.address,
    this.isArchive,
    this.messages,
    this.payments,
    this.createdAt,
    this.updatedAt,
    this.editHistory,
    this.isExpanded,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    operatorId = json['operatorId'] != null
        ? OperatorId.fromJson(json['operatorId'])
        : null;
    courierId = json['courierId'] != null
        ? OperatorId.fromJson(json['courierId'])
        : null;
    logisticianId = json['logisticianId'] != null
        ? OperatorId.fromJson(json['logisticianId'])
        : null;
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    phoneNumber2 = json['phoneNumber2'];
    status = json['status'];
    if (json['productsIds'] != null) {
      productsIds = <ProductsIds>[];
      json['productsIds'].forEach((v) {
        productsIds!.add(ProductsIds.fromJson(v));
      });
    }
    region = json['region'];
    address = json['address'];
    isArchive = json['is_archive'];
    if (json['messages'] != null) {
      messages = <MessageModel>[];
      json['messages'].forEach((v) {
        messages!.add(MessageModel.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(Payments.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['editHistory'] != null) {
      editHistory = <EditHistory>[];
      json['editHistory'].forEach((v) {
        editHistory!.add(EditHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.operatorId != null) {
      data['operatorId'] = this.operatorId!.toJson();
    }
    if (this.courierId != null) {
      data['courierId'] = this.courierId!.toJson();
    }
    if (this.logisticianId != null) {
      data['logisticianId'] = this.logisticianId!.toJson();
    }
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumber2'] = this.phoneNumber2;
    data['status'] = this.status;
    if (this.productsIds != null) {
      data['productsIds'] = this.productsIds!.map((v) => v.toJson()).toList();
    }
    data['region'] = this.region;
    data['address'] = this.address;
    data['is_archive'] = this.isArchive;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.editHistory != null) {
      data['editHistory'] = this.editHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OperatorId {
  String? id;
  String? name;
  String? username;

  OperatorId({this.id, this.name, this.username});

  OperatorId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }
}

class ProductsIds {
  String? id;
  String? title;
  String? price;
  String? comment;

  ProductsIds({this.id, this.title, this.price, this.comment});

  ProductsIds.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    price = json['price'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['comment'] = this.comment;
    return data;
  }
}

class Payments {
  String? method;
  int? amount;
  String? id;

  Payments({this.method, this.amount, this.id});

  Payments.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['method'] = this.method;
    data['amount'] = this.amount;
    data['_id'] = this.id;
    return data;
  }
}

class EditHistory {
  OperatorId? editorId;
  String? editTime;
  double? editDuration;
  String? id;

  EditHistory({this.editorId, this.editTime, this.editDuration, this.id});

  EditHistory.fromJson(Map<String, dynamic> json) {
    editorId =
        json['editorId'] != null ? OperatorId.fromJson(json['editorId']) : null;
    editTime = json['editTime'];
    editDuration = json['editDuration'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.editorId != null) {
      data['editorId'] = this.editorId!.toJson();
    }
    data['editTime'] = this.editTime;
    data['editDuration'] = this.editDuration;
    data['_id'] = this.id;
    return data;
  }
}

class MessageModel {
  String? commenterRole;
  String? commentText;
  String? orderId;
  String? createdAt;

  MessageModel(
      {this.commenterRole, this.commentText, this.orderId, this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    commenterRole = json['commenterRole'];
    commentText = json['commentText'];
    orderId = json['orderId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commenterRole'] = this.commenterRole;
    data['commentText'] = this.commentText;
    data['orderId'] = this.orderId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
