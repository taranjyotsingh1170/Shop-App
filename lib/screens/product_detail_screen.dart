import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  //Normal route -
  // const ProductDetailScreen({Key? key, required this.title}) : super(key: key);
  // final String title;

  //Named route -
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments
        as String; // give us the id of the product

    // Now to extract all data from the id we need central state management solution than just always passing data through constructors
    // final loadedProduct = Provider.of<Products>(context)
    //     .items                                                                 // it is one way of getting products by id
    //     .firstWhere((prod) => prod.id == productId);

    // * 2nd way

    final loadedProduct = Provider.of<Products>(
      context,
      listen:
          false, //we set this to false because we don't want this widget to rebuild when data changes in 'Products()'.
    ).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),  // Commented because we are now using CustomScrollView
      // ),
      body: CustomScrollView(
        // Earlier SingleChildScrollView was used
        // slivers are just scrollable areas on the screen
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // SliverList is a listView as a part of multiple slivers
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 800,),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 300,
        //       width: double.infinity,
        //       child: Hero(
        //   tag: loadedProduct.id,
        //   child: Image.network(
        //     loadedProduct.imageUrl,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
