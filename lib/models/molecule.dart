class Atom {
  final String element;
  final int atomicNumber;
  final double _mass; // encapsulated

  Atom(this.element, this.atomicNumber, double mass) : _mass = mass;

  double get mass => _mass;
}

class Bond {
  final int aIndex;
  final int bIndex;
  final int order;

  Bond(this.aIndex, this.bIndex, {this.order = 1});
}

class Molecule {
  final String id;
  final List<Atom> _atoms = [];
  final List<Bond> _bonds = [];

  Molecule(this.id);

  List<Atom> get atoms => List.unmodifiable(_atoms);
  List<Bond> get bonds => List.unmodifiable(_bonds);

  void addAtom(Atom atom) => _atoms.add(atom);
  void addBond(Bond bond) => _bonds.add(bond);

  int get atomCount => _atoms.length;
  int get bondCount => _bonds.length;

  Map<String, dynamic> toMap() => {
        'id': id,
        'atoms': _atoms.map((a) => {'element': a.element, 'atomicNumber': a.atomicNumber, 'mass': a.mass}).toList(),
        'bonds': _bonds.map((b) => {'a': b.aIndex, 'b': b.bIndex, 'order': b.order}).toList(),
      };
}