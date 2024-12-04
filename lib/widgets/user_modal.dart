import 'package:flutter/material.dart';
import 'package:blog_flutter/services/user_service.dart';

class UserModal extends StatelessWidget {
  final TextEditingController nameController;
  final String userId;
  final String initialRole;

  const UserModal({
    super.key,
    required this.nameController,
    required this.userId,
    required this.initialRole,
  });

  @override
  Widget build(BuildContext context) {
    String selectedRole = initialRole;

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
              selectedRole = newRole!;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            // Atualizar o usuário com as novas informações
            await UserService()
                .updateUser(userId, nameController.text, selectedRole);
            Navigator.pop(context);
          },
          child: const Text('Salvar Alterações'),
        ),
      ],
    );
  }
}
