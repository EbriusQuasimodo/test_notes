import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_todo/domain/notes_repository.dart';
import 'package:test_todo/presentation/notes_create_edit/notes_create_edit_view.dart';
import 'package:test_todo/presentation/notes_list/bloc/notes_bloc.dart';

class NoteListScreen extends StatefulWidget {
  final NoteRepository noteRepository;
  const NoteListScreen({Key? key, required this.noteRepository})
    : super(key: key);
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late NotesBloc _noteListBloc;
  final TextEditingController _searchController = TextEditingController();
  bool _sortDesc = true;
  @override
  void initState() {
    super.initState();
    _noteListBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _noteListBloc.add(
      LoadNotes(searchQuery: _searchController.text, sortDesc: _sortDesc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Заметки"),
        actions: [
          IconButton(
            icon: Icon(_sortDesc ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _sortDesc = !_sortDesc;
              });
              _noteListBloc.add(
                LoadNotes(
                  searchQuery: _searchController.text,
                  sortDesc: _sortDesc,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: "Поиск заметок",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NoteListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NoteListLoaded) {
                  if (state.notes.isEmpty) {
                    return Center(child: Text("Нет заметок"));
                  }
                  return ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return Dismissible(
                        key: Key(note.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          _noteListBloc.add(DeleteNoteEvent(note.id));
                        },
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content),
                          trailing: Text(
                            '${DateFormat('dd MMM yyyy','ru').format(note.createdAt)}',
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => NoteEditScreen(
                                          noteRepository: widget.noteRepository,
                                          noteId: note.id,
                                        ),
                                  ),
                                )
                                .then((_) {
                                  _noteListBloc.add(
                                    LoadNotes(
                                      searchQuery: _searchController.text,
                                      sortDesc: _sortDesc,
                                    ),
                                  );
                                });
                          },
                        ),
                      );
                    },
                  );
                } else if (state is NoteListError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder:
                      (_) =>
                          NoteEditScreen(noteRepository: widget.noteRepository),
                ),
              )
              .then((_) {
                _noteListBloc.add(
                  LoadNotes(
                    searchQuery: _searchController.text,
                    sortDesc: _sortDesc,
                  ),
                );
              });
        },
      ),
    );
  }
}
