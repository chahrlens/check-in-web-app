import 'package:encrypt/encrypt.dart' as encrypt;
const String _key = 'F09lOJDcdxgjlZottb7ep7HpAPiHdNR2';
const String _iv = '4I3bjg0vxMAQgzW1';

String obfuscateValue(String value) {
  final key = encrypt.Key.fromUtf8(_key);
  final iv = encrypt.IV.fromUtf8(_iv);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  final encrypted = encrypter.encrypt(value, iv: iv);
  return encrypted.base64;
}

String decObfuscateValue(String value) {
  final key = encrypt.Key.fromUtf8(_key);
  final iv = encrypt.IV.fromUtf8(_iv);
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  final decrypted = encrypter.decrypt64(value, iv: iv);
  return decrypted;
}