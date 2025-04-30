import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/loyalty_card.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'loyalty_cards.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE cards(id TEXT PRIMARY KEY, name TEXT, barcode TEXT, expirationDate TEXT, imagePath TEXT)');
      },
    );
  }

  Future<void> insertCard(LoyaltyCard card) async {
    final db = await database;
    await db.insert('cards', {
      'id': card.id,
      'name': card.name,
      'barcode': card.barcode,
      'expirationDate': card.expirationDate.toIso8601String(),
      'imagePath': card.imagePath,
    });
  }

  Future<List<LoyaltyCard>> getCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cards');
    return List.generate(maps.length, (i) {
      return LoyaltyCard(
        id: maps[i]['id'],
        name: maps[i]['name'],
        barcode: maps[i]['barcode'],
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
        imagePath: maps[i]['imagePath'],
      );
    });
  }

  Future<void> deleteCard(String id) async {
    final db = await database;
    await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
}
