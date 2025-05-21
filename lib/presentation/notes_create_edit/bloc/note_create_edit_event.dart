part of 'note_create_edit_bloc.dart';
abstract class NoteEditEvent {}
class LoadNoteForEdit extends NoteEditEvent {
  final String id;
  LoadNoteForEdit(this.id);
}
class SaveNoteEvent extends NoteEditEvent {
  final String? id;
  final String title;
  final String content;
  SaveNoteEvent({this.id, required this.title, required this.content});
}