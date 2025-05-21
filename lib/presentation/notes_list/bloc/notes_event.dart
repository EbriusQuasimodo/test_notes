part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class LoadNotes extends NotesEvent {
  final String? searchQuery;
  final bool sortDesc;
  LoadNotes({this.searchQuery, this.sortDesc = true});
}

class DeleteNoteEvent extends NotesEvent {
  final String id;
  DeleteNoteEvent(this.id);
}
