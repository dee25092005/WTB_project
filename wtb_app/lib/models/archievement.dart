import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final int requirement;
  final String type;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.requirement,
    required this.type,
  });

  // Static list of achievements
}
