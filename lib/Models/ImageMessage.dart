class ImageMessage {
  String base64;
  String name;
  String sender;
  String recepient;

  ImageMessage(this.base64, this.name, this.sender, this.recepient);

  ImageMessage.fromJson(Map<String, dynamic> json)
      : base64 = json['base64'],
        name = json['name'],
        sender = json['sender'],
        recepient = json['recepient'];

  Map<String, dynamic> toJson() => {
        'base64': base64,
        'name': name,
        'sender': sender,
        'recepient': recepient
      };
}
