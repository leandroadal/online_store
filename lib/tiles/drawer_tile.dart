import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.controller,
      required this.page});

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Fecha o drawer
          Navigator.of(context).pop();
          // Ir para a nova página
          controller.jumpToPage(page);
        },
        // Container para especificar a altura dos itens
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                // Utilize round() para arredondar o valor que vem do controller.page, pois é um double e o page é um int. Isso é feito se o page controller estiver na página especificada no tile
                color: controller.page!.round() == page
                    // Pinta com a cor do tema padrão
                    ? Theme.of(context).primaryColor
                    // Se não estiver na página
                    : Colors.grey[700],
              ),
              const SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: controller.page!.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
