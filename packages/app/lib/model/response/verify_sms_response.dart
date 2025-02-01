class VerifySMSResponse {
  bool? success;
  int? code;
  String? message;
  TokenData? data;

  VerifySMSResponse({this.success, this.code, this.message, this.data});

  VerifySMSResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? TokenData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TokenData {
  String? accessToken;
  int? accessTokenExpiry;
  String? refreshToken;
  int? refreshTokenExpiry;

  TokenData(
      {this.accessToken,
        this.accessTokenExpiry,
        this.refreshToken,
        this.refreshTokenExpiry});

  TokenData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExpiry = json['accessTokenExpiry'];
    refreshToken = json['refreshToken'];
    refreshTokenExpiry = json['refreshTokenExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['accessTokenExpiry'] = accessTokenExpiry;
    data['refreshToken'] = refreshToken;
    data['refreshTokenExpiry'] = refreshTokenExpiry;
    return data;
  }
}
