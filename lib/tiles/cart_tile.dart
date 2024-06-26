import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../datas/cart_product.dart';
import '../datas/product_data.dart';
import '../models/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.cartProduct});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    CartModel.of(context)
        .updatePrices(); // Quando os produtos forem carregados, será solicitado que os preços sejam atualizados no cart_price.dart, que exibe informações dos itens
    Widget buildContend() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              cartProduct.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData!.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    'Tamanho:  ${cartProduct.size}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity! > 1
                            ? () {
                                CartModel.of(context).decProduct(cartProduct);
                              }
                            : null, // Desabilita caso for menor que 1
                        icon: const Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.add),
                      ),
                      TextButton(
                        onPressed: () {
                          // Remove os itens
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[500],
                        ),
                        child: const Text('Remover'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              // Se os dados ainda não estiverem disponíveis, recarrega os itens
              future: FirebaseFirestore.instance
                  .doc(cartProduct.categoryPath!)
                  .collection('itens')
                  .doc(cartProduct.pid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Salva os dados para exibição posterior
                  cartProduct.productData =
                      ProductData.fromDocument(snapshot.data!);
                  return buildContend();
                } else {
                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
              },
            )
          // Se os dados já estiverem disponíveis, mostra os itens
          : buildContend(),
    );
  }
}
