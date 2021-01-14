class StringPair {
  String userOne;
  String userTwo;

  StringPair.fromJson(Map<String, dynamic> json)
      : userOne = json['userOne'],
        userTwo = json['userTwo'];

  Map<String, dynamic> toJson() => {
        'userOne': userOne,
        'userTwo': userTwo,
      };

  StringPair(String userOne, String userTwo) {
    this.userOne = userOne;
    this.userTwo = userTwo;
  }
}
