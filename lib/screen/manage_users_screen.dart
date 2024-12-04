import 'package:blog_flutter/models/usar_model.dart';
import 'package:flutter/material.dart';
import 'package:blog_flutter/services/user_service.dart';
import 'package:blog_flutter/widgets/custom_app_bar.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = UserService.getAllUsers(); // Carregar usuários
  }

  void _refreshUsers() {
    setState(() {
      _usersFuture = UserService.getAllUsers(); // Atualiza a lista de usuários
    });
  }

  void _openUserModal({User? user}) {
    final TextEditingController nameController =
        TextEditingController(text: user?.name ?? '');
    String selectedRole = user?.role ?? 'editor';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              DropdownButton<String>(
                value: selectedRole,
                items: ['admin', 'editor']
                    .map((role) => DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Atualiza usuário existente
                if (user != null) {
                  await UserService()
                      .updateUser(user.id, nameController.text, selectedRole);
                }
                _refreshUsers(); // Atualiza a lista após edição
                Navigator.of(context).pop();
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Gerenciar Usuários"),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('Papel: ${user.role}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openUserModal(user: user),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton:
          const SizedBox.shrink(), // Não há botão para criar novos usuários
    );
  }
}
