import 'package:application/Models/Payload.dart';

///Class to send a batch of payloads to the server at the same time
class BatchPayload {
  List<Payload> payloads;

  BatchPayload(List<Payload> payloads) {
    this.payloads = payloads;
  }

  void addPayload(Payload toAdd) {
    payloads.add(toAdd);
  }

  void addMultiple(List<Payload> loads) {
    payloads.addAll(loads);
  }

  factory BatchPayload.fromJson(Map<String, dynamic> json) {
    var list = json['payloads'] as List;
    List<Payload> messageList = list.map((i) => Payload.fromJson(i)).toList();

    return new BatchPayload(messageList);
  }

  Map<String, dynamic> toJson() => {
        '"payloads"': payloads,
      };
}
