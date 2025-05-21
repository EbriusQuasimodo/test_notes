import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_todo/domain/note_entity.dart';
import 'package:test_todo/domain/notes_repository.dart';
import 'package:uuid/uuid.dart';

part 'note_create_edit_event.dart';

part 'note_create_edit_state.dart';
class NoteEditBloc extends Bloc<NoteEditEvent, NoteEditState> {
  final NoteRepository noteRepository;
  NoteEditBloc({required this.noteRepository}) : super(NoteEditInitial()) {
    on<LoadNoteForEdit>((event, emit) async {
      emit(NoteEditLoading());
      try {
        NoteEntity? note = await noteRepository.getNoteById(event.id);
        emit(NoteEditLoaded(note));
      } catch (e) {
        emit(NoteEditError("Ошибка загрузки заметки"));
      }
    });
    on<SaveNoteEvent>((event, emit) async {
      if (event.title.trim().isEmpty) {
        emit(NoteEditError("Заголовок не может быть пустым"));
        return;
      }
      try {
        if (event.id == null) {
          final newNote = NoteEntity(
            id: Uuid().v4(),
            title: event.title,
            content: event.content,
            createdAt: DateTime.now(),
          );
          await noteRepository.createNote(newNote);
        } else {
          NoteEntity? existing = await noteRepository.getNoteById(event.id!);
          if (existing != null) {
            final updated = existing.copyWith(
              title: event.title,
              content: event.content,
            );
            await noteRepository.updateNote(updated);
          }
        }
        emit(NoteEditSuccess());
      } catch (e) {
        emit(NoteEditError("Ошибка сохранения заметки"));
      }
    });
  }
}