import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/product_model.dart';
import 'db_provider.dart';

class ProductApiProvider {
  Future getAllProducts() async {
    var url = "https://dummyjson.com/products";
    final response = await Dio().get(url);
    ProductsModel productsModel = ProductsModel.fromJson(response.data);
    DBProvider.db.createProduct(productsModel.products!);
  }
}
