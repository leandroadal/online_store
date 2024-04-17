import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_store/datas/product_data.dart';

class CartProduct {
  String? cid; //cardId

  String? category;
  String? pid; //productId

  int? quantity;
  String? size;
  String? categoryPath;

  ProductData? productData;

  CartProduct();

  // Representa todos os produtos que serão armazenados no carrinho. Vai receber e converter cada produto em um CartProduct.
  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document.get('category');
    pid = document.get('pid');
    quantity = document.get('quantity');
    size = document.get('size');
    categoryPath = document.get('categoryPath');
  }

  // Transformar em mapa para armazenar no Firebase
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'categoryPath': categoryPath,
      'product': productData!
          .toResumeMap() // guarda um resumo dos produtos adicionados
    };
  }
}
