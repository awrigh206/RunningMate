class Pair {
  String issuingUser;
  String challengedUser;

  Pair(String issuingUser, String challengedUser) {
    this.issuingUser = issuingUser;
    this.challengedUser = challengedUser;
  }

  Pair.fromJson(Map<String, dynamic> json)
      : issuingUser = json['issuingUser'],
        challengedUser = json['challengedUser'];

  Map<String, dynamic> toJson() => {
        'issuingUser': issuingUser,
        'challengedUser': challengedUser,
      };
}
