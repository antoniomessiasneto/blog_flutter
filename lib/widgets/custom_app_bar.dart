import 'package:blog_flutter/providers/userProvider.dart';
import 'package:blog_flutter/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final auth = AuthService();
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: [
        // Ícone de Menu para navegação
        PopupMenuButton<String>(
          onSelected: (value) async {
            // Navegar para a tela baseada na opção selecionada
            if (value == 'home') {
              Navigator.pushNamed(context, '/');
            } else if (value == 'login') {
              Navigator.pushNamed(context, '/login');
            } else if (value == 'manage_posts') {
              Navigator.pushNamed(context, '/manage_posts');
            } else if (value == 'edit_profile') {
              Navigator.pushNamed(context, '/edit_profile');
            } else if (value == 'logout') {
              await auth.signOut();
              userProvider.clearUser();
              Navigator.pushNamed(context, '/');
            } else if (value == 'manager_users') {
              Navigator.pushNamed(context, '/manager_users');
            }
          },
          itemBuilder: (BuildContext context) {
            // Itens públicos: Home e Login
            List<PopupMenuEntry<String>> menuItems = [
              const PopupMenuItem(
                value: 'home',
                child: Row(
                  children: [
                    Icon(Icons.home),
                    SizedBox(width: 10),
                    Text('Home'),
                  ],
                ),
              ),
            ];
            if (userProvider.getUser() != null) {
              // Itens para editor: Home, Gerenciar Posts, Editar Perfil, Logout
              if (userProvider.getUser()!.role == 'editor' ||
                  userProvider.getUser()!.role == 'admin') {
                menuItems.addAll([
                  const PopupMenuItem(
                    value: 'manage_posts',
                    child: Row(
                      children: [
                        Icon(Icons.post_add),
                        SizedBox(width: 10),
                        Text('Gerenciar Posts'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit_profile',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text('Editar Perfil'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ]);
                if (userProvider.getUser()!.role == 'admin') {
                  menuItems.add(
                    const PopupMenuItem(
                      value: 'manager_users',
                      child: Row(
                        children: [
                          Icon(Icons.group),
                          SizedBox(width: 10),
                          Text('Gerenciar Usuários'),
                        ],
                      ),
                    ),
                  );
                }
              }

              // Itens para admin: todos os itens de editor + Gerenciar Usuários
            } else {
              menuItems.add(const PopupMenuItem(
                value: 'login',
                child: Row(
                  children: [
                    Icon(Icons.account_circle),
                    SizedBox(width: 10),
                    Text('Login'),
                  ],
                ),
              ));
            }

            return menuItems;
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Tamanho do AppBar
}
