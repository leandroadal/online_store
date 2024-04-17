import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online_store/pages/cart_page.dart';
import 'package:online_store/pages/login_page.dart';

import '../datas/cart_product.dart';
import '../datas/product_data.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});

  final ProductData product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? size;
  int current = 0;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.product.title!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: CarouselSlider(
                carouselController: carouselController, // Gerencia o carrossel
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true, // Automatizar a rolagem das imagens
                  aspectRatio: 1.0,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  onPageChanged: (index, reason) {
                    setState(() {
                      current =
                          index; // Exibir a posição atual no conjunto de imagens
                    });
                  },
                ),
                items: widget.product.images!.map((e) {
                  return Image.network(e, fit: BoxFit.cover);
                }).toList()),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.images!.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          //
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.product.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  'R\$ ${widget.product.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal, //orientação da grid
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.5),
                    children: widget.product.sizes!.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: size == s ? primaryColor : Colors.grey,
                              width: 3,
                            ),
                          ),
                          width: 50,
                          alignment:
                              Alignment.center, // Alinhar o conteúdo interno
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: size !=
                            null // Se for diferente de nulo habilita o botão
                        ? () {
                            // Se o usuário estiver logado, adiciona ao carrinho
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = widget.product.id;
                              cartProduct.category = widget.product.category;
                              cartProduct.productData = widget.product;
                              cartProduct.categoryPath = widget.product
                                  .categoryPath; // para o carinho saber onde procurar

                              CartModel.of(context).addCartItem(cartProduct);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const CartPage()),
                              );
                            } else {
                              // Caso contrário, abrir a tela para o usuário fazer login
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? 'Adicionar ao carrinho'
                          : 'Entre para comprar',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.product.description!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
