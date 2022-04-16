import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.showFavs,
  }) : super(key: key);

  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    
    
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //.value provider works even if data changes for the widget
        //create function would not work correctly. It can cause bugs as soon as we have more items that go beyond the screen because of the way widgets are recycled. And the provider wouldn't keep up with that.
        //.value constructor would keep up with that. So HERE .value IS BETTER APPROACH.

        // Whenever we reuse an existing object where we recycle the list of products, which already all exist, there .value approach is recommended.

// ChangeNotifierProvider no matter if we use it with the .value constuctor or not it automatically cleans up data for us when it's not required anymore. So chinta ni karni is baare mein.

        // create: (c) => products[i],
        value: products[i],
        child: const ProductItem(
            // id: products[i].id,
            // title: products[i].title,             // now we don't need to pass data like this coz we have used 'Product' as Provider
            // imageUrl: products[i].imageUrl,
            ),
      ),
    );
  }
}
