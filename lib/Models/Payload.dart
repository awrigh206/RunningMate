class Payload {
  String message;
  int testingNumber;

  Payload(String message) {
    this.message = message;
    this.testingNumber = 1;
  }

  Payload.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        testingNumber = json['testingNumber'];

  Map<String, dynamic> toJson() => {
        'message': message,
        'testingNumber': testingNumber,
      };
}
