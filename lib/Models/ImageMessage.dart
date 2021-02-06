class ImageMessage {
  String base64;
  String name;
  List<String> usersInvolved;

  ImageMessage(this.base64, this.name, this.usersInvolved);

  // ImageMessage.fromJson(Map<String, dynamic> json)
  //     : base64 = json['base64'],
  //       name = json['name'],
  //       usersInvolved = json['usersInvolved'];

  factory ImageMessage.fromJson(Map<String, dynamic> parsedJson) {
    var usersInvolved = parsedJson['usersInvolved'];
    List<String> usersList = new List<String>.from(usersInvolved);
    return ImageMessage(parsedJson['base64'], parsedJson['name'], usersList);
  }

  Map<String, dynamic> toJson() => {
        'base64': base64,
        'name': name,
        'usersInvolved': usersInvolved,
      };
}
