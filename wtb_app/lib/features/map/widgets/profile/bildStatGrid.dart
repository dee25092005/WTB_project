import 'package:flutter/material.dart';

Widget buildStatGrid(int villageCount, int isUnlocked) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _staItem(Icons.map, "Villages conquered", villageCount.toString()),
      _staItem(Icons.star, "Achievenments Complete", isUnlocked.toString()),
    ],
  );
}

Widget _staItem(IconData icon, String label, String value) {
  return Column(
    children: [
      Icon(icon, size: 30, color: Colors.orange),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
