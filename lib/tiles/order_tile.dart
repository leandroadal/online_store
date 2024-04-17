import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        // StreamBuilder fica sempre observando o banco de dados para que, quando algo for alterado, reconstrua em tempo real
        child: StreamBuilder<DocumentSnapshot>(
          // Coloque .snapshots() (e não .get()), pois deseja atualizações em tempo real
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              int status = snapshot.data!.get('status');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código do pedido: ${snapshot.data!.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(_buildProductsText(snapshot.data!)),
                  const SizedBox(height: 4),
                  const Text(
                    'Status do pedido:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircle('1', 'Preparação', status, 1),
                      _line(),
                      _buildCircle('2', 'Transporte', status, 2),
                      _line(),
                      _buildCircle('3', 'Entrega', status, 3),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    // A lista de produtos em "orders" no Firebase é um LinkedHashMap
    for (LinkedHashMap p in snapshot.get('products')) {
      // Para cada um dos produtos, junte-os em uma string
      text +=
          '${p['quantity']} x ${p['product']['title']} (R\$ ${p['product']['price'].toStringAsFixed(2)})\n';
    }
    text += 'Total: R\$ ${snapshot.get('totalPrice').toStringAsFixed(2)}';
    return text;
  }

  // Linha entre os circulo do status do pedido
  Widget _line() {
    return Container(
      height: 1,
      width: 40,
      color: Colors.grey[500],
    );
  }

  // Circulo de progresso do pedido
  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color? backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: const TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        // Um widget Stack para sobrepor o texto e o círculo giratório um sobre o outro.
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = const Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
