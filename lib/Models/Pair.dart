class Pair {
  List<String> involvedUsers;

  Pair(List<String> involvedUsers) {
    this.involvedUsers = involvedUsers;
  }

  @override
  String toString() {
    return "users: " + involvedUsers.toString();
  }

  Pair.fromJson(Map<String, dynamic> json)
      : involvedUsers = json['involvedUsers'];

  Map<String, dynamic> toJson() => {
        'involvedUsers': involvedUsers,
      };
}
