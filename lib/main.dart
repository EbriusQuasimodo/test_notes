import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_todo/data/isar_database.dart';
import 'package:test_todo/data/note_repository_impl.dart';
import 'package:test_todo/domain/notes_repository.dart';
import 'package:test_todo/presentation/notes_list/bloc/notes_bloc.dart';
import 'package:test_todo/presentation/notes_list/notes_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarDatabase = IsarDatabase();
  await isarDatabase.init();
  NoteRepository noteRepository = NoteRepositoryImpl(
    isarDatabase: isarDatabase,
  );
  initializeDateFormatting();
  runApp(MyApp(noteRepository: noteRepository));
}

class MyApp extends StatelessWidget {
  final NoteRepository noteRepository;
  const MyApp({super.key, required this.noteRepository});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              NotesBloc(noteRepository: noteRepository)
                ..add(LoadNotes(sortDesc: true)),

      child: MaterialApp(
        title: 'Flutter Notes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: NoteListScreen(noteRepository: noteRepository),
      ),
    );
  }
}
