import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class BancoModel {
  // Singleton simples
  BancoModel._internal();
  static final BancoModel _instance = BancoModel._internal();
  factory BancoModel() => _instance;

  static const String _dbName = 'app_local.db';
  static const int _dbVersion = 1;

  Database? _db;

  /// Retorna a instância de [Database], abrindo/criando se necessário.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final basePath = await getDatabasesPath();
    final path = p.join(basePath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Criação inicial do banco
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto TEXT NOT NULL,
        codBarra TEXT NOT NULL,
        valor integer not null
      );
    ''');
  }

  /// Migração de versão (quando você aumentar [_dbVersion])
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: Escreva suas migrações aqui quando mudar a versão do banco
  }

  /// Opcional: fechar o banco quando não for mais usar (ex.: ao fechar o app)
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
