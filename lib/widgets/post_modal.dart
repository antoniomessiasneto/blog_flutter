import 'package:blog_flutter/models/post_model.dart';
import 'package:blog_flutter/providers/userProvider.dart';
import 'package:blog_flutter/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController photoController;
  final TextEditingController descriptionController;
  final bool isEditing;
  final String? postId;

  const PostModal({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.isEditing,
    required this.postId,
    required this.photoController,
    required this.descriptionController,
  });

  // Função que salva ou atualiza o post
  void _savePost(BuildContext context, String userId, String author) async {
    final title = titleController.text;
    final content = contentController.text;
    final photoUrl = photoController.text;
    final description = descriptionController.text;
    if (title.isNotEmpty &&
        photoUrl.isNotEmpty &&
        content.isNotEmpty &&
        description.isNotEmpty) {
      // Criar um novo post com os dados dos controladores
      final post = Post(
        title: title,
        content: content,
        userId: userId,
        description: description,
        photoUrl: photoUrl,
        author: author,
        date: DateTime.now(),
        id: postId,
      );

      try {
        // Se estamos editando, chamamos o método de atualização, senão chamamos o de criação
        if (isEditing && postId != null) {
          await PostService.updatePost(post); // Atualiza o post no Firestore
        } else {
          await PostService.createPost(post); // Cria o novo post no Firestore
        }

        Navigator.pop(context); // Fecha o modal após salvar
      } catch (e) {
        // Exibe erro, se houver falha ao salvar ou atualizar o post
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar o post: $e')),
        );
      }
    } else {
      // Exibe erro se algum campo obrigatório estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return AlertDialog(
      title: Text(isEditing ? 'Editar Post' : 'Criar Post'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Conteúdo'),
              maxLines: 5,
            ),
            TextField(
              controller: photoController,
              decoration: const InputDecoration(labelText: 'URL da Foto'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Fechar o modal
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            var id = userProvider.getUser()?.id;
            var name = userProvider.getUser()?.name;
            _savePost(context, id!, name!);
          }, // Salvar ou atualizar o post
          child: Text(isEditing ? 'Salvar Alterações' : 'Criar Post'),
        ),
      ],
    );
  }
}
