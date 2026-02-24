import 'package:flutter/material.dart';

class MapActionButtons extends StatelessWidget {
  final bool isDrawing;
  final int pointsConnt;
  final VoidCallback onSave;
  final VoidCallback onToggleDrawing;
  final VoidCallback onTakePhoto;
  final VoidCallback onLocateMe;
  final bool isLoading;

  const MapActionButtons({
    super.key,
    required this.isDrawing,
    required this.pointsConnt,
    required this.onSave,
    required this.onToggleDrawing,
    required this.onTakePhoto,
    required this.onLocateMe,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: isLoading ? null : onLocateMe,
            backgroundColor: Colors.orangeAccent,
            child: const Icon(Icons.my_location, color: Colors.white),
            mini: true,
          ),
          const SizedBox(height: 12),
          if (isDrawing && pointsConnt >= 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: isLoading ? null : onTakePhoto,
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                    mini: true,
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: isLoading ? null : onSave,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.save, color: Colors.white),
                    mini: true,
                  ),
                ],
              ),
            ),

          FloatingActionButton(
            onPressed: onToggleDrawing,
            backgroundColor: isDrawing ? Colors.redAccent : Colors.green,
            child: Icon(
              isDrawing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
