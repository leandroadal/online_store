import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key, required this.collectionPath});

  final CollectionReference<Map<String, dynamic>> collectionPath;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: collectionPath.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
              // Para cada documento, cada um se torna um CategoryTile, e então todos os CategoryTile são transformados em uma lista
              tiles: snapshot.data!.docs.map((doc) {
                return CategoryTile(snapshot: doc);
              }).toList(),
              color: Colors.grey[500],
            ).toList();
            return ListView(
              children: dividedTiles,
            );
          }
        });
  }
}
