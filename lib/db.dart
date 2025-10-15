
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OrderNote {
  final int id; // auto-increment
  final String orderNumber; // e.g. '29/17'
  final String customerName;
  final String details;
  final String? photoNotePath;
  final String? photoFinalPath;
  final String? location;
  final DateTime createdAt;

  OrderNote({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.details,
    this.photoNotePath,
    this.photoFinalPath,
    this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'orderNumber': orderNumber,
        'customerName': customerName,
        'details': details,
        'photoNotePath': photoNotePath,
        'photoFinalPath': photoFinalPath,
        'location': location,
        'createdAt': createdAt.toIso8601String(),
      };

  static OrderNote fromMap(Map<String, dynamic> m) => OrderNote(
        id: m['id'] as int,
        orderNumber: m['orderNumber'] as String,
        customerName: m['customerName'] as String,
        details: m['details'] as String,
        photoNotePath: m['photoNotePath'] as String?,
        photoFinalPath: m['photoFinalPath'] as String?,
        location: m['location'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
      );
}

class AppDb {
  static final AppDb _instance = AppDb._internal();
  factory AppDb() => _instance;
  AppDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'alicia_floristas.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            orderNumber TEXT NOT NULL,
            customerName TEXT NOT NULL,
            details TEXT NOT NULL,
            photoNotePath TEXT,
            photoFinalPath TEXT,
            location TEXT,
            createdAt TEXT NOT NULL
          );
        ''');
        await db.execute('CREATE INDEX idx_orders_number ON orders(orderNumber);');
        await db.execute('CREATE INDEX idx_orders_name ON orders(customerName);');
        await db.execute('CREATE INDEX idx_orders_createdAt ON orders(createdAt);');
      },
    );
    return _db!;
  }
}
