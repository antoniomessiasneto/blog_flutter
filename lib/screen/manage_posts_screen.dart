import 'package:blog_flutter/models/post_model.dart';
import 'package:blog_flutter/services/post_service.dart';
import 'package:blog_flutter/widgets/custom_app_bar.dart';
import 'package:blog_flutter/widgets/post_modal.dart';
import 'package:flutter/material.dart';

class ManagePostsScreen extends StatefulWidget {
  const ManagePostsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManagePostsScreenState createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService.getPosts();
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = PostService.getPosts();
    });
  }

  void _deletePost(String postId) async {
    await PostService.deletePost(postId);
    _refreshPosts(); // Atualiza a lista após a exclusão
  }

  void _openPostModal({Post? post}) {
    final TextEditingController titleController =
        TextEditingController(text: post?.title ?? '');
    final TextEditingController contentController =
        TextEditingController(text: post?.content ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: post?.description ?? '');
    final TextEditingController photoController =
        TextEditingController(text: post?.photoUrl ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PostModal(
          titleController: titleController,
          contentController: contentController,
          descriptionController: descriptionController,
          photoController: photoController,
          isEditing: post != null,
          postId: post?.id,
        );
      },
    ).then((_) => _refreshPosts()); // Atualiza a lista após criar ou editar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Gerenciar Posts"),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar posts'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openPostModal(post: post),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePost(post.id as String),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPostModal(), // Criação de um novo post
        child: const Icon(Icons.add),
      ),
    );
  }
}
