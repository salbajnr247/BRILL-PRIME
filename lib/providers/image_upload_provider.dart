import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadProvider extends ChangeNotifier {
  String resMessage = "";

  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final supabase = Supabase.instance.client;
      final fileName =
          'uploads/$userId-${DateTime.now().millisecondsSinceEpoch}.png';

      await supabase.storage.from('brillprime').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      final imageUrl =
          supabase.storage.from('your-bucket-name').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      resMessage = "Error uploading image: $e";
      debugPrint('Upload error: $e');
      return null;
    }
  }

  void clear() {
    resMessage = "";
    notifyListeners();
  }
}
