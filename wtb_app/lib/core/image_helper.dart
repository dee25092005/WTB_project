import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickAndCompressImage() async {
    //get image from camera
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxHeight: 600,
      maxWidth: 800,
    );
    //save image to temp directory and compress it
    // final dir = await path_provider.getTemporaryDirectory();
    // final targetPath = "${dir.absolute.path}/temp_lanmark.jpg";

    // var result = await FlutterImageCompress.compressAndGetFile(
    //   photo.path,
    //   targetPath,
    //   quality: 70,
    //   minHeight: 600,
    //   minWidth: 800,
    // );

    // return result != null ? File(result.path) : null;

    return photo;
  }
}
