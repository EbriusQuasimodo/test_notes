import 'package:test_todo/data/isar_database.dart';
import 'package:test_todo/data/models/note_dto.dart';
import 'package:test_todo/domain/note_entity.dart';

import 'package:isar/isar.dart';
import 'package:test_todo/domain/notes_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final IsarDatabase isarDatabase;
  NoteRepositoryImpl({required this.isarDatabase});

  @override
  Future<void> createNote(NoteEntity note) async {
    final isar = isarDatabase.isar;
    final noteModel = NoteDTO.fromNote(note);
    await isar.writeTxn(() async {
      await isar.noteDTOs.put(noteModel);
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    final isar = isarDatabase.isar;
    final noteModel =
        await isar.noteDTOs.filter().noteIdEqualTo(id).findFirst();
    if (noteModel != null) {
      await isar.writeTxn(() async {
        await isar.noteDTOs.delete(noteModel.id);
      });
    }
  }

  @override
  Future<List<NoteEntity>> getNotes({
    String? searchQuery,
    bool sortDesc = true,
  }) async {
    final isar = isarDatabase.isar;

    final query = isar.noteDTOs.where().filter().titleContains(
      searchQuery ?? '',
      caseSensitive: false,
    );

    final notes =
        sortDesc
            ? await query.sortByCreatedAtDesc().findAll()
            : await query.sortByCreatedAt().findAll();

    return notes.map((m) => m.toNote()).toList();
  }

  @override
  Future<NoteEntity> getNoteById(String id) async {
    final isar = isarDatabase.isar;
    final noteModel =
        await isar.noteDTOs.filter().noteIdEqualTo(id).findFirst();
    if (noteModel == null) {
      throw Exception("Заметка с id $id не найдена");
    }
    return noteModel.toNote();
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    final isar = isarDatabase.isar;
    final noteModel = NoteDTO.fromNote(note);
    await isar.writeTxn(() async {
      await isar.noteDTOs.put(noteModel);
    });
  }
}
