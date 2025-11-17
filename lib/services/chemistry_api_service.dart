import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple PubChem client using PUG-REST (no API key required).
class ChemistryApiService {
  static const _base = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug';
  static const _timeoutSeconds = 15;

  /// Fetch compound info by name (or common identifier). Returns a map:
  /// {
  ///   'query': '<name>',
  ///   'cid': int?,
  ///   'canonical_smiles': String?,
  ///   'molecular_formula': String?,
  ///   'molecular_weight': double?,
  ///   'synonyms': List<String>
  /// }
  Future<Map<String, dynamic>> fetchCompoundByName(String name) async {
    final q = Uri.encodeComponent(name.trim());
    // Try properties endpoint which will return canonical SMILES, formula, weight
    final propUrl = '$_base/compound/name/$q/property/CanonicalSMILES,MolecularFormula,MolecularWeight/JSON';
    final synUrl = '$_base/compound/name/$q/synonyms/JSON';

    try {
      final propResp = await http.get(Uri.parse(propUrl)).timeout(Duration(seconds: _timeoutSeconds));
      if (propResp.statusCode != 200) {
        throw Exception('PubChem property query failed: ${propResp.statusCode}');
      }
      final propJson = jsonDecode(propResp.body) as Map<String, dynamic>;
      final propsList = (propJson['PropertyTable']?['Properties']) as List<dynamic>?;

      int? cid;
      String? smiles;
      String? formula;
      double? weight;

      if (propsList != null && propsList.isNotEmpty) {
        final p = propsList.first as Map<String, dynamic>;
        cid = p['CID'] as int?;
        smiles = p['CanonicalSMILES'] as String?;
        formula = p['MolecularFormula'] as String?;
        final mw = p['MolecularWeight'];
        if (mw != null) weight = (mw is num) ? mw.toDouble() : double.tryParse(mw.toString());
      }

      // fetch synonyms (optional)
      final synResp = await http.get(Uri.parse(synUrl)).timeout(Duration(seconds: _timeoutSeconds));
      List<String> synonyms = [];
      if (synResp.statusCode == 200) {
        final synJson = jsonDecode(synResp.body) as Map<String, dynamic>;
        final synList = synJson['InformationList']?['Information'] as List<dynamic>?;
        if (synList != null && synList.isNotEmpty) {
          final info = synList.first as Map<String, dynamic>;
          final raw = info['Synonym'] as List<dynamic>?;
          if (raw != null) synonyms = raw.map((e) => e.toString()).toList();
        }
      }

      return {
        'query': name,
        'cid': cid,
        'canonical_smiles': smiles,
        'molecular_formula': formula,
        'molecular_weight': weight,
        'synonyms': synonyms,
      };
    } catch (e) {
      rethrow;
    }
  }
}