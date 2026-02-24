//making profile page

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wtb_app/core/wtb_ach_controller.dart';
import 'package:wtb_app/core/wtb_profile_controller.dart';
import 'package:wtb_app/features/map/widgets/profile/bildStatGrid.dart';
import 'package:wtb_app/features/map/widgets/profile/buildHeader.dart';
import 'package:wtb_app/features/map/widgets/profile/buildXpCard.dart';
import 'package:wtb_app/features/map/widgets/profile/village_gallery.dart';
import 'package:wtb_app/models/ban_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late WtbProfileController profileController;
  late WtbAchController achController;

  @override
  void initState() {
    super.initState();

    profileController = WtbProfileController();
    achController = WtbAchController(profileController);

    profileController.loadingProfileData(() => setState(() {}));
    profileController.loadingGallery(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    if (profileController.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orangeAccent),
        ),
      );
    }

    final stats = profileController.stats;
    final int totalXp = stats?['total_xp'] ?? 0;
    final String rank = stats?['rank'] ?? "Novice";

    final int unlockedAchievements = achController.getUnlockedCount();

    // final int level = stats?['level'] ?? 1;
    final int villageConquered = stats?['villages_connt'] ?? 0;

    double progress = (totalXp % 1000) / 1000.0;
    int xpForNextLevel = 1000 - (totalXp % 1000);

    if (progress == 0 && totalXp > 0) progress = 1.0;
    buildStatGrid(villageConquered, unlockedAchievements);

    return Scaffold(
      body: RefreshIndicator(
        color: Colors.deepOrangeAccent,
        onRefresh: () async {
          await profileController.refreshAll(() => setState(() {}));
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildHeader("dee", rank),
              const SizedBox(height: 20),
              buildXpCard(totalXp, progress, xpForNextLevel),
              const SizedBox(height: 20),
              buildStatGrid(villageConquered, unlockedAchievements),
              const SizedBox(height: 20),
              profileController.isGalleryloading
                  ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : buildVillageGallery(profileController.conqueredVillages),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
