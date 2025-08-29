import 'package:restoranapp/features/favorites/models/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class FavoriteDatabase {
  static final FavoriteDatabase instance = FavoriteDatabase._init();
  static Database? _database;

  FavoriteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableFavorites (
  ${FavoriteFields.id} $idType,
  ${FavoriteFields.restaurantId} $textType,
  ${FavoriteFields.name} $textType,
  ${FavoriteFields.city} $textType,
  ${FavoriteFields.pictureId} $textType,
  ${FavoriteFields.rating} $integerType
)
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}