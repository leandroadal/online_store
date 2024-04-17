import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //para acessar o formulário
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Nome Completo'),
                  validator: (text) {
                    if (text != null && text.isEmpty) {
                      return 'Nome inválido!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(hintText: 'Endereço'),
                  validator: (text) {
                    if (text != null) {
                      if (text.isEmpty) {
                        return 'Endereço inválido!';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Se o que foi digitado é valido
                        Map<String, dynamic> userData = {
                          // A senha não deve ser armazenada junto com as outras informações
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'address': _addressController.text
                        };
                        model.signUp(
                          userData: userData,
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
                      'Criar conta',
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
    // mostrar uma mensagem de sucesso e sair da tela de cadastro
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Usuário criado com sucesso!'),
      backgroundColor: Theme.of(context).primaryColor,
      duration: const Duration(seconds: 3),
    ));
    Future.delayed(const Duration(seconds: 2)).then((value) {
      //sair da tela de cadastro
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    // mostrar uma mensagem de erro
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Falha ao criar usuário!'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
