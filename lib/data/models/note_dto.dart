import 'package:isar/isar.dart';
import 'package:test_todo/domain/note_entity.dart';

part 'note_dto.g.dart';

@collection
class NoteDTO {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? noteId;
  String? title;
  String? content;
  DateTime? createdAt;
  NoteDTO({
    this.noteId,
    this.title,
    this.content,
    this.createdAt,
  });
  factory NoteDTO.fromNote(NoteEntity note) {
    return NoteDTO(
      noteId: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
    );
  }
    NoteEntity toNote() {
    return NoteEntity(
      id: noteId??'',
      title: title??'',
      content: content??'',
      createdAt: createdAt??DateTime.now(),
    );
  }
}
