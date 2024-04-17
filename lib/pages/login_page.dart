import 'package:flutter/material.dart';
import 'package:online_store/pages/signup_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          TextButton(
            onPressed: () {
              //pushReplacement" irá substituir a tela, pois quando o usuário autenticar a conta, já estará logado e não precisará fazer login novamente

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
              );
            },
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      // ScopedModelDescendant" é a maneira de acessar o modelo. Quando algo no modelo mudar, todos os elementos dentro do ScopedModelDescendant serão reconstruídos

      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text != null && (text.isEmpty || !text.contains('@'))) {
                      return 'E-mail inválido!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  decoration: const InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (text) {
                    if (text != null) {
                      if (text.isEmpty || text.length < 6) {
                        return 'Senha inválida!';
                      }
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Insira seu e-mail para a recuperação!'),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        model.recoverPass(_emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              'Confira sua caixa de entrada de e-mail!'),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Esqueci minha senha',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      // Se o formulário estiver válido, chame o método "signIn" do modelo. O método "signIn" receberá o e-mail e a senha digitados pelo usuário, bem como duas funções de retorno de chamada: "onSuccess" e "onFail". A função "onSuccess" será chamada se o login for bem-sucedido, e a função "onFail" será chamada se o login falhar.
                      if (_formKey.currentState!.validate()) {
                        // Se estiverem válidos
                        model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop(); // Sair da tela de login
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Falha ao entrar!'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
