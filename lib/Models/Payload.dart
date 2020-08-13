class Payload {
  String message;
  int testingNumber;

  Payload(String message) {
    this.message = message;
  }

  Payload.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        testingNumber = json['testingNumber'];

  Map<String, dynamic> toJson() => {
        'message': message,
        'testingNumber': testingNumber,
      };
}
