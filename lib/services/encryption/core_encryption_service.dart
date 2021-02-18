import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as enc;

class CoreEncryptionService {
  CoreEncryptionService._();

  /* the input image data is processed in chunks divided by _oneTimeProcessingLength length per block */
  static const int _oneTimeProcessingLength = 25000;

  static Future<void> _delay() => Future.delayed(
        const Duration(microseconds: 1),
      );

  /* Encrypt takes a UInt8list bytes, and returns an encrypted string */
  static Future<String> encrypt(
    Uint8List bytes,
    String keyString,
    String ivString, {
    void onPercentageDone(double done),
  }) async {
    final key = enc.Key.fromUtf8(keyString);
    final iv = enc.IV.fromUtf8(ivString);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    String base64String = base64Encode(bytes);
    StringBuffer encryptedStringBuffer = StringBuffer();

    int totalPart = base64String.length ~/ _oneTimeProcessingLength;
    int currentPart = 0;

    int i = 0;
    while (i < base64String.length) {
      int end = min(base64String.length - 1, i + _oneTimeProcessingLength);

      String tmp = base64String.substring(i, end + 1);
      String encryptedChunk = encrypter.encrypt(tmp, iv: iv).base64;

      encryptedStringBuffer.write(encryptedChunk.trim());
      encryptedStringBuffer.write(' ');

      /* notify progress */
      onPercentageDone?.call(
        totalPart == 0 ? 1.0 : currentPart.toDouble() / totalPart,
      );

      await _delay();
      i = end + 1;
      currentPart += 1;
    }

    return encryptedStringBuffer.toString().trim();
  }

  /* decrypt takes in a string and outputs a UInt8List bytes */
  static Future<Uint8List> decrypt(
    String encryptedData,
    String keyString,
    String ivString,
  ) async {
    final key = enc.Key.fromUtf8(keyString);
    final iv = enc.IV.fromUtf8(ivString);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    List<String> tmp = encryptedData.trim().split(' ');

    StringBuffer decryptedStringBuffer = StringBuffer();

    for (String t in tmp) {
      /* decryptedChunk is in base64 */
      String decryptedChunk = encrypter.decrypt64(t, iv: iv);
      decryptedStringBuffer.write(decryptedChunk);
      await _delay();
    }

    Uint8List outputBytes = base64Decode(decryptedStringBuffer.toString());
    return outputBytes;
  }
}
