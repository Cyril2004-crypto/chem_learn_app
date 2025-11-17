import 'package:flutter/material.dart';
import '../models/molecule.dart';

class MoleculeViewerWidget extends StatelessWidget {
  final Molecule molecule;
  const MoleculeViewerWidget({super.key, required this.molecule});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Molecule id: ${molecule.id}'),
      Text('Atoms: ${molecule.atomCount}, Bonds: ${molecule.bondCount}'),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: () {}, child: const Text('Open 3D viewer (stub)')),
    ]);
  }
}