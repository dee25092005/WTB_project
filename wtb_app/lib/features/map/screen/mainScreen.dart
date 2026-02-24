import 'package:flutter/material.dart';
import 'package:wtb_app/core/wtb_ach_controller.dart';
import 'package:wtb_app/core/wtb_map_controller.dart';
import 'package:wtb_app/core/wtb_profile_controller.dart';
import 'package:wtb_app/features/map/screen/archievementScreen.dart';
import 'package:wtb_app/features/map/screen/profile_screen.dart';
import 'package:wtb_app/features/map/widgets/ban_input.dart';
import 'package:wtb_app/features/map/widgets/image_prview.dart';
import 'package:wtb_app/features/map/widgets/loading_overlay.dart';
import 'package:wtb_app/features/map/widgets/map_action_button.dart';
import 'package:wtb_app/features/map/widgets/map_view.dart';
import 'package:wtb_app/models/ban_model.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0;
  late WtbProfileController _profileController;
  late WtbAchController _achController;
  late WTBMapController _mapController;
  @override
  void initState() {
    super.initState();
    _mapController = WTBMapController(onUpdate: () => setState(() {}));
    _mapController.loadSavedVillages();

    _profileController = WtbProfileController();
    _achController = WtbAchController(_profileController);
    _profileController.loadingProfileData(() => setState(() {}));
  }

  void _handlerLocateMe() async {
    final result = await _mapController.locateUser();
    _showFeedback(result);
  }

  void _removeBan(int id) async {
    final success = await _mapController.removeVillage(id);

    _showFeedback(
      success
          ? {'message': 'Ban removed successfully'}
          : {'error': 'Failed to remove Ban'},
    );
  }

  void _onSavePressed() async {
    Ban? editingBan;
    if (_mapController.editingBanId != null) {
      editingBan = _mapController.savedVillages.firstWhere(
        (b) => b.id == _mapController.editingBanId,
      );
    }
    final userData = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => BanInputDialog(
        intiaName: editingBan?.name,
        intiaDistrict: editingBan?.district,
      ),
    );

    if (userData == null) return;

    final result = await _mapController.savePolygon(
      name: userData['name']!,
      district: userData['district']!,
    );

    if (result.containsKey('success')) {
      _mapController.celebrateConquest(context);
      _mapController.points.clear();
      _mapController.loadSavedVillages(); // Refresh the map with new data
    }
    _showFeedback(result);
  }

  void _showFeedback(Map<String, dynamic> result) {
    bool isError = result.containsKey('error');
    String message = isError
        ? (result['error'] ?? 'Unknown error')
        : (result['message'] ?? 'Action completed');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  List<Widget> _getScreen() {
    return [
      Stack(
        children: [
          WTBMapVIew(
            mapController: _mapController.flutterMapController,
            currentPoints: _mapController.points,
            savedPolygons: _mapController.savedVillages,
            userLocation: _mapController.userLocation,
            onMapTap: _mapController.handleMapTap,
            onEdit: _mapController.startEditing,
            onDelete: _removeBan,
          ),
          ImagePrview(controller: _mapController),
          MapActionButtons(
            onLocateMe: _handlerLocateMe,
            isLoading: _mapController.isLoading,
            onTakePhoto: _mapController.takePhoto,
            isDrawing: _mapController.isDrawing,
            pointsConnt: _mapController.points.length,
            onSave: _onSavePressed,
            onToggleDrawing: _mapController.toggleDrawing,
          ),
          LoadingOverlay(isLoading: _mapController.isLoading),
        ],
      ),
      // TAB 1: ACHIEVEMENTS
      Archievementscreen(controllerAch: _achController),

      // TAB 2: PROFILE
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //change tite for each screen
        title: Text(
          ["WTB Map", "Achievements", "Profile"][_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        elevation: 0,

        backgroundColor: Colors.orangeAccent[700],
      ),
      body: Stack(
        children: [
          _getScreen()[_selectedIndex],
          if (_mapController.isLoading) const LoadingOverlay(isLoading: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orangeAccent[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: "Achievements",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
