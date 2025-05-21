part of 'notes_bloc.dart';

abstract class NotesState {}
class NoteListInitial extends NotesState {}
class NoteListLoading extends NotesState {}
class NoteListLoaded extends NotesState {
  final List<NoteEntity> notes;
  NoteListLoaded(this.notes);
}
class NoteListError extends NotesState {
  final String message;
  NoteListError(this.message);
}