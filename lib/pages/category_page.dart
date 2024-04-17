import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../datas/product_data.dart';
import '../tiles/product_tile.dart';
import '../widgets/cart_button.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;
  //final String databasePath;

  @override
  Widget build(BuildContext context) {
    // Mudar entre abas (em lista ou em grade)
    return DefaultTabController(
      length: 2, // qtd de tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(snapshot.get('title')),
          centerTitle: true,
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(icon: Icon(Icons.grid_on)),
            Tab(icon: Icon(Icons.list)),
          ]),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .doc(snapshot.reference.path)
              .collection('itens')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Mostra o circulo de carregando se não achar os dados
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              physics:
                  const NeverScrollableScrollPhysics(), // Prevenir o deslizar a tela para a lateral.
              children: [
                // Utilizar o '.builder' para carregar os dados à medida que a tela é rolada.
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  // O gridDelegate gerencia o tamanho e a posição dos itens, determinando quantos itens deseja em cada eixo
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dois itens na horizontal
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ProductData data =
                        ProductData.fromDocument(snapshot.data!.docs[index]);
                    data.category = this.snapshot.id;
                    data.categoryPath = this
                        .snapshot
                        .reference
                        .path; // Para o carrinho conseguir recuperar os produtos que tem varias categorias
                    return ProductTile(
                      type: 'grid',
                      product: data,
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ProductData data =
                        ProductData.fromDocument(snapshot.data!.docs[index]);
                    data.category = this.snapshot.id;
                    data.categoryPath = this
                        .snapshot
                        .reference
                        .path; // Para o carrinho conseguir recuperar os produtos que tem varias categorias
                    return ProductTile(
                      type: 'list',
                      product: data,
                    );
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: const CartButton(),
      ),
    );
  }
}
