import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();

  User? _user;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    // Carregar o nome do usuário, se disponível
    if (_user != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
    if (userDoc.exists) {
      setState(() {
        _currentUserName = userDoc['name'];
        _nameController.text = _currentUserName ?? '';
      });
    }
  }

  Future<void> _updateName() async {
    try {
      if (_user != null) {
        // Atualiza o nome no Firestore
        await _firestore.collection('users').doc(_user!.uid).update({
          'name': _nameController.text,
        });

        // Atualiza o nome no Firebase Authentication
        await _user!.updateDisplayName(_nameController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nome atualizado com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o nome: $e')),
      );
    }
  }

  Future<void> _deleteUser() async {
    try {
      // Excluir o usuário no Firestore
      if (_user != null) {
        await _firestore.collection('users').doc(_user!.uid).delete();

        // Excluir o usuário no Firebase Authentication
        await _user!.delete();
        _auth.signOut();
        // Redireciona para a tela de login após excluir
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir o usuário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_user == null)
              const Center(child: Text('Você não está autenticado.'))
            else ...[
              // Nome
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 20),
              // Atualizar Nome
              ElevatedButton(
                onPressed: _updateName,
                child: const Text('Salvar alterações'),
              ),
              const SizedBox(height: 20),
              // Deletar conta
              ElevatedButton(
                onPressed: () async {
                  // Confirmação antes de excluir a conta
                  bool confirmDelete = await _showDeleteDialog();
                  if (confirmDelete) {
                    _deleteUser();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Deletar Conta'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Conta'),
          content: const Text('Tem certeza de que deseja excluir sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
