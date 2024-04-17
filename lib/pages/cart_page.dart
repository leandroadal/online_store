import 'package:flutter/material.dart';
import 'package:online_store/pages/login_page.dart';
import 'package:online_store/pages/order_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/cart_model.dart';
import '../models/user_model.dart';
import '../tiles/cart_tile.dart';
import '../widgets/cart_price.dart';
import '../widgets/discount_card.dart';
import '../widgets/ship_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int qtyP = model.products
                    .length; //quantidade de produtos que estão no carrinho
                return Text(
                  '$qtyP ${qtyP == 1 ? 'ITEM' : 'ITENS'}',
                  style: const TextStyle(fontSize: 17),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return const Center(child: CircularProgressIndicator());
            //se não estiver logado pede para fazer login para continuar
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Faça login para adicionar produtos!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            );
            // Se a lista for vazia
          } else if (model.products.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum produto no carrinho!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            //return Container();

            return ListView(
              children: [
                Column(
                  children: model.products.map((product) {
                    return CartTile(cartProduct: product);
                  }).toList(),
                ),
                const DiscountCard(),
                const ShipCard(),
                CartPrice(
                  buy: () async {
                    String? orderId = await model.finishOrder();
                    if (orderId != null) {
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OrderPage(orderId: orderId)));
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
