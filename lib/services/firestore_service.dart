import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan collection reference tugas untuk pengguna yang sedang aktif (Tugas 2)
  CollectionReference<Map<String, dynamic>>? get _userTasksRef {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('tasks');
  }

  // Mendengarkan daftar tugas secara real-time
  Stream<List<Task>> getTasks() {
    final ref = _userTasksRef;
    if (ref == null) {
      return Stream.value([]);
    }

    return ref
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromDoc(doc.id, doc.data())).toList());
  }

  // Menambahkan tugas baru
  Future<void> addTask(
    String title, {
    String? description,
    String priority = 'Sedang',
  }) async {
    final ref = _userTasksRef;
    if (ref == null) throw Exception('Pengguna belum terautentikasi.');

    await ref.add({
      'title': title.trim(),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      'isDone': false,
      'priority': priority,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Mengubah status selesai / belum
  Future<void> toggleDone(String id, bool value) async {
    final ref = _userTasksRef;
    if (ref == null) throw Exception('Pengguna belum terautentikasi.');

    await ref.doc(id).update({'isDone': value});
  }

  // Memperbarui judul & detail tugas (Nilai Tambahan)
  Future<void> updateTask(
    String id, {
    required String title,
    String? description,
    String priority = 'Sedang',
  }) async {
    final ref = _userTasksRef;
    if (ref == null) throw Exception('Pengguna belum terautentikasi.');

    final Map<String, dynamic> data = {
      'title': title.trim(),
      'description': description?.trim(),
      'priority': priority,
    };

    await ref.doc(id).update(data);
  }

  // Menghapus tugas
  Future<void> deleteTask(String id) async {
    final ref = _userTasksRef;
    if (ref == null) throw Exception('Pengguna belum terautentikasi.');

    await ref.doc(id).delete();
  }
}
