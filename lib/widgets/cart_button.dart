import 'package:flutter/material.dart';
import 'package:online_store/pages/cart_page.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const CartPage()));
      },
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
