class FirebaseTokenRequest {
  String? userId;
  String? token;

  FirebaseTokenRequest({
    this.userId,
    this.token,
  });

  FirebaseTokenRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['token'] = token;
    return data;
  }
}
