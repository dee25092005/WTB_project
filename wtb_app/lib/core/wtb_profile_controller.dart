//wtb_map_controller.dart

import 'package:flutter/material.dart';
import 'package:wtb_app/core/api_service.dart';
import 'package:wtb_app/models/ban_model.dart';

class WtbProfileController {
  final ApiService _apiService = ApiService();

  bool isLoading = true;
  bool isGalleryloading = true;
  Map<String, dynamic>? stats;
  List<Ban> conqueredVillages = [];
  String? errorMessage;

  Future<void> loadingProfileData(VoidCallback onUpdate) async {
    isLoading = true;
    onUpdate();
    stats = await _apiService.fetchUserStats();
    isLoading = false;
    onUpdate();
  }

  Future<void> loadingGallery(VoidCallback onUpdate) async {
    isGalleryloading = true;
    onUpdate();
    conqueredVillages = await _apiService.fetchBans();
    isGalleryloading = false;
    onUpdate();
  }

  Future<void> refreshAll(VoidCallback onUpdate) async {
    await Future.wait([loadingProfileData(onUpdate), loadingGallery(onUpdate)]);
  }

  String calculateRank(int xp) {
    if (xp >= 10000) return "Legendary";
    if (xp >= 5000) return "Epic";
    if (xp >= 2000) return "Conqueror";
    if (xp >= 1000) return "Legend";
    return "Novice";
  }

  void addXpAndCheckRank(int amount, BuildContext context) {
    int oldXp = stats?['total_xp'] ?? 0;
    String oldRank = calculateRank(oldXp);
    int newXp = oldXp + amount;
    String newRank = calculateRank(newXp);

    stats?['total_xp'] = newXp;

    if (newRank != oldRank) {
      stats?['rank'] = newRank;
      _showRankUpDailog(context, newRank);
    }
  }

  void _showRankUpDailog(BuildContext context, String newRank) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.orangeAccent,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.yellow, size: 80),
            const SizedBox(height: 16),
            const Text(
              "RANK UP!!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You are now a ${newRank}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "AWESOME",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
