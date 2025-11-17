import 'dart:math';

class ReactionResult {
  final List<Map<String, dynamic>> products; // {formula, coeff}
  final String explanation;

  ReactionResult({required this.products, required this.explanation});
}

class ReactionService {
  List<String> parseReactants(String input) {
    final cleaned = input.replaceAll('->', '+').replaceAll('=', '+');
    final parts = cleaned
        .split('+')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map((s) {
      // remove leading numeric coefficients like "2 O2" or "3H2"
      return s.replaceFirst(RegExp(r'^\d+\s*'), '').trim();
    }).toList();
    return parts;
  }

  Map<String, int> parseElements(String formula) {
    final regex = RegExp(r'([A-Z][a-z]?)(\d*)');
    final Map<String, int> counts = {};
    for (final m in regex.allMatches(formula)) {
      final el = m.group(1)!;
      final nStr = m.group(2);
      final n = (nStr == null || nStr.isEmpty) ? 1 : int.tryParse(nStr) ?? 1;
      counts[el] = (counts[el] ?? 0) + n;
    }
    return counts;
  }

  bool looksLikeHydrocarbon(String f) {
    final counts = parseElements(f);
    return counts.containsKey('C') && counts.keys.every((k) => k == 'C' || k == 'H');
  }

  bool isCarboxylicAcid(String s) {
    final u = s.toUpperCase();
    return u.contains('COOH') || RegExp(r'CO2H', caseSensitive: false).hasMatch(u);
  }

  bool isAlcohol(String s) {
    final u = s.toUpperCase();
    if (!u.endsWith('OH')) return false;
    // exclude simple ionic hydroxides like NaOH
    if (RegExp(r'^[A-Z]{1,2}OH$').hasMatch(u)) return false;
    if (u.contains('(') && u.contains('OH')) return false;
    return true;
  }

  bool isWater(String s) {
    final u = s.replaceAll(' ', '').toUpperCase();
    return u == 'H2O' || u == 'HOH' || u == 'WATER';
  }

  bool isHalogenMolecule(String s) {
    final u = s.replaceAll(' ', '').toUpperCase();
    return ['CL2', 'BR2', 'I2', 'F2'].contains(u);
  }

  bool isHydrogenHalide(String s) {
    final u = s.replaceAll(' ', '').toUpperCase();
    return ['HCL', 'HBR', 'HI', 'HF'].contains(u);
  }

  String halogenSymbolFromReagent(String s) {
    final u = s.replaceAll(' ', '').toUpperCase();
    if (u.contains('CL')) return 'Cl';
    if (u.contains('BR')) return 'Br';
    if (u.contains('I')) return 'I';
    if (u.contains('F')) return 'F';
    return 'X';
  }

  // common acid-anhydride -> acid mapping
  final Map<String, List<Map<String, dynamic>>> _anhydrideMap = {
    'CO2': [
      {'formula': 'H2CO3', 'coeff': 1}
    ],
    'SO2': [
      {'formula': 'H2SO3', 'coeff': 1}
    ],
    'SO3': [
      {'formula': 'H2SO4', 'coeff': 1}
    ],
    'P2O5': [
      {'formula': 'H3PO4', 'coeff': 1}
    ],
    'N2O5': [
      {'formula': 'HNO3', 'coeff': 2}
    ],
    'SO': [
      {'formula': 'H2SO2', 'coeff': 1}
    ],
  };

  // metal categories for simple hydroxide stoichiometry
  final Set<String> _alkali = {'Li', 'Na', 'K', 'Rb', 'Cs', 'Fr'};
  final Set<String> _alkalineEarth = {'Be', 'Mg', 'Ca', 'Sr', 'Ba', 'Ra'};

  int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  String _normalizeElementSymbol(String s) {
    final u = s.replaceAll(RegExp(r'[^A-Za-z]'), '');
    if (u.isEmpty) return s;
    return u[0].toUpperCase() + (u.length > 1 ? u.substring(1).toLowerCase() : '');
  }

