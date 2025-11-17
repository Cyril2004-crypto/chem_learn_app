import 'package:flutter/material.dart';
import '../services/chemistry_api_service.dart';

class ApiProvider extends ChangeNotifier {
  final ChemistryApiService _service;
  ApiProvider(this._service);

  /// Returns parsed PubChem compound info (Map) or throws on error.
  Future<Map<String, dynamic>> fetchCompound(String name) async {
    return await _service.fetchCompoundByName(name);
  }
}