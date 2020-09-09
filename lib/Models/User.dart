class User {
  String userName;
  String password;
  String email;

  User(String userName, String password, String email) {
    this.userName = userName;
    this.password = password;
    this.email = email;
  }

  User.nameOnly(String userName) {
    this.userName = '"' + userName + '"';
    this.password = '""';
    this.email = '""';
  }

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        '"userName"': '"' + userName + '"',
        '"password"': '"' + password + '"',
        '"email"': '"' + email + '"',
      };
}
