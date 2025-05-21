import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_todo/data/models/note_dto.dart';
class IsarDatabase {
  static final IsarDatabase _instance = IsarDatabase._internal();
  late Isar isar;
  IsarDatabase._internal();
  factory IsarDatabase() => _instance;
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteDTOSchema],
      directory: dir.path,
    );
  }
}