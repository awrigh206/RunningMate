class Position {
  String id;
  String userName;
  double lat;
  double lon;
  double altitude;

  Position(
      String id, String userName, double lat, double lon, double altitude) {
    this.id = id;
    this.userName = userName;
    this.lat = lat;
    this.lon = lon;
    this.altitude = altitude;
  }

  Position.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        lat = json['lat'],
        lon = json['lon'],
        altitude = json['alt'];

  Map<String, dynamic> toJson() => {
        '"id"': '"' + id + '"',
        '"userName"': '"' + userName + '"',
        '"lat"': lat,
        '"lon"': lon,
        '"alt"': altitude,
      };
}
