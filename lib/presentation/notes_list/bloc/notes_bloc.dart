import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_todo/data/models/note_dto.dart';
import 'package:test_todo/domain/note_entity.dart';
import 'package:test_todo/domain/notes_repository.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository noteRepository;
  NotesBloc({required this.noteRepository}) : super(NoteListInitial()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteListLoading());
      try {
        final notes = await noteRepository.getNotes(
            searchQuery: event.searchQuery, sortDesc: event.sortDesc);
        emit(NoteListLoaded(notes));
      } catch (e) {
        emit(NoteListError("Ошибка загрузки заметок"));
      }
    });
    on<DeleteNoteEvent>((event, emit) async {
      await noteRepository.deleteNote(event.id);
      add(LoadNotes());
    });
  }
}