  bool _isNonmetal(String s) {
    final nm = {
      'H', 'He', 'C', 'N', 'O', 'F', 'P', 'S', 'Cl', 'Ar', 'Se', 'Br', 'I'
    };
    final sym = _normalizeElementSymbol(s);
    return nm.contains(sym);
  }

  bool isMetalHydride(String formula) {
    final elems = parseElements(formula);
    if (!elems.containsKey('H')) return false;
    // require at least one metal and no carbon
    if (elems.containsKey('C')) return false;
    final metalPresent = elems.keys.any((k) => k != 'H' && !_isNonmetal(k));
    return metalPresent;
  }

  bool isMetalOxide(String formula) {
    final elems = parseElements(formula);
    if (!elems.containsKey('O')) return false;
    if (elems.containsKey('C')) return false;
    // require at least one metal and only metals + O (no other nonmetals)
    final metalPresent = elems.keys.any((k) => k != 'O' && !_isNonmetal(k));
    final otherNonmetals = elems.keys.where((k) => k != 'O' && k != 'H').where((k) => _isNonmetal(k)).isNotEmpty;
    return metalPresent && !otherNonmetals;
  }

  bool isAcidAnhydride(String formula) {
    final elems = parseElements(formula);
    if (elems.isEmpty) return false;
    if (elems.containsKey('H')) return false; // anhydride should not contain H
    // only oxygen + nonmetal elements allowed (e.g., C + O for CO2)
    final onlyNonmetalAndO = elems.keys.every((k) => k == 'O' || _isNonmetal(k));
    final hasNonmetal = elems.keys.any((k) => k != 'O' && _isNonmetal(k));
    return onlyNonmetalAndO && hasNonmetal;
  }

  String formatFormula(Map<String, int> counts, [Map<String, int>? extras]) {
    final combined = Map<String, int>.from(counts);
    if (extras != null) {
      extras.forEach((k, v) => combined[k] = (combined[k] ?? 0) + v);
    }
    final buffer = StringBuffer();
    if (combined.containsKey('C')) {
      final n = combined.remove('C')!;
      buffer.write('C${n > 1 ? n : ''}');
    }
    if (combined.containsKey('H')) {
      final n = combined.remove('H')!;
      buffer.write('H${n > 1 ? n : ''}');
    }
    final others = combined.keys.toList()..sort();
    for (final el in others) {
      final n = combined[el]!;
      buffer.write('$el${n > 1 ? n : ''}');
    }
    return buffer.toString();
  }

  String extractRFromAcid(String acid) {
    final u = acid.replaceAll(' ', '');
    final idx = u.toUpperCase().indexOf('COOH');
    if (idx > 0) return u.substring(0, idx);
    return u.replaceAll(RegExp(r'CO2H', caseSensitive: false), '').replaceAll(RegExp(r'COOH', caseSensitive: false), '');
  }

  String extractRFromAlcohol(String alc) {
    final u = alc.replaceAll(' ', '');
    return u.replaceFirst(RegExp(r'OH$', caseSensitive: false), '');
  }

