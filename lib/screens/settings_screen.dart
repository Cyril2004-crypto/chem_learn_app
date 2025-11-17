import 'package:flutter/material.dart';
import '../repositories/api_key_manager.dart';
import '../services/secure_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();
  late final ApiKeyManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = ApiKeyManager(SecureStorageService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Chemistry API Key')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await _manager.saveChemistryKey(_controller.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key saved')));
              },
              child: const Text('Save API Key'),
            )
          ],
        ),
      ),
    );
  }
}