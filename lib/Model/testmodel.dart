// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' show cos, sqrt, asin;
class Pos {
  double lat;
  double lon;
  double? distanceFromCurrent;
  Pos({
    required this.lat,
    required this.lon,
    this.distanceFromCurrent,
  });
  factory Pos.fromJson(Map<String, dynamic> json) {
    return Pos(
        lat: json["lat"],
        lon: json['lon'],
        );
  }
  double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}
void setDistanceFromCurrent(double latCurrent, double lonCurrent) {
    distanceFromCurrent = calculateDistance(lat, lon, latCurrent, lonCurrent);
  }
}
