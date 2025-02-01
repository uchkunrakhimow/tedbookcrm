class ShortUserInfoByPinflResponse {
  ShortUserInfoByPinflResponse({
    this.responseCode,
    this.nextStep,
    this.code,
    this.success,
    this.message,
    this.data,
  });

  int? responseCode;
  String? nextStep;
  int? code;
  bool? success;
  String? message;
  Data? data;

  ShortUserInfoByPinflResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    nextStep = json['nextStep'];
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] == null ? null : Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['responseCode'] = responseCode;
    _data['nextStep'] = nextStep;
    _data['code'] = code;
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    this.fullName,
  });

  String? fullName;

  Data.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    return _data;
  }
}
