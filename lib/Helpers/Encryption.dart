import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/asymmetric/api.dart';

class Encryption {
  Future<String> generateKey() async {
    final crypt = new PlatformStringCryptor();
    final password = "password";
    final String salt = await crypt.generateSalt();
    return await crypt.generateKeyFromPassword(password, salt);
  }

  Future<Encrypted> encrypt(String plainText) async {
    final parser = RSAKeyParser();
    Directory directory = await getTemporaryDirectory();
    //Int8List key = await getPublicKey();
    var publicKey = await getPublicKey();
    String textKey = String.fromCharCodes(publicKey).substring(2);
    RSAAsymmetricKey rsKey = parser.parse(textKey);
    //textKey = stringToBase64.decode(textKey);
    //publicKey = utf8.decode(publicKey);
    //RSAAsymmetricKey key = parser.parse(key);
    await File(directory.path + "/public.pem").writeAsString(textKey);

    //final publicKey =
    //  await parseKeyFromFile<RSAPublicKey>(directory.path + '/public.pem');

    final encrypter =
        Encrypter(RSA(publicKey: rsKey, encoding: RSAEncoding.PKCS1));
    return encrypter.encrypt(plainText);
  }

  Future<void> writeKeyToFile(Uint8List key, String path) {
    return new File(path).writeAsBytes(key);
  }

  Future<Uint8List> getPublicKey() async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    var completer = new Completer<Uint8List>();
    socket.write("key");

    socket.listen((data) {
      //Uint8List key = Int8List.fromList(data);
      Uint8List key = data;
      completer.complete(key);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
    return completer.future;
  }

  // Future<Encrypted> encrypt(String plainText) async {
  //   //plainText = pad(plainText);
  //   final key = Key.fromUtf8('passwordGoesHerePasswordGoesHere');
  //   final iv = IV.fromUtf8("passwordGoesHere").bytes;
  //   final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  //   final encrypted = encrypter.encrypt(plainText, iv: iv);
  //   return encrypted;
  // }

  // Future<String> decrypt(Encrypted encrypted) async {
  //   final key = Key.fromUtf8('passwordGoesHerePasswordGoesHere');
  //   final iv = IV.fromUtf8("passwordGoesHere");
  //   final encrypter = Encrypter(AES(key));
  //   return encrypter.decrypt(encrypted, iv: iv);
  // }

}
