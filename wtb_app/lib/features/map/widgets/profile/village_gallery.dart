import 'package:flutter/material.dart';
import 'package:wtb_app/features/map/widgets/profile/villageDetail.dart';
import 'package:wtb_app/models/ban_model.dart';

Widget buildVillageGallery(List<Ban> village) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "Gallery",

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
      ),
      Divider(),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: village.length,
        itemBuilder: (context, index) {
          final ban = village[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Villagedetail(ban: ban),
                ),
              );
            },
            child: Hero(
              tag: 'hero-${ban.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ban.landmarkURL.isNotEmpty
                    ? Image.network(ban.landmarkURL, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
              ),
            ),
          );
        },
      ),
    ],
  );
}
