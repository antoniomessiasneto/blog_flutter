import 'package:blog_flutter/providers/userProvider.dart';
import 'package:blog_flutter/services/auth_service.dart';
import 'package:blog_flutter/services/user_service.dart';
import 'package:blog_flutter/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controladores para os campos de nome, email, senha e confirmação de senha
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  // Chave Global para o formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Função para realizar o cadastro (aqui apenas exibe uma mensagem)
  void _signUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Aqui você pode adicionar a lógica de cadastro (ex: salvar em um banco de dados)

        String name = _nameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        String role = 'editor';

        final uid = await _authService.signUp(email, password);

        final newUser = await _userService.createUser(uid, name, email, role);
        if (mounted) {
          if (newUser != null) {
            Provider.of<UserProvider>(context, listen: false)
                .setUser(newUser.id, newUser.name, newUser.role);
            Navigator.pushReplacementNamed(context, '/');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cadastro realizado com sucesso!')),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Problema ao cadastrar usuário!')),
            );
          }
          Navigator.pushNamed(context, '/');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o nome: $e')),
      );
    } finally {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastrar'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Campo de nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Digite seu nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Digite seu email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  // Validação simples de email
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de senha
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Ocultar o texto da senha
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo de confirmação de senha
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, // Ocultar o texto da senha
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  hintText: 'Digite sua senha novamente',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botão de cadastro
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Cadastrar'),
              ),

              // Link para a tela de login
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Já tem uma conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
