import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/pages/login_page.dart';

import '../models/user_model.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Se o usuário estiver logado, carrega todos os pedidos associados a esse usuário
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid;
      // Quando obtém um documento é um DocumentSnapshot, enquanto que quando são obtidos mais de um documento é um QuerySnapshot
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('orders')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              children: snapshot.data!.docs
                  .map((doc) => OrderTile(orderId: doc.id))
                  .toList()
                  .reversed
                  .toList(), // método reversed para que os pedidos mais recentes fiquem no topo
            );
          }
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Faça login para acompanhar!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Abre a tela de login quando o usuário clica no botão
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
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
    }
  }
}
