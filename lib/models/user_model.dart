import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;
  User?
      currentUser; // Variável para manter o usuário logado ao sair do aplicativo.
  Map<String, dynamic>? userData = {};

  bool isLoading = false;

  // Outra forma de acessar o UserModel de qualquer lugar do aplicativo é utilizando UserModel.of(context)
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  // Quando o aplicativo é aberto, isso é acionado
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  // voidCallback é uma função que iremos passar e invocar de dentro da nossa função signUp
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    // Criando o usuário
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((user) async {
      firebaseUser = user.user;
      // Salvando os dados do usuário no Firebase, pois ao criar o usuário, apenas o nome de usuário e a senha são salvos automaticamente. Os outros dados devem ser salvos manualmente.
      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      // Se houver algum erro
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners(); // Indica que algo foi modificado no modelo e que a tela precisa ser atualizada

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user.user;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = {}; // apaga os dados locais do usuário
    firebaseUser = null;
    notifyListeners();
  }

  // Enviar um e-mail com um link para redefinição de senha
  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    // Quando o usuário atual for diferente de null, retorna true para indicar que esta
    User? usuarioLogado = _auth.currentUser;
    return usuarioLogado != null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  Future<void> _loadCurrentUser() async {
    // Se o firebaseUser for nulo, busca o usuário atual
    firebaseUser ??= _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .get();
      userData = docUser.data.call();
    }
    notifyListeners();
  }
}
