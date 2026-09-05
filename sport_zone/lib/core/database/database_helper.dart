import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Represents a database
class DatabaseHelper {

 /// Creates a static [Database] instance
 static Database? _database;

 /// Initializes and configures the database
 static Future<Database> initializeDatabase() async {

  /// Returns if the database has already been created
  if (_database != null) {
   return _database!;
  }

  /// Gets the database path
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'sportzone.db');

  /// Opens the database
  _database = await openDatabase(
   path,
   version: 1,
   /// Activates the foreign keys
   onConfigure: (db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
   },
   /// Creates the tables
   onCreate: (db, version) async {
    await db.execute('''
     CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      brand TEXT NOT NULL,
      barcode TEXT NOT NULL,
      description TEXT,
      price REAL NOT NULL
     );
    '''
    );

    await db.execute('''
     CREATE TABLE product_images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL,
      product_id INTEGER NOT NULL,
      FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
     );
    '''
    );

    await db.execute('''
     CREATE TABLE clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      cnpj TEXT NOT NULL,
      company_name TEXT NOT NULL,
      phone_number TEXT,
      email TEXT NOT NULL,
      street TEXT NOT NULL,
      number TEXT NOT NULL,
      city TEXT NOT NULL,
      state TEXT NOT NULL,
      zip_code TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      business_type TEXT NOT NULL
     );
    '''
    );

    await db.execute('''
     CREATE TABLE delivery_services (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      company_name TEXT NOT NULL,
      cnpj TEXT NOT NULL,
      phone_number TEXT,
      email TEXT NOT NULL,
      km_cost REAL NOT NULL,
      minimum_price REAL
     );
    '''
    );

    await db.execute('''
     CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      payment_option TEXT NOT NULL,
      installments INTEGER NOT NULL,
      price REAL NOT NULL,
      delivery_date TEXT NOT NULL,
      delivery_service_id INTEGER NOT NULL,
      client_id INTEGER NOT NULL,
      delivery_distance REAL NOT NULL,
      order_obs TEXT,
      payment_obs TEXT NOT NULL,
      FOREIGN KEY (delivery_service_id) REFERENCES delivery_services(id),
      FOREIGN KEY (client_id) REFERENCES clients(id)
     );
    '''
    );

    await db.execute('''
     CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      unit_price REAL NOT NULL,
      FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
      FOREIGN KEY (product_id) REFERENCES products(id)
     );
    '''
    );

    await db.execute('''
    CREATE TABLE store (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     name TEXT NOT NULL,
     company_name TEXT NOT NULL,
     logo_path TEXT NOT NULL,
     cnpj TEXT NOT NULL,
     street TEXT NOT NULL,
     number TEXT NOT NULL,
     city TEXT NOT NULL,
     state TEXT NOT NULL,
     zip_code TEXT NOT NULL,
    );
    ''');
   }
  );

  /// Returns the database
  return _database!;
 }
}