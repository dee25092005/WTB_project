import 'package:flutter/material.dart';

Widget buildHeader(String name, String rank) {
  return Container(
    padding: const EdgeInsets.only(top: 60, bottom: 20),
    width: double.infinity,
    height: 300,

    //show black transparent background with real image
    decoration: const BoxDecoration(
      color: Colors.black87,
      image: DecorationImage(
        image: AssetImage("assets/wallpaper.png"),
        fit: BoxFit.cover,
        opacity: 0.5,
      ),
    ),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.orange,
          //useing image from asset
          child: ClipOval(
            child: Image(
              image: AssetImage("assets/dee4.png"),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
        Text(
          "$rank",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
