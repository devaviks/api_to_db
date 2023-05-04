import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/product_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Product table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'productmanager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Product1('
              'id INTEGER PRIMARY KEY,'
              'title TEXT,'
              'description TEXT,'
              'price INTEGER,'
              'discountPercentage DOUBLE,'
              'rating DOUBLE,'
              'stock INTEGER,'
              'brand TEXT,'
              'category TEXT,'
              'thumbnail TEXT'
              ')');
        });
  }

  // Insert employee on database
  createProduct(List<Products> newProduct) async {
    await deleteAllProducts();
    //Products newProduct1;
    final db = await database;
    for (int i = 0; i < newProduct.length; i++) {
     final res = await db?.insert('Product1', newProduct[i].toJson());
      //  await db?.rawInsert('INSERT INTO Product1 (id, title, description, price,discountPercentage,rating,stock,brand,category,thumbnail)'
      //     ' VALUES ($i, $newProduct[$i], "sad", "dasd","sdsa","sdsdwe","wqe","dsf","dfs","dfs")');
    }
    }


  // Delete all employees
  Future<int?> deleteAllProducts() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM Product1');

    return res;
  }

  Future<List<Products>?> getAllProducts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM Product1");
    List<Products>? list =
    res!.isNotEmpty ? res.map((c) => Products.fromJson(c)).toList() : [];
    return list;
  }
}
