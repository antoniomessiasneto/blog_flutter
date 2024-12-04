import 'package:flutter/material.dart';
import 'package:blog_flutter/models/post_model.dart';
import 'package:blog_flutter/services/post_service.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId; // O post será passado como argumento

  // Construtor
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post?>(
      future: PostService.getPostById(
          postId), // Aqui é onde você passa o Future<Post?>
      builder: (context, snapshot) {
        // Verificando o estado de carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Exibe o carregando
        }
        // Verificando se ocorreu algum erro
        else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar o post: ${snapshot.error}'));
        }
        // Verificando se o post existe
        else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Post não encontrado.'));
        }

        // Pegando o post
        final post = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(post.title), // Exibe o título do post na AppBar
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Se o post tiver uma imagem, exibimos a foto
                  if (post.photoUrl.isNotEmpty)
                    Image.network(post.photoUrl), // Exibe a foto do post

                  const SizedBox(height: 16),

                  // Título do post
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Descrição do post
                  Text(
                    post.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Conteúdo completo do post
                  Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informações sobre o autor e a data
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Autor: ${post.author}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Publicado em: ${post.date.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão de voltar
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Voltar para a tela anterior
                      },
                      child: const Text('Voltar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
