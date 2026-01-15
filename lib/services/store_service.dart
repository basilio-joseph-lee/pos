import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/store_model.dart';
import '../config/api.dart';
import 'package:http/http.dart' as http;

class StoreService {
  Future<List<Store>> fetchStores() async {
    final res = await http.get(Uri.parse(ApiConfig.fetchStore));
    final data = jsonDecode(res.body) as List;
    return data.map((json) => Store.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> insertStore(Store store) async {
    final res = await http.post(
      Uri.parse(ApiConfig.insertStore),
      body: store.toJson(),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateStore(Store store) async {
    final res = await http.post(
      Uri.parse(ApiConfig.updateStore),
      body: store.toJson(),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> deleteStore(String id) async {
    final res = await http.post(
      Uri.parse(ApiConfig.deleteStore),
      body: {'storeID': id},
    );
    return jsonDecode(res.body);
  }
}
