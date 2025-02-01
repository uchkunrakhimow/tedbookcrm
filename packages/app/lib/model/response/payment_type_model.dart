class PaymentTypeModel {
  String? name;
  String? method;
  double? amount;

  PaymentTypeModel({this.name, this.method, this.amount});

  PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    method = json['method'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['method'] = this.method;
    data['amount'] = this.amount;
    return data;
  }
}
