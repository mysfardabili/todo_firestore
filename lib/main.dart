import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/add_task_page.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow Firestore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      routes: {
        '/add': (context) => const AddTaskPage(),
      },
    );
  }
}

// Mengarahkan alur aplikasi berdasarkan status autentikasi pengguna (Tugas 1)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan loading screen sementara menunggu status autentikasi Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Jika pengguna sudah login, arahkan ke HomePage
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        }

        // Jika belum login, arahkan ke AuthPage (Login & Registrasi)
        return const AuthPage();
      },
    );
  }
}
