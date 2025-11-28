import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _db = Supabase.instance.client;

  // Fetch all places
  Future<List<Map<String, dynamic>>> fetchPlaces() async {
    final res = await _db.from('places').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  // Create a new place
  Future<void> createPlace(Map<String, dynamic> place) async {
    await _db.from('places').insert(place);
  }

  // Fetch menus for a place
  Future<List<Map<String, dynamic>>> fetchMenus(int placeId) async {
    final res = await _db.from('menus').select().eq('place_id', placeId);
    return List<Map<String, dynamic>>.from(res as List);
  }

  // Add favorite
  Future<void> addFavorite(String userId, int placeId) async {
    await _db.from('favorites').insert({'user_id': userId, 'place_id': placeId});
  }

  // Upload file to storage and return public URL
  Future<String?> uploadFile(File file, String path) async {
    final bucket = 'uploads';
    try {
      // Upload file directly (SDK expects a File for many versions)
      await _db.storage.from(bucket).upload(path, file);

      // getPublicUrl returns a String in current SDKs
      final publicUrl = _db.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }
}
