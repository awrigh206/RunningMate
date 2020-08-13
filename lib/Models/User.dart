class User {
  String userName;
  String password;
  String email;

  User(String userName, String password) {
    this.userName = userName;
    this.password = password;
  }

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'password': password,
      };
}
