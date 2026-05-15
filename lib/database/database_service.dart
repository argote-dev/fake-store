import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = kIsWeb ? 'fake_store.db' : await _getDbPath();
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<String> _getDbPath() async {
    final documentsDirectory = await getDatabasesPath();
    return join(documentsDirectory, 'fake_store.db');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE products (
            product_id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price REAL NOT NULL,
            unit TEXT NOT NULL,
            image TEXT NOT NULL,
            discount INTEGER NOT NULL,
            availability INTEGER NOT NULL,
            brand TEXT NOT NULL,
            category TEXT NOT NULL,
            rating REAL NOT NULL,
            reviews_json TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
          ''');

    await db.execute('''
          CREATE TABLE cart_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER,
            name TEXT,
            image TEXT,
            price REAL,
            unit TEXT,
            quantity INTEGER,
            is_express INTEGER
          )
        ''');

    final categories = [
      'Electronics',
      'Wearables',
      'Cameras',
      'Gaming',
      'Appliances'
    ];

    for (var category in categories) {
      await db.insert(
        'categories',
        {'name': category},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
