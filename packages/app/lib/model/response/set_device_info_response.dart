class SetDeviceInfoResponse {
  bool? success;
  int? code;
  String? message;
  String? data;

  SetDeviceInfoResponse({this.success, this.code, this.message, this.data});

  SetDeviceInfoResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}
