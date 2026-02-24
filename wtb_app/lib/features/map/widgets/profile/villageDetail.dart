//VIllage Detail

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wtb_app/models/ban_model.dart';

class Villagedetail extends StatelessWidget {
  final Ban ban;
  const Villagedetail({super.key, required this.ban});

  Future<void> _openInGoogleMaps(String coordinates) async {
    final RegExp regExp = RegExp(
      r"([-+]?\d*\.\d+)\s*,\s*longitude:\s*([-+]?\d*\.\d+)",
    );
    final match = regExp.firstMatch(coordinates);
    String lat = "";
    String lng = "";
    if (match != null) {
      lat = match.group(1) ?? "";
      lng = match.group(2) ?? "";
    } else {
      debugPrint("Could not parse coordinates: $coordinates");
      throw 'Could not parse coordinates: $coordinates';
    }
    final String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    final Uri uri = Uri.parse(googleMapUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      debugPrint("Launching $googleMapUrl");
    } else {
      debugPrint("Could not launch $googleMapUrl");
      throw 'Could not launch $googleMapUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ban.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String rawCoords = ban.coordinates.toString();
          _openInGoogleMaps(rawCoords.trim());
        },
        backgroundColor: Colors.orangeAccent,
        icon: const Icon(Icons.location_on, color: Colors.white),
        label: const Text(
          "Open in Maps",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'hero-${ban.id}',
              child: Image.network(
                ban.landmarkURL,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ban.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                    ),
                    title: const Text("District"),
                    subtitle: Text(ban.district),
                  ),
                  Divider(),
                  ListTile(
                    leading: const Icon(Icons.map, color: Colors.blueAccent),
                    title: const Text("Coordinates"),
                    subtitle: Text((ban.coordinates).toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
