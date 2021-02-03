import 'Pair.dart';

class ImageMessage {
  String base64;
  String name;
  Pair pair;

  ImageMessage(this.base64, this.name, this.pair);

  ImageMessage.fromJson(Map<String, dynamic> json)
      : base64 = json['base64'],
        name = json['name'],
        pair = json['pair'];

  Map<String, dynamic> toJson() => {
        'base64': base64,
        'name': name,
        'pair': pair.toJson(),
      };
}
