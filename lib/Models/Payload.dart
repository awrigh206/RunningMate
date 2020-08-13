class Payload {
  Map<String, dynamic> jsonMessage;
  String operation;

  Payload(Map<String, dynamic> jsonMessage, String operation) {
    this.jsonMessage = jsonMessage;
    this.operation = operation;
  }

  Payload.fromJson(Map<String, dynamic> json)
      : jsonMessage = json['"jsonMessage"'],
        operation = json['"operation"'];

  Map<String, dynamic> toJson() => {
        '"operation"': operation,
        '"jsonMessage"': jsonMessage,
      };
}
