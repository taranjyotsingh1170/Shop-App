import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/auth.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = '/order-screen';

  
  //var _isLoading = true;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  // WE USED FutureBuilder INSTEAD OF initState.

  Future<void> _refreshOrders(BuildContext context) async {
    final authData = Provider.of<Auth>(context, listen: false);
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders(authData.token, authData.userId);
  }

  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);  // If we use this, we would enter an infinite loop and everything will rebuild again and again.
    // Instead we would use Consumer on ListView below in widget tree.


final authData = Provider.of<Auth>(context);
    //print('Building Orders');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(authData.token, authData.userId),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshOrders(context),
              child: Consumer<Orders>(
                builder: (ctx, ordersData, child) => ListView.builder(
                  itemCount: ordersData.orders.length,
                  itemBuilder: (_, i) => OrderItem(order: ordersData.orders[i]),
                ),
              ),
            );
          }
        },
      ),
      // body: _isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //       onRefresh: ()=> _refreshOrders(context),
      //       child: ListView.builder(
      //           itemCount: ordersData.orders.length,
      //           itemBuilder: (_, i) => OrderItem(order: ordersData.orders[i]),
      //         ),
      //     ),
    );
  }
}
