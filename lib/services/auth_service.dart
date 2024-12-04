import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna o usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream para monitorar o estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Função de cadastro de usuário com email e senha
  Future<String> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return signIn(email, password);
      
    } catch (e) {
      return e.toString(); // Erro
    }
  }

  // Função de login com email e senha
  Future<String> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var uid = result.user?.uid as String;
      
      return uid; // Sucesso
    } catch (e) {
      return e.toString(); // Erro
    }
  }

  // Função de logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Função para alterar a senha do usuário
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Sucesso
    } catch (e) {
      return e.toString(); // Erro
    }
  }

  // Função para verificar o estado de autenticação
  Future<bool> checkAuthStatus(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) {
      // Usuário não logado, redireciona para a tela de login
      return false;
    } else {
      // Usuário logado, redireciona para a tela inicial ou dashboard
      return true;
    }
  }
}
