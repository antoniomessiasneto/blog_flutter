import 'package:blog_flutter/models/usar_model.dart';
import 'package:blog_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final AuthService _auth = AuthService();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Criação de um novo usuário no Firebase Authentication e Firestore
  Future<User?> createUser(
      String uid, String name, String email, String role) async {
    try {
      // Cria um novo objeto User

      final newUser = User(
        // Usando o 'User' da sua classe definida
        id: uid,
        name: name,
        email: email,
        role: role,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toJson());
      return newUser;
    } catch (e) {
      print("Erro ao criar usuário: $e");
      return null;
    }
  }

  // Recupera o usuário do Firestore com base no UID
  Future<User?> getUserById(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return User.fromJson(
            userDoc.data()!); // Retorna o usuário como objeto User
      } else {
        print("Usuário não encontrado no Firestore");
        return null;
      }
    } catch (e) {
      print("Erro ao recuperar usuário: $e");
      return null;
    }
  }

  static Future<List<User>> getAllUsers() async {
    try {
      // Obtém todos os documentos da coleção 'users'
      final querySnapshot = await _firestore.collection('users').get();

      // Verifica se existem documentos
      if (querySnapshot.docs.isNotEmpty) {
        // Mapeia todos os documentos para uma lista de usuários
        return querySnapshot.docs.map((doc) {
          var mapData = doc.data();
          mapData['id'] = doc.id;
          return User.fromJson(
              mapData); // Converte os dados do documento em um objeto User
        }).toList();
      } else {
        print("Nenhum usuário encontrado no Firestore.");
        return []; // Retorna uma lista vazia se não encontrar usuários
      }
    } catch (e) {
      print("Erro ao recuperar usuários: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Atualiza as informações de um usuário no Firestore
  Future<void> updateUser(String uid, String name, String role) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);

      final updatedData = <String, dynamic>{};

      updatedData['name'] = name;
      updatedData['role'] = role;

      await userRef.update(updatedData);
      print("Usuário atualizado com sucesso.");
    } catch (e) {
      print("Erro ao atualizar usuário: $e");
    }
  }

  // Deleta o usuário do Firestore e Firebase Authentication
  Future<void> deleteUser(String uid) async {
    try {
      // Exclui o usuário do Firestore

      await _firestore.collection('users').doc(uid).delete();

      // Exclui o usuário do Firebase Authentication
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }

      print("Usuário excluído com sucesso.");
    } catch (e) {
      print("Erro ao excluir usuário: $e");
    }
  }

  // Recupera o usuário autenticado atualmente
  Future<User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        return await getUserById(user.uid);
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao obter o usuário atual: $e");
      return null;
    }
  }
}
