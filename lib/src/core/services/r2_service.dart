import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minio/minio.dart';

final r2ServiceProvider = Provider((ref) {
  return R2Service();
});

class R2Service {
  late Minio _minioClient;
  final String _publicUrl = dotenv.env['CLOUDFLARE_R2_PUBLIC_URL'] ?? '';

  R2Service() {
    _minioClient = Minio(
      endPoint: '${dotenv.env['CLOUDFLARE_R2_ACCOUNT_ID']}.r2.cloudflarestorage.com',
      accessKey: dotenv.env['CLOUDFLARE_R2_ACCESS_KEY']!,
      secretKey: dotenv.env['CLOUDFLARE_R2_SECRET_KEY']!,
      region: 'auto',
    );
  }

  Future<String> uploadFile(File file, String fileName) async {
    try {
      await _minioClient.putObject(
        'studall',
        fileName,
        file.openRead().map((chunk) => Uint8List.fromList(chunk)),
      );
      debugPrint('File uploaded to R2 successfully');

      return getFileUrl(fileName);
    }
    catch (e) {
      debugPrint('Upload failed: $e');
      rethrow;
    }
  }

  String getFileUrl(String objectKey) {
    final url = '$_publicUrl/$objectKey';
    debugPrint('Public Download URL: $url');
    return url;
  }
}