class Distance {
  double distance;

  Distance(double distance) {
    this.distance = distance;
  }

  Distance.fromJson(Map<String, dynamic> json) : distance = json['distance'];

  Map<String, dynamic> toJson() => {
        '"distance"': '"' + distance.toString() + '"',
      };
}
