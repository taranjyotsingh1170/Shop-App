import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  }) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    //Case - when we only wanna run a subpart of the tree when some data changes. SO we wrap just that subpart of that widget tree that depends on our product data with that listener.
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            // Used between 2 diff screens
            tag: product.id, // It can be any tag but should be unique
            child: FadeInImage(
              //child: Image.network(product.imageUrl, fit: BoxFit.cover)
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            // Only here we listens to changes now keeping 'listen: false' in of(). Consumer always listens to changes.
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
                // print(product.title);
                // print(product.isFavorite);
              },
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);

              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: const Text('Added item to cart!'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );

    //-------------------OR----------------------------------------------------

    //final product = Provider.of<Product>(context);    //Using provider.of() whole build method reruns whenever the data changes
    // return Consumer<Product>(
    //   builder: (ctx, product, child) => ClipRRect(
    //     borderRadius: BorderRadius.circular(10),
    //     child: GridTile(
    //       child: GestureDetector(
    //         child: Image.network(product.imageUrl, fit: BoxFit.cover),
    //         onTap: () {
    //           Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
    //               arguments: product.id);
    //         },
    //       ),
    //       footer: GridTileBar(
    //         leading: IconButton(
    //           onPressed: () {
    //             product.toggleFavoriteStatus();
    //           },
    //           icon: Icon(
    //             product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //           ),
    //           color: Theme.of(context).secondaryHeaderColor,
    //         ),
    //         backgroundColor: Colors.black54,
    //         title: Text(
    //           product.title,
    //           textAlign: TextAlign.left,
    //           overflow: TextOverflow.fade,
    //         ),
    //         trailing: IconButton(
    //           icon: const Icon(Icons.shopping_cart),
    //           onPressed: () {},
    //           color: Theme.of(context).secondaryHeaderColor,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // ---------------------OR------------------------

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       child: Image.network(product.imageUrl, fit: BoxFit.cover),
    //       onTap: () {
    //         Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
    //             arguments: product.id);

    //         //simple pushing
    //         // Navigator.of(context).push(
    //         //   MaterialPageRoute(builder: (ctx) => ProductDetailScreen(title: title),),
    //         // );
    //       },
    //     ),
    //     footer: GridTileBar(
    //       leading: IconButton(
    //         onPressed: () {
    //           product.toggleFavoriteStatus();
    //         },
    //         icon: Icon(
    //           product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //         ),
    //         color: Theme.of(context).secondaryHeaderColor,
    //       ),
    //       backgroundColor: Colors.black54,
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.left,
    //         overflow: TextOverflow.fade,
    //       ),
    //       trailing: IconButton(
    //         icon: const Icon(Icons.shopping_cart),
    //         onPressed: () {},
    //         color: Theme.of(context).secondaryHeaderColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
