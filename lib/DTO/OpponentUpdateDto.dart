class OpponentUpdateDto {
  int id;
  double distance;
  double altitude;
  double time;

  OpponentUpdateDto.fromJson(Map<String, dynamic> json)
      : distance = json['distance'],
        altitude = json['altitude'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'altitude': altitude,
        'time': time,
      };
}
