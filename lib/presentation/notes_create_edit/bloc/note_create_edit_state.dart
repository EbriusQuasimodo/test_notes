part of 'note_create_edit_bloc.dart';

abstract class NoteEditState {}
class NoteEditInitial extends NoteEditState {}
class NoteEditLoading extends NoteEditState {}
class NoteEditLoaded extends NoteEditState {
  final NoteEntity? note;
  NoteEditLoaded(this.note);
}
class NoteEditSuccess extends NoteEditState {}
class NoteEditError extends NoteEditState {
  final String message;
  NoteEditError(this.message);
}