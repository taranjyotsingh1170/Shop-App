import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../providers/auth.dart';
import './helpers/custom_route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // ChangeNotifierProxyProvider is a generic class so we should add '<>'.
        //It allows us to set a provider which itself depends on the provider
        //which was defined before this one.
        ChangeNotifierProvider(
          create: (_) => Products(
              // Provider.of<Auth>(_, listen: false).token,
              // Provider.of<Products>(_, listen: false).items,
              ),
          // update: (ctx, auth, previousProducts) => Products(
          //     auth.token,
          //     previousProducts == null
          //         ? []
          //         : previousProducts
          //             .items), // Products() is the instance of the Products class
          //Here create method is better approach coz whenever we instantiate a class , if we do that to provide that object to the changeNotifierProvider we should use create method for efficiancy and to avoid bugs.
          lazy: false,
          // builder: (ctx, products) => Products(
          //   Provider.of<Auth>(ctx, listen: false).token,
          //   Provider.of<Products>(ctx, listen: false).items,
          // ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(
              // Provider.of<Auth>(ctx, listen: false).token,
              // Provider.of<Orders>(ctx, listen: false).orders,
              ),
          // lazy: false,
          // update: (ctx, auth, previousOrders) => Orders(
          //   auth.token,
          //   previousOrders == null ? [] : previousOrders.orders,
          // ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            secondaryHeaderColor: Colors.orangeAccent,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),

            }),
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Shop'),
//       ),
//       body: const Center(
//         child: Text('Let\'s build a shop!'),
//       ),
//     );
//   }
// }

//NOTE: When we move to a completely new screen using pushReplacement then it's important that we clean up the provided data.
// Flutter automatically for us cleans all the widgets it build so that they don't take up space in memory anymore.
// But our provided data will still be there in memory. That's bad coz the more often we visit or leave that page our data is stored in memory and that leads to MEMORY LEAKS.
// MEMORY LEAKS - Our memory may overflow at some point.
// So it's important that we dispose off the data we are using.
// ChangeNotifierProvider no matter if we use it with the .value constuctor or not it automatically cleans up that data for us when it's not required anymore. So chinta ni karni is baare mein.
