class CoordinateModel {
  List<double>? coordinates;

  CoordinateModel({this.coordinates});

  CoordinateModel.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    return data;
  }
}
