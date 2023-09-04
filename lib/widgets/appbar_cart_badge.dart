import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/cartScreen/cart_screen.dart';

// ignore: must_be_immutable
class AppBarWithCartBadge extends StatefulWidget
    implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? sellersUID;

  AppBarWithCartBadge({super.key, this.preferredSizeWidget, this.sellersUID});
  @override
  State<AppBarWithCartBadge> createState() => _AppBarWithCartBadgeState();

  @override
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppBarWithCartBadgeState extends State<AppBarWithCartBadge> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.purpleAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
          ),
        ),
      ),
      automaticallyImplyLeading: true,
      title: const Text(
        "iShop",
        style: TextStyle(
          fontSize: 26,
          letterSpacing: 3,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                int itemsInCart =
                    Provider.of<CartItemCounter>(context, listen: false).count;
                if (itemsInCart == 0) {
                  Fluttertoast.showToast(
                      msg:
                          "Cart is empty. Please first add some items to cart.");
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => CartScreen(
                                sellerUID: widget.sellersUID,
                              )));
                }
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.deepPurpleAccent,
                  ),
                  Positioned(
                    top: 2,
                    right: 6,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                          builder: (context, counter, c) {
                        return Text(
                          counter.count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
