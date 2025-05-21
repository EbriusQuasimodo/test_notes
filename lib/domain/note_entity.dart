class NoteEntity {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}