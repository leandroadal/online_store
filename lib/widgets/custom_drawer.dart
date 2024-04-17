import 'package:flutter/material.dart';
import 'package:online_store/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  // posicionar em um retângulo
                  children: [
                    const Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        'Online\nStore',
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${!model.isLoggedIn() ? '' : model.userData!['name']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  } else {
                                    model.signOut();
                                  }
                                },
                                child: Text(
                                  !model.isLoggedIn()
                                      ? 'Entre ou cadastre-se >'
                                      : 'Sair',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              DrawerTile(
                icon: Icons.home,
                text: 'Início',
                controller:
                    pageController, //para controlar as páginas dentro do item
                page:
                    0, //para o tile saber qual é sua página. (Elas estarão em ordem no home_screen, iniciando no 0.)
              ),
              DrawerTile(
                icon: Icons.list,
                text: 'Produtos',
                controller: pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: 'Lojas',
                controller: pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: 'Meus Pedidos',
                controller: pageController,
                page: 3,
              ),
            ],
          )
        ],
      ),
    );
  }
}
