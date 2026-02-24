import 'package:flutter/material.dart';

Widget buildXpCard(int totalXp, double progress, int xpForNextLevel) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Level progess",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "$totalXp XP ",
                  style: const TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder(
              curve: Curves.easeInOutCubic,
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  value: value,
                  minHeight: 12,
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              "${xpForNextLevel} XP to next level",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
