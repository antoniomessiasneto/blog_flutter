import 'package:blog_flutter/firebase_options.dart';
import 'package:blog_flutter/providers/userProvider.dart';
import 'package:blog_flutter/screen/home_screen.dart';
import 'package:blog_flutter/screen/manage_posts_screen.dart';
import 'package:blog_flutter/screen/manage_users_screen.dart';
import 'package:blog_flutter/screen/post_detail_screen.dart';
import 'package:blog_flutter/screen/sign_up_screen.dart';
import 'package:blog_flutter/screens/edit_screen.dart';
import 'package:blog_flutter/widgets/redirect.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blog_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options:
            DefaultFirebaseOptions.currentPlatform); // Inicialize o Firebase
    runApp(
        // Aqui, estchabamos envolvendo o aplicativo com o Provider
        ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ));
  } catch (e) {
    print('Error inicializando Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    bool isLoggedin = userProvider.getUser() != null ? true : false;
    bool isAdmin = userProvider.getUser()?.role == null
        ? false
        : userProvider.getUser()?.role == "admin"
            ? true
            : false;

    return MaterialApp(
        title: 'Blog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/post/') == true) {
            final postId = settings.name!
                .substring(6); // Extract the post ID from the route
            return MaterialPageRoute(
              builder: (context) => PostDetailScreen(postId: postId),
            );
          }
          return null;
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) =>
              !isLoggedin ? const LoginScreen() : const Redirect(),
          '/sign_up': (context) =>
              !isLoggedin ? const SignUpScreen() : const Redirect(),
          '/manager_users': (context) => isLoggedin && isAdmin
              ? const ManageUsersScreen()
              : const Redirect(),
          '/manage_posts': (context) =>
              isLoggedin ? const ManagePostsScreen() : const Redirect(),
          '/edit_profile': (context) =>
              isLoggedin ? const EditProfileScreen() : const Redirect(),
        });
  }
}
