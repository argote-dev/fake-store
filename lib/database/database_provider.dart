import 'package:riverpod/riverpod.dart';
import 'database_service.dart';
import 'package:sqflite/sqflite.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final databaseProvider = FutureProvider<Database>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  return await service.database;
});
