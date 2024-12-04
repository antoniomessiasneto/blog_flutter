import 'package:blog_flutter/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _postsCollection =
      _firestore.collection('posts');

  // Criar um novo post
  static Future<void> createPost(Post post) async {
    await _postsCollection.add(post.toJson());
  }

  // Listar todos os posts (filtrados por userId, se necessário)
  static Future<List<Post>> getPostsByUserId(int userId) async {
    QuerySnapshot snapshot = await _postsCollection
        .where('userId', isEqualTo: userId) // Filtra os posts do usuário
        .get();

    return snapshot.docs.map((doc) {
      var postData = doc.data() as Map<String, dynamic>;
      postData['id'] = doc.id;
      return Post.fromJson(
          postData); // Criando o post a partir dos dados do Firestore
    }).toList();
  }

  // Listar todos os posts (filtrados por userId, se necessário)
  static Future<List<Post>> getPosts() async {
    try {
      var snapshot = await _postsCollection.get();
      var posts = snapshot.docs.map((post) {
        var mapData = post.data() as Map<String, dynamic>;
        mapData['id'] = post.id;
        return Post.fromJson(mapData);
      }).toList();

      return posts;
    } catch (e) {
      print('Erro ao carregar posts: $e');
      return [];
    }
  }

  static Future<Post?> getPostById(String postId) async {
    try {
      final post = await _firestore.collection('posts').doc(postId).get();

      if (post.exists) {
        return Post.fromJson(
            post.data()!); // Retorna o usuário como objeto User
      } else {
        print("Post não encontrado no Firestore");
        return null;
      }
    } catch (e) {
      print("Erro ao recuperar Post: $e");
      return null;
    }
  }

  // Atualizar um post existente
  static Future<void> updatePost(Post post) async {
    await _postsCollection.doc(post.id).update(post.toJson());
  }

  // Deletar um post
  static Future<void> deletePost(String postId) async {
    await _postsCollection.doc(postId.toString()).delete();
  }
}
