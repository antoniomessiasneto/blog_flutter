import 'package:blog_flutter/models/post_model.dart';
import 'package:blog_flutter/services/post_service.dart';
import 'package:blog_flutter/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home'),
      body: FutureBuilder<List<Post>>(
        future:
            PostService.getPosts(), // Agora, você passa o Future diretamente
        builder: (context, snapshot) {
          // Verificando o estado de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Mostra o carregando
          }
          // Verificando se ocorreu algum erro
          else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar posts: ${snapshot.error}'));
          }
          // Verificando se há dados
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado.'));
          }

          // Pegando a lista de posts
          final posts = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Banner (primeiro post)
                Container(
                  margin: const EdgeInsets.all(8.0),
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          posts[0].photoUrl), // Usando o primeiro post
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: TextButton(
                        onPressed: () {
                          // Navegar para a página de detalhes do post
                          Navigator.pushNamed(context, '/post/${posts[0].id}');
                        },
                        child: Text(
                          posts[0]
                              .title, // Exibindo a descrição do primeiro post
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),

                // Posts menores
                ListView.builder(
                  itemCount: posts.length -
                      1, // Excluindo o primeiro post (já usado no banner)
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = posts[index + 1]; // Usando os posts restantes
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          // Imagem do post
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              post.photoUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Título e descrição
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      // Navegar para a página de detalhes do post
                                      Navigator.pushNamed(
                                          context, '/post/${post.id}');
                                    },
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                const SizedBox(height: 4),
                                Text(
                                  post.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Botão de detalhes
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              // Navegar para a página de detalhes do post
                              Navigator.pushNamed(context, '/post/${post.id}');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
