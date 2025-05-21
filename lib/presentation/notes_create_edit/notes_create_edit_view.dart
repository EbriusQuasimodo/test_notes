import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_todo/domain/notes_repository.dart';
import 'package:test_todo/presentation/notes_create_edit/bloc/note_create_edit_bloc.dart';
class NoteEditScreen extends StatefulWidget {
  final String? noteId;
  final NoteRepository noteRepository;
  const NoteEditScreen({Key? key, this.noteId, required this.noteRepository}) : super(key: key);
  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}
class _NoteEditScreenState extends State<NoteEditScreen> {
  late NoteEditBloc _noteEditBloc;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _noteEditBloc = NoteEditBloc(noteRepository: widget.noteRepository);
    if (widget.noteId != null) {
      _noteEditBloc.add(LoadNoteForEdit(widget.noteId!));
    }
  }
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _noteEditBloc.close();
    super.dispose();
  }
  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _noteEditBloc.add(SaveNoteEvent(
          id: widget.noteId,
          title: _titleController.text,
          content: _contentController.text));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? "Создать заметку" : "Редактировать заметку"),
      ),
      body: BlocListener<NoteEditBloc, NoteEditState>(
        bloc: _noteEditBloc,
        listener: (context, state) {
          if (state is NoteEditSuccess) {
            Navigator.of(context).pop();
          } else if (state is NoteEditError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is NoteEditLoaded) {
            if (state.note != null) {
              _titleController.text = state.note!.title;
              _contentController.text = state.note!.content;
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Заголовок*"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Заголовок не может быть пустым";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: "Текст заметки"),
                maxLines: null,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _onSave,
                child: Text("Сохранить"),
              )
            ]),
          ),
        ),
      ),
    );
  }
}