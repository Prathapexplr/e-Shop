import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  String? _errorMessage;

  List<Product> get products => _products;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://dummyjson.com/products');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        if (extractedData['products'] is List) {
          final List<Product> loadedProducts = [];
          for (var productData in extractedData['products']) {
            loadedProducts.add(Product.fromJson(productData));
          }
          _products = loadedProducts;
          _errorMessage = null;
        } else {
          _errorMessage = 'Invalid data format received from the server.';
        }
      } else {
        _errorMessage =
            'Failed to load products. Status code: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'Error fetching products: $error';
    } finally {
      notifyListeners();
    }
  }
}
