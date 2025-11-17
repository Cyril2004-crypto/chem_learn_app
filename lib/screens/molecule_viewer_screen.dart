import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../providers/api_provider.dart';

class MoleculeViewerScreen extends StatefulWidget {
  const MoleculeViewerScreen({super.key});
  @override
  State<MoleculeViewerScreen> createState() => _MoleculeViewerScreenState();
}

class _MoleculeViewerScreenState extends State<MoleculeViewerScreen> {
  final _controller = TextEditingController(text: 'water');
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final api = context.read<ApiProvider>();
      final info = await api.fetchCompound(name);
      setState(() => _result = info);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openPubChem3D(int cid) async {
    final url = 'https://pubchem.ncbi.nlm.nih.gov/compound/$cid';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, webOnlyWindowName: '_blank');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open URL')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Molecule Viewer')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Compound name or identifier'),
                  onSubmitted: (_) => _search(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _loading ? null : _search, child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Lookup')),
            ]),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null) ...[
              ListTile(title: const Text('Name'), subtitle: Text(_result!['query']?.toString() ?? '')),
              ListTile(title: const Text('SMILES'), subtitle: Text(_result!['canonical_smiles']?.toString() ?? 'N/A')),
              ListTile(title: const Text('Formula'), subtitle: Text(_result!['molecular_formula']?.toString() ?? 'N/A')),
              ListTile(title: const Text('Molecular weight'), subtitle: Text(_result!['molecular_weight']?.toString() ?? 'N/A')),
              ListTile(title: const Text('Synonyms (first 5)'), subtitle: Text(((_result!['synonyms'] as List<dynamic>?)?.take(5).join(', ')) ?? '')),
              const SizedBox(height: 8),
              if (_result!['cid'] != null)
                ElevatedButton(
                  onPressed: () => _openPubChem3D(_result!['cid'] as int),
                  child: const Text('Open PubChem page / 3D viewer'),
                ),
            ] else
              const Expanded(child: Center(child: Text('No compound loaded'))),
          ],
        ),
      ),
    );
  }
}