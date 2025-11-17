abstract class Lesson {
  final String id;
  String _title;
  String _content;

  Lesson(this.id, String title, String content)
      : _title = title,
        _content = content;

  String get title => _title;
  set title(String t) => _title = t.trim();

  String get content => _content;
  set content(String c) => _content = c;

  String displayType();

  Map<String, dynamic> toMap() => {'id': id, 'title': _title, 'content': _content};
}

class MoleculeLesson extends Lesson {
  final String smiles;

  MoleculeLesson(String id, String title, String content, this.smiles)
      : super(id, title, content);

  @override
  String displayType() => 'Molecule';

  String shortSummary() => '$title — SMILES ${smiles.length} chars';
}

// simple concrete lesson for plain text lessons
class TextLesson extends Lesson {
  TextLesson(String id, String title, String content) : super(id, title, content);

  @override
  String displayType() => 'Lesson';
}