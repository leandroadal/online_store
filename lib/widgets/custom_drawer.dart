import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_store/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      bottom: -4,
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
              //const Divider(),
              /*
              DrawerTile(
                icon: Icons.info_outline,
                text: 'Sobre',
                controller: pageController,
                page: 4, // Adicione uma nova página para a seção 'Sobre'
              ),
              */
              /*
              DrawerTile(
                icon: Icons.settings,
                text: 'Configurações',
                controller: pageController,
                page: 5,
              ),
              */
              //const Divider(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 30, bottom: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Versão 0.10 (1337)\n© 2024 by Leandro Silva. Ícones por ',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Icons8',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse('https://www.icons8.com'));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