  Future<ReactionResult> predictProducts(String input) async {
    final reactantsRaw = parseReactants(input);
    if (reactantsRaw.isEmpty) {
      return ReactionResult(products: [], explanation: 'No reactants detected.');
    }
    final reactants = reactantsRaw.map((r) => r.replaceAll(' ', '')).toList();
    final waterIndex = reactants.indexWhere((r) => isWater(r));

    // --- existing rules above (esterification, metal hydride/oxide, anhydride, etc.) ---
    // 1) Esterification (carboxylic acid + alcohol)
    final acid = reactants.firstWhere((r) => isCarboxylicAcid(r), orElse: () => '');
    final alcohol = reactants.firstWhere((r) => isAlcohol(r), orElse: () => '');
    if (acid.isNotEmpty && alcohol.isNotEmpty) {
      final rAcid = extractRFromAcid(acid);
      final rAlc = extractRFromAlcohol(alcohol);
      final ester = '${rAcid}COO${rAlc}';
      final explanation = 'Esterification heuristic: $acid + $alcohol -> $ester + H2O (acid-catalyzed, 1:1).';
      return ReactionResult(products: [
        {'formula': ester, 'coeff': 1},
        {'formula': 'H2O', 'coeff': 1}
      ], explanation: explanation);
    }

    // 2) Metal hydride + H2O -> metal hydroxide + H2
    final mhIndex = reactants.indexWhere((r) => isMetalHydride(r));
    if (mhIndex != -1 && waterIndex != -1 && mhIndex != waterIndex) {
      final mh = reactants[mhIndex];
      final elems = parseElements(mh);
      final metal = elems.keys.firstWhere((k) => k != 'H');
      final metalSym = _normalizeElementSymbol(metal);
      String hydroxide;
      if (_alkali.contains(metalSym)) {
        hydroxide = '${metalSym}OH';
      } else if (_alkalineEarth.contains(metalSym)) {
        hydroxide = '${metalSym}(OH)2';
      } else {
        hydroxide = '${metalSym}OH';
      }
      final explanation = 'Metal hydride + water heuristic: $mh + H2O -> $hydroxide + H2 (simplified).';
      return ReactionResult(products: [
        {'formula': hydroxide, 'coeff': 1},
        {'formula': 'H2', 'coeff': 1}
      ], explanation: explanation);
    }

    // 3) Metal oxide + H2O -> metal hydroxide
    final moIndex = reactants.indexWhere((r) => isMetalOxide(r));
    if (moIndex != -1 && waterIndex != -1 && moIndex != waterIndex) {
      final mo = reactants[moIndex];
      final elems = parseElements(mo);
      final metal = elems.keys.firstWhere((k) => k != 'O');
      final metalCount = elems[metal] ?? 1;
      final oxyCount = elems['O'] ?? 1;
      // attempt reasonable hydroxide formula
      final doubleVal = (oxyCount * 2) / metalCount;
      int ohPerMetal = doubleVal.round();
      String hydroxideFormula;
      final metalNorm = _normalizeElementSymbol(metal);
      if (ohPerMetal <= 1) {
        hydroxideFormula = '$metalNorm' 'OH';
      } else {
        hydroxideFormula = '$metalNorm(OH)$ohPerMetal';
      }
      final explanation = 'Metal oxide + water heuristic: $mo + H2O -> $hydroxideFormula (simplified).';
      return ReactionResult(products: [
        {'formula': hydroxideFormula, 'coeff': 1}
      ], explanation: explanation);
    }

    // 4) Acid anhydride + H2O -> oxyacid (common mappings)
    final anhyIndex = reactants.indexWhere((r) => isAcidAnhydride(r));
    if (anhyIndex != -1 && waterIndex != -1 && anhyIndex != waterIndex) {
      final anhy = reactants[anhyIndex].replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
      // exact or startsWith match in map
      for (final key in _anhydrideMap.keys) {
        if (anhy == key || anhy.startsWith(key)) {
          final mapped = _anhydrideMap[key]!;
          final explanation = 'Acid anhydride + water heuristic: $anhy + H2O -> ${mapped.map((m) => m['coeff'] > 1 ? '${m['coeff']} ${m['formula']}' : m['formula']).join(' + ')}';
          return ReactionResult(products: mapped, explanation: explanation);
        }
      }
      // fallback for CO2-like patterns
      if (anhy.contains('CO2') || anhy == 'CO2') {
        return ReactionResult(products: [
          {'formula': 'H2CO3', 'coeff': 1}
        ], explanation: 'CO2 + H2O -> H2CO3 (carbonic acid).');
      }
    }

    // 5) Hydrogen halide + H2O -> aqueous acid (HCl etc.)
    final hhIndex = reactants.indexWhere((r) => isHydrogenHalide(r));
    if (hhIndex != -1 && waterIndex != -1 && hhIndex != waterIndex) {
      final hh = reactants[hhIndex].toUpperCase();
      final explanation = 'Hydrogen halide + water: $hh dissolves to give the corresponding acid in water.';
      return ReactionResult(products: [
        {'formula': hh, 'coeff': 1}
      ], explanation: explanation);
    }

    // NEW: Alcohol + hydrogen halide -> alkyl halide + H2O (simple substitution)
    final alcoholIndex = reactants.indexWhere((r) => isAlcohol(r));
    // reuse existing hhIndex declared above
    if (alcoholIndex != -1 && hhIndex != -1 && alcoholIndex != hhIndex) {
      final alcohol = reactants[alcoholIndex];
      final hh = reactants[hhIndex];
      final rGroup = extractRFromAlcohol(alcohol); // e.g. C2H5 from C2H5OH
      final hal = halogenSymbolFromReagent(hh); // e.g. 'Cl' from HCl or Cl2
      final alkylHalide = '$rGroup$hal';
      final explanation =
          'Alcohol + hydrogen halide heuristic: $alcohol + $hh -> $alkylHalide + H2O (substitution, simplified).';
      return ReactionResult(products: [
        {'formula': alkylHalide, 'coeff': 1},
        {'formula': 'H2O', 'coeff': 1}
      ], explanation: explanation);
    }

    // --- existing rules below (halogen substitution/addition, combustion, acid-base, fallback) ---
    // 6) Halogen substitution/addition with hydrocarbons
    final halogenMolIndex = reactants.indexWhere((r) => isHalogenMolecule(r) || isHydrogenHalide(r));
    final hydroIndex = reactants.indexWhere((r) => looksLikeHydrocarbon(r));
    if (hydroIndex != -1 && halogenMolIndex != -1 && hydroIndex != halogenMolIndex) {
      final hydro = reactants[hydroIndex];
      final reagent = reactants[halogenMolIndex];
      final elems = parseElements(hydro);
      final c = elems['C'] ?? 0;
      final h = elems['H'] ?? 0;

      if (c > 0 && h == 2 * c + 2) {
        // alkane substitution: R-H + X2 -> R-X + HX
        final hal = halogenSymbolFromReagent(reagent);
        final newCounts = {'C': c, 'H': h - 1};
        final productFormula = formatFormula(newCounts, {hal: 1});
        final byproduct = isHalogenMolecule(reagent) ? 'H$hal' : (isHydrogenHalide(reagent) ? reagent.toUpperCase() : 'HX');
        final explanation = 'Substitution heuristic: alkane + halogen -> haloalkane + hydrogen halide (simplified).';
        return ReactionResult(products: [
          {'formula': productFormula, 'coeff': 1},
          {'formula': byproduct, 'coeff': 1}
        ], explanation: explanation);
      } else if (c > 0 && h == 2 * c) {
        // alkene addition
        if (isHalogenMolecule(reagent)) {
          final hal = halogenSymbolFromReagent(reagent);
          final product = formatFormula({'C': c, 'H': h}, {hal: 2});
          final explanation = 'Addition heuristic: alkene + X2 -> vicinal dihalide.';
          return ReactionResult(products: [
            {'formula': product, 'coeff': 1}
          ], explanation: explanation);
        } else if (isHydrogenHalide(reagent)) {
          final hal = halogenSymbolFromReagent(reagent);
          final product = formatFormula({'C': c, 'H': h + 1}, {hal: 1});
          final explanation = 'Addition heuristic: alkene + HX -> haloalkane (Markovnikov not considered).';
          return ReactionResult(products: [
            {'formula': product, 'coeff': 1}
          ], explanation: explanation);
        }
      } else if (c > 0 && h == 2 * c - 2) {
        // alkyne addition (one equivalent)
        if (isHalogenMolecule(reagent)) {
          final hal = halogenSymbolFromReagent(reagent);
          final product = formatFormula({'C': c, 'H': h}, {hal: 2});
          final explanation = 'Addition heuristic: alkyne + X2 -> dihalogenated product (simplified).';
          return ReactionResult(products: [
            {'formula': product, 'coeff': 1}
          ], explanation: explanation);
        } else if (isHydrogenHalide(reagent)) {
          final hal = halogenSymbolFromReagent(reagent);
          final product = formatFormula({'C': c, 'H': h + 1}, {hal: 1});
          final explanation = 'Addition heuristic: alkyne + HX -> vinyl halide (one equivalent, simplified).';
          return ReactionResult(products: [
            {'formula': product, 'coeff': 1}
          ], explanation: explanation);
        }
      }
    }

    // 7) Combustion (hydrocarbon + O2)
    final hasHydrocarbon = reactants.any((r) => looksLikeHydrocarbon(r));
    final hasO2 = reactants.any((r) => r.toUpperCase().replaceAll(' ', '') == 'O2');
    if (hasHydrocarbon && hasO2) {
      final hydro = reactants.firstWhere((r) => looksLikeHydrocarbon(r));
      final elems = parseElements(hydro);
      final c = elems['C'] ?? 0;
      final h = elems['H'] ?? 0;
      if (c > 0) {
        int co2 = c;
        int h2oNum = h;
        int mult = 1;
        if ((h % 2) != 0) mult = 2;
        co2 *= mult;
        h2oNum *= mult;
        final h2o = h2oNum ~/ 2;
        int oxyAtoms = 2 * co2 + h2o;
        int o2Num = oxyAtoms;
        if ((o2Num % 2) != 0) {
          co2 *= 2;
          final newH2o = (h * 2) ~/ 2;
          o2Num = 2 * co2 + newH2o;
        }
        int o2 = o2Num ~/ 2;
        final g = [co2, h2o, o2, 1].reduce((a, b) => _gcd(a, b));
        co2 ~/= g;
        final h2oFinal = h2o ~/ g;
        o2 ~/= g;

        final products = <Map<String, dynamic>>[];
        if (co2 > 0) products.add({'formula': 'CO2', 'coeff': co2});
        if (h2oFinal > 0) products.add({'formula': 'H2O', 'coeff': h2oFinal});
        final explanation =
            'Combustion heuristic: balanced for hydrocarbon $hydro + O2 -> CO2 + H2O (coefficients simplified).';

        return ReactionResult(products: products, explanation: explanation);
      }
    }

    // 8) Acid-base neutralization (ionic base)
    final acid2 = reactants.firstWhere((r) {
      final s = r.replaceAll(' ', '');
      return s.startsWith('H') && s.length > 1 && !s.contains('OH');
    }, orElse: () => '');
    final base = reactants.firstWhere((r) {
      final u = r.replaceAll(' ', '').toUpperCase();
      return u.contains('OH') && (RegExp(r'^[A-Z]{1,2}OH$').hasMatch(u) || u.contains('(OH)'));
    }, orElse: () => '');
    if (acid2.isNotEmpty && base.isNotEmpty) {
      String acidAnion = acid2.replaceFirst(RegExp(r'^H'), '');
      String baseClean = base.replaceAll(' ', '');
      String cation = baseClean;
      cation = cation.replaceAllMapped(RegExp(r'\(OH\)\d*'), (m) => '');
      cation = cation.replaceAll(RegExp(r'OH\d*'), '');
      cation = cation.replaceAll(RegExp(r'OH'), '');
      if (cation.isEmpty) cation = 'M';
      final salt = '$cation$acidAnion';
      final explanation = 'Acid–base neutralization heuristic: $acid2 + $base -> $salt + H2O (simplified).';
      final products = [
        {'formula': salt, 'coeff': 1},
        {'formula': 'H2O', 'coeff': 1}
      ];
      return ReactionResult(products: products, explanation: explanation);
    }

    // 9) simple synthesis fallback (A + B -> AB)
    if (reactants.length == 2) {
      final a = reactants[0].replaceAll(RegExp(r'[^A-Za-z0-9\(\)]'), '');
      final b = reactants[1].replaceAll(RegExp(r'[^A-Za-z0-9\(\)]'), '');
      final product = '$a$b';
      final explanation = 'Synthesis fallback: combined formulas naively to produce $product (may be chemically incorrect).';
      return ReactionResult(products: [
        {'formula': product, 'coeff': 1}
      ], explanation: explanation);
    }

    return ReactionResult(products: [], explanation: 'No heuristic matched for the provided reaction. Try simpler inputs.');
  }
}