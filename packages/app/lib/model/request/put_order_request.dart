import 'package:tedbook/model/response/payment_type_model.dart';

class PutOrderRequest {
  bool? isArchive;
  String? statusId;
  List<PaymentTypeModel>? payments;

  PutOrderRequest({
    this.isArchive,
    this.statusId,
    this.payments,
  });

  PutOrderRequest.fromJson(Map<String, dynamic> json) {
    isArchive = json['is_archive'];
    statusId = json['status'];
    if (json['payments'] != null) {
      payments = <PaymentTypeModel>[];
      json['payments'].forEach((v) {
        payments!.add(new PaymentTypeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_archive'] = this.isArchive;
    data['status'] = this.statusId;
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
