import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/tabs/home_tab.dart';
import 'package:online_store/tabs/orders_tab.dart';
import 'package:online_store/tabs/places_tab.dart';
import 'package:online_store/tabs/products_tab.dart';

import '../widgets/cart_button.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        Scaffold(
          extendBody: true,
          body: const HomeTab(),
          drawer: CustomDrawer(
            pageController: _pageController,
          ),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Produtos',
            ),
          ),
          body: ProductsTab(
              collectionPath:
                  FirebaseFirestore.instance.collection('products')),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lojas',
            ),
          ),
          body: const PlacesTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Meus Pedidos',
            ),
          ),
          body: const OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController),
        ),
      ],
    );
  }
}
