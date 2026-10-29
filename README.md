# 📱 TaskFlow — To-Do List Real-time Berbasis Cloud

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Cloud Firestore](https://img.shields.io/badge/Cloud%20Firestore-FFA000?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com/docs/firestore)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

Aplikasi manajemen tugas (*To-Do List*) modern berbasis cloud yang dibangun menggunakan **Flutter** dan **Firebase (Cloud Firestore & Authentication)**. Dibuat untuk memenuhi tugas **Praktikum 3 — Pemrograman Mobile**, aplikasi ini mengimplementasikan sinkronisasi data real-time, isolasi data per-pengguna, aturan keamanan (*Security Rules*), serta antarmuka pengguna (UI/UX) yang dirancang secara profesional dengan Material 3.

---

## 🌟 Fitur Unggulan

### 1. 🔐 Autentikasi Pengguna (Firebase Auth)
- Pendaftaran akun baru (*Register*) dan masuk (*Login*) menggunakan **Email & Password**.
- Manajemen state autentikasi otomatis dan reaktif via `StreamBuilder` (`authStateChanges()`).
- Fitur *show/hide password*, validasi form interaktif, dan penanganan pesan error lengkap berbahasa Indonesia.
- Tombol *Logout* aman dengan dialog konfirmasi.

### 2. 👤 Database Terisolasi Per-Pengguna (Data Privacy)
- Setiap pengguna memiliki ruang data tugas pribadi di path Firestore:
  $$\text{users/}\{uid\}\text{/tasks/}\{taskId\}$$
- Mencegah kebocoran data antar-pengguna dengan dukungan **Firestore Security Rules** yang ketat (`request.auth.uid == userId`).

### 3. ⚡ Sinkronisasi Cloud Real-time
- Operasi CRUD (*Create, Read, Update, Delete*) tersinkronisasi instan antar-perangkat menggunakan `StreamBuilder`.
- Menggunakan `FieldValue.serverTimestamp()` untuk pencatatan waktu yang konsisten dari server Google.

### 4. 🎨 Desain UI/UX Modern & Responsif (Material 3)
- **Progress Dashboard Card:** Menampilkan persentase kemajuan dan jumlah tugas yang telah diselesaikan.
- **Filter Tab Cepat:** Filter tugas instan (*Semua*, *Aktif*, *Selesai*) lengkap dengan badge counter.
- **Kartu Tugas Interaktif:** Checkbox animasi, coretan teks saat selesai, dan swipe-to-delete.
- **Empty State Estetik:** Ilustrasi dan pesan ramah saat daftar tugas kosong.

### 5. ⭐ Fitur Tambahan (Nilai Plus)
- ✏️ **Edit Tugas:** Pembaruan judul tugas, catatan detail, dan tingkat prioritas secara real-time.
- 🏷️ **Indikator Prioritas:** Pilihan prioritas tugas (*Tinggi*, *Sedang*, *Rendah*) dengan aksen warna khusus.
- 📅 **Format Waktu & Tanggal:** Konversi timestamp server menjadi format tanggal yang ramah dibaca (contoh: *29 Okt 2026 • 11:30*).

---

## 🏗️ Struktur Proyek

```plaintext
todo_firestore/
├── android/                  # Konfigurasi native Android (minSdk 24, google-services)
├── firestore.rules           # Aturan keamanan database Cloud Firestore
├── lib/
│   ├── firebase_options.dart # Konfigurasi Firebase dari FlutterFire CLI
│   ├── main.dart             # Entry point & AuthGate listener
│   ├── models/
│   │   └── task.dart         # Model data Task & serializer Firestore
│   ├── pages/
│   │   ├── add_task_page.dart # Halaman Tambah & Edit Tugas
│   │   ├── auth_page.dart     # Halaman Login & Registrasi
│   │   └── home_page.dart     # Halaman Utama Dashboard & Daftar Tugas
│   ├── services/
│   │   ├── auth_service.dart      # Service abstraksi Firebase Authentication
│   │   └── firestore_service.dart # Service operasi Cloud Firestore per-user
│   └── theme/
│       └── app_theme.dart    # Konfigurasi tema Material 3 (warna, card, input)
└── pubspec.yaml              # Dependensi proyek Flutter
```

---

## 🛡️ Aturan Keamanan Firestore (*Security Rules*)

Aturan berikut diterapkan pada Firestore Console untuk memastikan setiap pengguna hanya memiliki akses baca dan tulis pada datanya sendiri:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 🚀 Panduan Memulai (*Getting Started*)

### Prasyarat:
- [Flutter SDK](https://flutter.dev) (versi 3.20.0 atau lebih baru)
- Akun [Firebase Console](https://console.firebase.google.com)
- Perangkat Android (HP fisik atau Emulator)

### Langkah Pemasangan:

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/mysfardabili/todo_firestore.git
   cd todo_firestore
   ```

2. **Pasang seluruh dependensi:**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase:**
   Pastikan Anda sudah mengaktifkan Firebase CLI dan FlutterFire CLI, lalu jalankan:
   ```bash
   flutterfire configure
   ```

4. **Jalankan Aplikasi:**
   ```bash
   flutter run
   ```

---

## 📦 Paket yang Digunakan

| Package | Fungsi |
|---|---|
| [`firebase_core`](https://pub.dev/packages/firebase_core) | Inisialisasi koneksi aplikasi ke Firebase |
| [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) | Database dokumen real-time NoSQL |
| [`firebase_auth`](https://pub.dev/packages/firebase_auth) | Manajemen login dan pendaftaran pengguna |
| [`intl`](https://pub.dev/packages/intl) | Pemformatan tanggal dan waktu lokal |

---

## 👤 Pengembang

- **Nama:** Arbi
- **GitHub:** [@mysfardabili](https://github.com/mysfardabili)
- **Mata Kuliah:** Pemrograman Mobile (Praktikum 3 — Cloud Firestore)
- **Institusi:** Universitas Ahmad Dahlan
