import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getFriendlyErrorMessage(e.code, e.message);
    } catch (e) {
      throw 'Terjadi kesalahan tidak terduga. Silakan coba lagi.';
    }
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getFriendlyErrorMessage(e.code, e.message);
    } catch (e) {
      throw 'Gagal mendaftar. Silakan coba lagi.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _getFriendlyErrorMessage(String code, String? fallback) {
    switch (code) {
      case 'user-not-found':
        return 'Akun dengan email ini tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi yang Anda masukkan salah.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau langsung masuk.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa jaringan Anda.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Silakan tunggu beberapa saat.';
      case 'operation-not-allowed':
        return 'Metode login Email/Password belum diaktifkan di Firebase Console.';
      default:
        return fallback ?? 'Terjadi kesalahan pada autentikasi ($code).';
    }
  }
}

