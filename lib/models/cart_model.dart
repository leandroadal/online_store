import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/datas/cart_product.dart';
import 'package:online_store/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  CartModel({required this.user}) {
    if (user.isLoggedIn()) {
      //carrega os itens do firebase no carrinho
      _loadCartItems();
    }
  }

  UserModel user; //usuário atual
  List<CartProduct> products = [];
  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  // Outra forma de acessar o CartModel de qualquer lugar do aplicativo é utilizando CartModel.of(context), que buscará um objeto do tipo CartModel na árvore.
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    // Decrementa a quantidade
    cartProduct.quantity = cartProduct.quantity! - 1;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap()); // Atualiza o firebase
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    // Incrementa a quantidade
    cartProduct.quantity = cartProduct.quantity! + 1;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .doc(cartProduct.cid)
        .update(cartProduct.toMap()); // Atualiza o firebase
    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity! * c.productData!.price!.toDouble();
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * (discountPercentage / 100);
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // Adicionando o pedido à coleção "orders" e obtendo uma referência para este pedido para salvá-lo no usuário posteriormente
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection('orders').add({
      'clientId': user.firebaseUser!.uid,
      // Transforma uma lista de CartProducts em uma lista de mapas
      'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice - discount + shipPrice,
      'status':
          1 //status do pedido (1) -> preparando, (2) -> enviando, (3) -> finalizado
    });

    // Salvando a referência do pedido no usuário
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('orders')
        .doc(refOrder.id)
        .set({'orderId': refOrder.id});

    // Obtendo todos os itens do carrinho
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();
    // Obtendo uma referência para cada um dos produtos no carrinho e excluindo-os.
    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear(); // Limpando lista local

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }

  void _loadCartItems() async {
    // Carregando todos os itens do carrinho
    QuerySnapshot carry = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.firebaseUser!.uid)
        .collection('cart')
        .get();
    // Converter cada documento retornado do Firebase em um CartProduct.
    products = carry.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}
