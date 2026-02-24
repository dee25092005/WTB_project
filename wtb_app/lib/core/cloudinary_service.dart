import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class CloudinaryService {
  final String _cloudName = dotenv.get("CLOUDINARY_CLOUD_NAME");
  final String _uploadPreset = dotenv.get("CLOUDINARY_UPLOAD_PRESET");

  Future<String?> uploadImage(XFile imageFile) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    try {
      final imageBytes = await imageFile.readAsBytes();

      debugPrint('Image bytes length: ${imageBytes.length}');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['unsigned'] = 'true';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['secure_url'];
      } else {
        debugPrint("Failed to upload image: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
