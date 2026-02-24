import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wtb_app/core/wtb_map_controller.dart';

class ImagePrview extends StatelessWidget {
  final WTBMapController controller;

  const ImagePrview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasCaptured = controller.capturedImage != null;
    final hasExisting =
        controller.existingLandmarkUrl != null &&
        controller.existingLandmarkUrl!.isNotEmpty;

    // If there is no image, don't render anything
    if (!hasCaptured && !hasExisting) return const SizedBox.shrink();

    ImageProvider imageProvider;

    if (hasCaptured) {
      imageProvider = kIsWeb
          ? NetworkImage(controller.capturedImage!.path)
          : FileImage(File(controller.capturedImage!.path)) as ImageProvider;
    } else {
      imageProvider = NetworkImage(controller.existingLandmarkUrl!);
    }

    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        children: [
          // The Image Thumbnail
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasCaptured ? Colors.white : Colors.orangeAccent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(blurRadius: 5, color: Colors.black26),
              ],
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          // The Clear Button
          SizedBox(
            height: 30,
            width: 30,
            child: FloatingActionButton(
              heroTag:
                  'clear_image_btn', // Important for multiple FABs on one screen
              onPressed: controller.clearCaputureImage,
              backgroundColor: Colors.redAccent,
              mini: true,
              child: const Icon(Icons.clear, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
