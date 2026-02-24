import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtb_app/models/ban_model.dart';

class ApiService {
  //text for web
  // String texturl = "http://localhost:8080";
  //text for android emulator
  // String texturl = "http://10.0.2.2:8080";
  static const String basUrl = "https://wtb-server.onrender.com";

  Future<bool> saveBan(Ban ban) async {
    try {
      final response = await http
          .post(
            Uri.parse("$basUrl/api/ban"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(ban.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        debugPrint(
          "Failed to save Ban: ${response.statusCode} - ${response.body}",
        );
      }
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error saving Ban: $e");
      return false;
    }
  }

  Future<List<Ban>> fetchBans() async {
    try {
      final respons = await http.get(Uri.parse("$basUrl/api/ban"));
      if (respons.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(respons.body);
        List<dynamic> data = body['data'];
        return data.map((json) => Ban.fromJson(json)).toList();
      } else {
        debugPrint(
          "Failed to fetch bans: ${respons.statusCode} - ${respons.body}",
        );
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching bans: $e");
      return [];
    }
  }

  Future<http.Response?> _safeGet(String path) async {
    try {
      return await http
          .get(Uri.parse("$basUrl$path"))
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint("Error fetching bans: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserStats() async {
    final response = await _safeGet("/user/stats");
    if (response?.statusCode != 200) return null;

    final Map<String, dynamic> body = jsonDecode(response!.body);
    return body['data'];
  }

  Future<bool> updateBan(Ban ban) async {
    if (ban.id == null) {
      debugPrint("Cannot update Ban without ID");
      return false;
    }
    try {
      final response = await http.put(
        Uri.parse("$basUrl/api/ban/${ban.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ban.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updating Ban: $e");
      return false;
    }
  }

  Future<bool> deleteBan(int id) async {
    try {
      final resposne = await http.delete(Uri.parse("$basUrl/api/ban/$id"));
      return resposne.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleting Ban: $e");
      return false;
    }
  }
}
