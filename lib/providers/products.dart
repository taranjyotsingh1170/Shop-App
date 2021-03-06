// ignore_for_file: use_rethrow_when_possible

import 'dart:convert'; // Using to convert Product data to json in addProduct method.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // change notifier is related to inherited widget which provider package uses behind the scenes

  // we wanna define list of products here. So we will import 'product' model and we will store the list in Products class

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // final String authToken;

  // Products(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts(String authToken, String userId, [bool filterByUsers = false]) async {
    final filterString = filterByUsers ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://taran-750ab-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url =
          'https://taran-750ab-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            //isFavorite: prodData['isFavorite'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }

  Future<void> addProduct(Product product, String authToken, String userId) async {
    final url =
        'https://taran-750ab-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId' : userId,
          //'isFavorite': product.isFavorite,
        }),
      );

      //print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        title: product.title,
        imageUrl: product.imageUrl,
        price: product.price,
      );

      _items.add(newProduct);
      //print(newProduct.id);

      // _items.insert(0, newProduct);  // to add the product at the beginning of the list

      notifyListeners();
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  // Future<void> addProduct(Product product) {
  //   const url = 'https://taran-750ab-default-rtdb.firebaseio.com/products.json';
  //   return http
  //       .post(
  //     Uri.parse(url),
  //     body: json.encode({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUrl': product.imageUrl,
  //       'price': product.price,
  //       'isFavorite': product.isFavorite,
  //     }),
  //   )
  //       .then((response) {
  //     //print(json.decode(response.body));
  //     final newProduct = Product(
  //       id: json.decode(response.body)['name'],
  //       description: product.description,
  //       title: product.title,
  //       imageUrl: product.imageUrl,
  //       price: product.price,
  //     );
  //     _items.add(newProduct);
  //     //print(newProduct.id);
  //     // _items.insert(0, newProduct);  // to add the product at the beginning of the list
  //     notifyListeners();
  //   }).catchError((error) {
  //     print(error);
  //     throw error;
  //   });
  // }

  Future<void> updateProduct(
      String id, Product newProduct, String authToken) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    // It will give us the product Index and we would need that index to then replace that item with the new product

    final url =
        'https://taran-750ab-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    if (prodIndex >= 0) {
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // print('...');
    }
  }

  Future<void> deleteProduct(String id, String authToken) async {
    final url =
        'https://taran-750ab-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    //_items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  // void deleteProduct(String id) {
  //   final url = 'https://taran-750ab-default-rtdb.firebaseio.com/products/$id';
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  //   http.delete(Uri.parse(url)).then((response) {
  //     if (response.statusCode >= 400) {
  //       throw HttpException('Could not delete product.');
  //     }
  //   }).catchError((_) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //   });
  //   //_items.removeWhere((prod) => prod.id == id);
  //   notifyListeners();
  // }
}
