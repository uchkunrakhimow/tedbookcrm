class GeneralUserDataResponse {
  GeneralUserDataResponse({
    this.responseCode,
    this.nextStep,
    this.code,
    this.success,
    this.message,
    this.generalUserData,
  });

  int? responseCode;
  String? nextStep;
  int? code;
  bool? success;
  String? message;
  GeneralUserData? generalUserData;

  GeneralUserDataResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    nextStep = json['nextStep'];
    code = json['code'];
    success = json['success'];
    message = json['message'];
    generalUserData =
        json['data'] == null ? null : GeneralUserData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['responseCode'] = responseCode;
    data['nextStep'] = nextStep;
    data['code'] = code;
    data['success'] = success;
    data['message'] = message;
    data['data'] = generalUserData?.toJson();
    return data;
  }
}

class GeneralUserData {
  GeneralUserData({
    this.id,
    this.nickName,
    this.phone,
    this.fio,
    this.pinfl,
    this.genderCode,
    this.genderName,
    this.lang,
    this.roles,
  });

  int? id;
  String? nickName;
  String? phone;
  String? fio;
  String? pinfl;
  int? genderCode;
  String? genderName;
  String? lang;
  List<Roles>? roles;

  GeneralUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickName = null;
    phone = json['phone'];
    fio = null;
    pinfl = null;
    genderCode = null;
    genderName = null;
    lang = null;
    roles = json['roles'] == null
        ? null
        : List.from(json['roles']).map((e) => Roles.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nickName'] = nickName;
    data['phone'] = phone;
    data['fio'] = fio;
    data['pinfl'] = pinfl;
    data['genderCode'] = genderCode;
    data['genderName'] = genderName;
    data['lang'] = lang;
    data['roles'] = roles?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Roles {
  Roles({
    this.code,
    this.name,
  });

  int? code;
  String? name;

  Roles.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}
