//ach controller

import 'package:flutter/material.dart';
import 'package:wtb_app/core/wtb_profile_controller.dart';
import 'package:wtb_app/models/archievement.dart';

class WtbAchController {
  final WtbProfileController _profileController;
  WtbAchController(this._profileController);

  final List<Achievement> achievementList = [
    Achievement(
      title: "First Steps",
      description: "Conquer 1 village",
      icon: Icons.home,
      requirement: 1,
      type: 'villages',
    ),
    Achievement(
      title: "Apprentice",
      description: "Conquer 5 villages",
      icon: Icons.explore,
      requirement: 5,
      type: 'villages',
    ),
    Achievement(
      title: "Village Leader",
      description: "Conquer 10 villages",
      icon: Icons.gite,
      requirement: 10,
      type: 'villages',
    ),
    Achievement(
      title: "XP Hunter",
      description: "Reach 1000 XP",
      icon: Icons.military_tech,
      requirement: 1000,
      type: 'xp',
    ),
    Achievement(
      title: "Seasoned Conqueror",
      description: "Conquer 20 villages",
      icon: Icons.castle,
      requirement: 20,
      type: 'villages',
    ),
    Achievement(
      title: "XP Master",
      description: "Reach 5000 XP",
      icon: Icons.star,
      requirement: 5000,
      type: 'xp',
    ),
    Achievement(
      title: "Legendary Conqueror",
      description: "Conquer 50 villages",
      icon: Icons.emoji_events,
      requirement: 50,
      type: 'villages',
    ),
    Achievement(
      title: "XP Legend",
      description: "Reach 10000 XP",
      icon: Icons.verified,
      requirement: 10000,
      type: 'xp',
    ),
  ];

  int getCurrentVillages() {
    return _profileController.stats?['villages_connt'] ?? 0;
  }

  int getCurrentXp() {
    return _profileController.stats?['total_xp'] ?? 0;
  }

  List<Achievement> getAchievements() {
    return achievementList;
  }

  int getUnlockedCount() {
    int currentVillages = getCurrentVillages();
    int currentXp = getCurrentXp();

    return achievementList.where((ach) {
      if (ach.type == 'villages') {
        return currentVillages >= ach.requirement;
      } else {
        return currentXp >= ach.requirement;
      }
    }).length;
  }
}
