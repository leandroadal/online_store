import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:online_store/models/cart_model.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/pages/home_page.dart';
import 'package:online_store/pages/login_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // para garantir que o ambiente do Flutter esteja pronto para o Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        // Precisa deixar claro o tipo do modelo que será usado.
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(user: model),
            child: MaterialApp(
              title: 'Shopping',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: const Color.fromARGB(255, 4, 125, 141),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(255, 4, 125, 141),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
                  centerTitle: true,
                ),
                tabBarTheme: const TabBarTheme(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          // Cor quando o botão está desabilitado
                          return Colors.grey;
                        }
                        // Cor quando o botão está habilitado
                        return const Color.fromARGB(255, 4, 125, 141);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              debugShowCheckedModeBanner: false,
              home: HomePage(),
              routes: {
                '/login': (context) => const LoginPage(),
                '/home': (context) => HomePage(),
              },
              initialRoute: '/home',
            ),
          );
        },
      ),
    );
  }
}
