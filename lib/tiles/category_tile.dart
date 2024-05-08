import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/tabs/products_tab.dart';

import '../pages/category_page.dart';
import '../widgets/cart_button.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.snapshot});

  // Obtém o documento da categoria
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // "leading" é a parte que fica no início
      leading: SizedBox(
        width: 50, // Define o tamanho do ClipOval
        height: 50,
        child: Image.network(
          snapshot.get('icon'),
          fit: BoxFit.scaleDown, // Ajusta a imagem para cobrir toda a área
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.error,
            color: Colors.red,
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      title: Text(snapshot.get('title')),
      // trailing é a parte que fica no final
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        // Navega para a tela CategoryScreen passando o snapshot (documento)
        bool hasCategory = snapshot.get('hasSubCategory');
        if (hasCategory) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Tipos'),
                ),
                body: ProductsTab(
                  // Transfere a coleção de tipos da categoria selecionada
                  collectionPath: snapshot.reference.collection('tipos'),
                ),
                floatingActionButton: const CartButton(),
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryPage(snapshot: snapshot),
            ),
          );
        }
      },
    );
  }
}
