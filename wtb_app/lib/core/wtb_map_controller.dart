import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wtb_app/core/api_service.dart';
import 'package:wtb_app/core/cloudinary_service.dart';
import 'package:wtb_app/core/image_helper.dart';
import 'package:wtb_app/models/ban_model.dart';

class WTBMapController {
  // Move your state variables here
  List<LatLng> points = [];
  bool isDrawing = false;
  XFile? capturedImage;
  List<Ban> savedVillages = [];
  bool isLoading = false;
  int? editingBanId;
  String? existingLandmarkUrl;
  LatLng? userLocation;

  // Dependency injection (Services)
  final ApiService _apiService = ApiService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final ImageHelper _imageHelper = ImageHelper();
  final VoidCallback onUpdate;
  final MapController flutterMapController = MapController();

  Future<Map<String, dynamic>> locateUser() async {
    isLoading = true;
    onUpdate();

    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      isLoading = false;
      onUpdate();
      return {
        'error':
            'Location services are disabled. Please enable them in settings.',
      };
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading = false;
        onUpdate();
        return {
          'error':
              'Location permission denied. Please grant permission to access location.',
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading = false;
      onUpdate();
      return {
        'error':
            'Location permission permanently denied. Please enable it in app settings.',
      };
    }

    Position position = await Geolocator.getCurrentPosition();
    userLocation = LatLng(position.latitude, position.longitude);
    flutterMapController.move(userLocation!, 15.0);
    isLoading = false;
    onUpdate();
    return {'success': true, 'message': 'Location found!'};
  }

  WTBMapController({required this.onUpdate});

  Future<void> loadSavedVillages() async {
    final villages = await _apiService.fetchBans();
    savedVillages = villages;
    onUpdate();
  }

  void handleMapTap(LatLng point) {
    if (!isDrawing) return;

    if (points.contains(point)) {
      points.remove(point);
    } else {
      points.add(point);
    }
    onUpdate();
  }

  void undoLastPoint() {
    if (points.isNotEmpty) {
      points.removeLast();
      onUpdate();
    }
  }

  void toggleDrawing() {
    if (isDrawing) {
      points.clear();
      existingLandmarkUrl = null;
      capturedImage = null;
      editingBanId = null;
    }
    isDrawing = !isDrawing;
    capturedImage = null;
    existingLandmarkUrl = null;
    isLoading = false;
    onUpdate();
  }

  Future<String?> takePhoto() async {
    try {
      final XFile? file = await _imageHelper.pickAndCompressImage();
      if (file != null) {
        capturedImage = file;
        onUpdate();
        return "Photo captured successfully!";
      }
      return null;
    } catch (e) {
      return "Failed to take photo: $e";
    }
  }

  Future<Map<String, dynamic>> savePolygon({
    required String name,
    required String district,
  }) async {
    if (points.isEmpty) {
      return {'error': 'Please draw a polygon first.'};
    }
    isLoading = true;
    onUpdate();
    String finalImageUrl = existingLandmarkUrl ?? "";

    if (capturedImage != null) {
      final uploadUrl = await _cloudinaryService.uploadImage(capturedImage!);
      if (uploadUrl != null) {
        finalImageUrl = uploadUrl;
      } else {
        return {'error': 'Upload failed.'};
      }
    }
    try {
      Ban BanData = Ban(
        id: editingBanId,
        name: name,
        district: district,
        coordinates: List.from(points),
        landmarkURL: finalImageUrl,
      );

      bool success;
      if (editingBanId != null) {
        success = await _apiService.updateBan(BanData);
      } else {
        if (finalImageUrl.isEmpty && finalImageUrl.length < 2) {
          isLoading = false;
          onUpdate();
          return {'error': 'Plase capture a photo before save'};
        }
      }
      success = await _apiService.saveBan(BanData);

      isLoading = false;
      if (success) {
        points.clear();
        capturedImage = null;
        isDrawing = false;
        existingLandmarkUrl = null;
        editingBanId = null;
        await loadSavedVillages();
        return {'success': true, 'message': 'Village saved successfully!'};
      } else {
        return {'error': 'Failed to save to backend.'};
      }
    } catch (e) {
      isLoading = false;
      onUpdate();
      return {'error': 'Failed to save polygon: $e'};
    }
  }

  Future<void> celebrateConquest(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.yellow, size: 80),
            const Text(
              "Village Conquered!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              "+100 Xp",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                "Keep Exploring",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //clear image
  void clearCaputureImage() {
    capturedImage = null;
    existingLandmarkUrl = null;
    capturedImage = null;
    onUpdate();
  }

  void startEditing(Ban ban) {
    editingBanId = ban.id;
    points = List.from(ban.coordinates);
    existingLandmarkUrl = ban.landmarkURL;
    isDrawing = true;
    onUpdate();
  }

  Future<bool> removeVillage(int id) async {
    isLoading = true;
    onUpdate();

    final success = await _apiService.deleteBan(id);
    if (success) {
      if (editingBanId == id) {
        editingBanId = null;
        points.clear();
        existingLandmarkUrl = null;
        capturedImage = null;
        isDrawing = false;
      }
      await loadSavedVillages();
    }
    isLoading = false;
    onUpdate();
    return success;
  }
}
