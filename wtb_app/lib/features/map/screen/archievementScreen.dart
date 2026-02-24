import 'package:flutter/material.dart';
import 'package:wtb_app/core/wtb_ach_controller.dart';
import 'package:wtb_app/core/wtb_profile_controller.dart';
import 'package:wtb_app/models/archievement.dart';

class Archievementscreen extends StatelessWidget {
  final WtbAchController controllerAch;
  const Archievementscreen({super.key, required this.controllerAch});

  @override
  Widget build(BuildContext context) {
    final int currentVillages = controllerAch.getCurrentVillages();
    final int currentXp = controllerAch.getCurrentXp();
    final List<Achievement> achievementList = controllerAch.getAchievements();

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Scaffold(
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            crossAxisCount: 3,
          ),
          itemCount: achievementList.length,
          itemBuilder: (context, index) {
            final ach = controllerAch.achievementList[index];

            bool isUnlocekd = ach.type == 'villages'
                ? currentVillages >= ach.requirement
                : currentXp >= ach.requirement;

            return Card(
              elevation: isUnlocekd ? 4 : 0,
              color: isUnlocekd ? Colors.white : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ach.icon,
                    size: 50,
                    color: isUnlocekd ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    ach.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUnlocekd ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    isUnlocekd ? "Unlocked!" : ach.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUnlocekd ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
