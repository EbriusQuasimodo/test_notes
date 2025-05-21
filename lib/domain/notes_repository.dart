
import 'package:test_todo/domain/note_entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getNotes({String? searchQuery, bool sortDesc = true});
  Future<void> createNote(NoteEntity note);
  Future<void> updateNote(NoteEntity note);
  Future<void> deleteNote(String id);
  Future<NoteEntity?> getNoteById(String id);
}
