import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class Encryption {
  Future<String> generateKey() async {
    final crypt = new PlatformStringCryptor();
    final password = "password";
    final String salt = await crypt.generateSalt();
    return await crypt.generateKeyFromPassword(password, salt);
  }

  Future<String> encrypt(String plainText) async {
    final key = await generateKey();
    final crypt = new PlatformStringCryptor();
    return await crypt.encrypt(plainText, key);
  }

  Future<String> decrypt(String encrypted) async {
    try {
      final crypt = new PlatformStringCryptor();
      final String decrypted =
          await crypt.decrypt(encrypted, await generateKey());
      return decrypted;
    } on MacMismatchException {
      //can't do  it,  wrong key or bad  data
      return null;
    }
  }
}
