import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonProvider extends ChangeNotifier {
  final List<Lesson> _lessons = [];

  List<Lesson> get lessons => List.unmodifiable(_lessons);

  void setLessons(List<Lesson> lessons) {
    _lessons.clear();
    _lessons.addAll(lessons);
    notifyListeners();
  }

  void addLesson(Lesson lesson) {
    _lessons.add(lesson);
    notifyListeners();
  }

  Lesson? findById(String id) {
    final idx = _lessons.indexWhere((l) => l.id == id);
    return idx == -1 ? null : _lessons[idx];
  }

  /// Seeds a robust set of sample chemistry lessons (synchronous).
  /// Call once at app startup (or from tests) to provide initial content.
  void seedSampleLessons() {
    if (_lessons.isNotEmpty) return; // avoid duplicate seeding

    final samples = <Lesson>[
      TextLesson(
        'l1',
        'Introduction to Atoms',
        '''
Atoms are the basic units of matter. Each atom consists of a nucleus made of protons and neutrons, surrounded by electrons in orbitals.

Key components
- Proton: positively charged; determines the element (atomic number).
- Neutron: neutral; contributes to atomic mass and creates isotopes when count differs.
- Electron: negatively charged; orbits the nucleus in shells and determines chemical behavior.

Important concepts
- Atomic number (Z): number of protons.
- Mass number (A): protons + neutrons.
- Isotopes: same Z, different A — may have different stability or physical properties.
- Electron configuration and valence electrons: explain periodic trends and bonding patterns.

Examples and applications
- Hydrogen (H): 1 proton, no neutrons (most common isotope).
- Carbon (C): forms 4 covalent bonds due to 4 valence electrons — basis of organic chemistry.
''',
      ),
      TextLesson(
        'l2',
        'Periodic Table Basics',
        '''
The periodic table organizes elements by atomic number and recurring chemical properties.

Structure & trends
- Groups (columns): elements with similar valence electron counts and chemical behavior (e.g., Group 1 = alkali metals).
- Periods (rows): each period adds a new electron shell.
- Metals, metalloids, nonmetals: location indicates general physical and chemical behavior.
- Periodic trends: electronegativity (tendency to attract electrons), ionization energy (energy to remove an electron), atomic radius (size of atom).

How to use the table
- Predict oxidation states and likely compounds.
- Identify likely reactions (e.g., alkali metals react vigorously with water).
- Recognize families: halogens, noble gases, transition metals.

Real-world note
- The table is a predictive tool for materials science, catalysis, and drug design.

Periodic table chart (interactive)
- To view an interactive periodic table (explore element data, isotopes, electron shells and common compounds) open one of these resources:
  • Official interactive: https://ptable.com
  • PubChem periodic table: https://pubchem.ncbi.nlm.nih.gov/periodic-table
  • WebElements: https://www.webelements.com

Tip: the interactive charts let you click an element to see atomic number, electronic configuration, common oxidation states, isotopes, and links to compound data — useful for quickly adding examples or exploring real element data.
''',
      ),
      TextLesson(
        'l3',
        'Chemical Bonding — Overview',
        '''
Chemical bonds hold atoms together in molecules and solids. Main bond types:

Covalent bonds
- Formed by sharing electron pairs between atoms.
- Polar covalent: unequal sharing (electronegativity difference); nonpolar covalent: equal sharing.
- Example: H–H (nonpolar), H–Cl (polar).

Ionic bonds
- Formed by transfer of electrons producing oppositely charged ions that attract.
- Typical between metals and nonmetals (e.g., NaCl).

Metallic bonds
- Delocalized electrons shared across a lattice of metal cations — explains conductivity and malleability.

Intermolecular forces (weaker but crucial)
- Hydrogen bonding: strong dipole–dipole interaction involving H bonded to N, O, or F.
- Dipole–dipole and London dispersion forces: determine boiling/melting points and solubility.

Bonding implications
- Bond type influences properties like melting point, solubility, electrical conductivity, and reactivity.
''',
      ),
      TextLesson(
        'l4',
        'Acids and Bases (Intro)',
        '''
Brønsted–Lowry definitions:
- Acid: proton (H⁺) donor.
- Base: proton acceptor.

pH and strength
- pH measures hydrogen ion concentration: pH = -log[H⁺].
- Strong acids/bases ionize completely in water (e.g., HCl, NaOH); weak ones partially (e.g., acetic acid).

Conjugate pairs & buffers
- Acid ↔ conjugate base; base ↔ conjugate acid.
- Buffers resist pH change by using a weak acid/base pair (important in biological systems).

Applications
- Acid–base titrations determine concentrations.
- pH control is fundamental in enzymatic activity, environmental chemistry, and industrial processes.
''',
      ),
      MoleculeLesson(
        'l5',
        'Water (H₂O)',
        '''
Water is a small polar molecule with a bent shape (~104.5°). Oxygen is more electronegative than hydrogen, creating a permanent dipole.

Why water is special
- Hydrogen bonding: gives high cohesion, surface tension, and high boiling point relative to mass.
- Excellent solvent for ionic and many polar compounds — essential for biological chemistry.
- Density anomaly: ice is less dense than liquid water due to hydrogen-bonded lattice (important for aquatic life).

Key properties
- SMILES: O
- Polarity, solvent behavior, role in acid–base chemistry and redox.
''',
        'O',
      ),
      MoleculeLesson(
        'l6',
        'Ethanol (C₂H₅OH)',
        '''
Ethanol is an alcohol with two carbons and a terminal hydroxyl (–OH) group.

Structure & properties
- SMILES: CCO
- Hydrophilic hydroxyl group allows hydrogen bonding with water — ethanol is miscible with water.
- Boiling point higher than hydrocarbons of similar size because of hydrogen bonding.

Uses & safety
- Widely used as a solvent, fuel additive, disinfectant, and recreational beverage component.
- Flammable and can be toxic at high doses; handle with care.
''',
        'CCO',
      ),
      TextLesson(
        'l7',
        'Stoichiometry — Basic Calculations',
        '''
Stoichiometry connects balanced chemical equations to amounts (moles, mass, molecules).

Core steps
1. Balance the chemical equation.
2. Convert known mass to moles using molar mass.
3. Use mole ratios from the balanced equation to find moles of unknown.
4. Convert moles back to desired units (mass, liters of gas at STP, number of molecules).

Example
- Reaction: 2 H₂ + O₂ → 2 H₂O
- To make 18 g H₂O (1 mole), need 1 mole H₂ and 0.5 mole O₂.

Applications
- Yield predictions, reagent scaling in labs, and industrial feedstock calculations.
''',
      ),
      TextLesson(
        'l8',
        'Reaction Rates & Kinetics',
        '''
Reaction kinetics studies how fast reactions occur and the factors that affect rate.

Key factors
- Concentration: higher concentrations usually increase collisions and rates.
- Temperature: usually increases rate (Arrhenius equation) by providing activation energy.
- Catalysts: lower activation energy, increase rate without being consumed.
- Surface area and physical state: influence frequency of effective collisions.

Rate laws & mechanisms
- Experimental rate laws relate rate to reactant concentrations and reveal mechanism steps.
- Order of reaction (0, 1, 2...) indicates how rate depends on concentration.

Practical importance
- Controlling rates is essential in synthesis, biological systems, safety (prevent runaway reactions), and catalysis design.
''',
      ),
      TextLesson(
        'l9',
        'Organic Functional Groups — Quick Guide',
        '''
Functional groups determine reactivity patterns in organic molecules.

Common groups
- Hydroxyl (–OH): alcohols (e.g., ethanol) — polar, hydrogen bonding.
- Carbonyl (C=O): aldehydes and ketones — polar, reactive at the carbonyl carbon.
- Carboxyl (–COOH): carboxylic acids — acidic, forms salts.
- Amino (–NH₂): amines — basic, important in biomolecules.
- Halides (–Cl, –Br): alkyl halides — useful for substitutions and eliminations.

Why it matters
- Identifying functional groups allows prediction of reactions (e.g., nucleophilic attack, oxidation, reduction).
- Functional-group transformations are the backbone of organic synthesis.
''',
      ),
      TextLesson(
        'l10',
        'Safety, Lab Practice & Measurements',
        '''
Good laboratory practice protects people and data quality.

Basic rules
- Wear PPE: gloves, goggles, lab coat.
- Understand hazards: read Safety Data Sheets (SDS) for chemicals.
- Proper waste disposal and labeling.

Measurements & uncertainty
- Use appropriate glassware (pipettes, volumetric flasks) for precision.
- Report measured values with uncertainty/significant figures.
- Calibrate instruments and keep records (lab notebook).

Ethics & reproducibility
- Keep detailed experimental methods so others can reproduce work.
- Follow institutional and legal guidelines for hazardous work and biological materials.
''',
      ),

      // New topic: Organic Chemistry
      TextLesson(
        'l11',
        'Organic Chemistry — Foundations & Key Concepts',
        '''
Organic chemistry studies carbon-containing compounds and their transformations. Carbon's tetravalency enables the enormous diversity of organic molecules.

Core ideas
- Structure & bonding: carbon forms strong C–C and C–H bonds; hybridization (sp, sp2, sp3) controls geometry and reactivity.
- Functional groups: hydroxyl, carbonyl, carboxyl, amino, halides, ethers, esters, nitriles, etc. Group identity predicts reactivity.
- Nomenclature: IUPAC rules name molecules by longest chain, principal functional group, and substituents.
- Reaction types: substitution (SN1/SN2), elimination (E1/E2), addition (alkenes/alkynes), nucleophilic acyl substitution, oxidations, reductions.
- Mechanisms & intermediates: carbocations, carbanions, radicals, and transition states; understanding mechanisms predicts regiochemistry and stereochemistry.

Tools & techniques
- Spectroscopy: NMR (1H, 13C) for structure; IR for functional groups; MS for molecular weight and fragmentation patterns.
- Retrosynthesis: working backwards from target molecules to simpler precursors for synthesis planning.

Applications
- Pharmaceuticals, agrochemicals, polymers, materials, and natural product synthesis.
- Safety: many organic reactions use flammable solvents and reactive reagents — proper ventilation and PPE required.
''',
      ),

      // New topic: Inorganic Chemistry
      TextLesson(
        'l12',
        'Inorganic Chemistry — Elements, Coordination & Solids',
        '''
Inorganic chemistry covers the behavior of elements (especially metals), coordination complexes, and solid-state materials.

Key areas
- Coordination chemistry: metal centers bonded to ligands (Lewis bases). Concepts: coordination number, ligand field, crystal field splitting, geometry (octahedral, tetrahedral, square planar).
- Oxidation states & redox chemistry: many inorganic reactions involve electron transfer; track oxidation numbers to balance redox equations.
- Solid-state chemistry: lattices, band structure, defects, ionic vs covalent solids — explains conductivity, magnetism, and optical properties.
- Main-group vs transition-metal chemistry: main-group elements follow predictable valence rules; transition metals show variable oxidation states and rich coordination behavior.
- Organometallics: compounds with metal–carbon bonds; central to catalysis (e.g., cross-coupling reactions, hydrogenation).

Applications
- Catalysis (industrial & environmental), materials (semiconductors, magnets), bioinorganic chemistry (metalloenzymes), and synthesis of advanced materials.
''',
      ),

      // New topic: Radioactivity & Nuclear Chemistry
      TextLesson(
        'l13',
        'Radioactivity — Types, Decay & Applications',
        '''
Radioactivity arises from unstable atomic nuclei undergoing spontaneous transformations that emit particles/radiation.

Types of decay
- Alpha (α): emission of a helium nucleus (2 protons, 2 neutrons). Large mass, low penetration (stopped by paper).
- Beta (β− / β+): beta-minus emits an electron and antineutrino; beta-plus emits a positron. Changes element's proton count.
- Gamma (γ): high-energy photon emission accompanying nuclear transitions. High penetration, requires dense shielding.

Decay law & half-life
- Radioactive decay is exponential: N(t) = N0 * e^(−λt), where λ is decay constant.
- Half-life (t1/2) = ln2 / λ — time for half the nuclei to decay.
- Activity measured in becquerel (Bq = decays/sec) or curie (Ci).

Detection & measurement
- Geiger–Müller counters detect ionizing radiation.
- Scintillation detectors and semiconductor detectors measure energy spectra.
- Proper calibration and background subtraction are required.

Safety & applications
- Shielding, distance, and time minimize exposure; follow ALARA (As Low As Reasonably Achievable).
- Medical uses: diagnostics (radiotracers, PET scans) and therapy (radiotherapy).
- Industrial & scientific: radiometric dating, tracers for process studies, and nuclear power generation.
''',
      ),
    ];

    setLessons(samples);
  }
}