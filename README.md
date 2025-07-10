# MountTravel App 🏔️

![Framework](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter)
![Language](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android)
![Firebase](https://img.shields.io/badge/Backend-Firebase-FFCA28?style=for-the-badge&logo=firebase)

Aplikasi mobile berbasis Android untuk eksplorasi destinasi gunung, dibangun menggunakan Flutter dan terintegrasi dengan Firebase untuk layanan backend.

## Deskripsi Singkat
MountTravel adalah aplikasi mobile yang berfungsi sebagai panduan dan platform eksplorasi bagi para pecinta gunung. Pengguna dapat mendaftar, login, menjelajahi berbagai destinasi gunung, melihat informasi detail, dan mengelola profil mereka sendiri.

## Tangkapan Layar (Screenshots)

| Login & Register                                     | Explore Screen           | Detail Destinasi              | Profil Pengguna           |
| ---------------------------------------------------- | ------------------------ | ----------------------------- | ------------------------- |
| ![Login](https://github.com/Muhammad-Fatah/MountainTravelApp/blob/main/assets/Screenshot_LoginScreen.png) | ![Explore](https://github.com/Muhammad-Fatah/MountainTravelApp/blob/main/assets/Screenshot_ExploreScreen.png) | ![Detail](https://github.com/Muhammad-Fatah/MountainTravelApp/blob/main/assets/Screenshot_DestinationScreen.png) | ![Profil](https://github.com/Muhammad-Fatah/MountainTravelApp/blob/main/assets/Screenshot_ProfileScreen.png) |

## Fitur Utama
- **Autentikasi Pengguna**: Sistem pendaftaran (register) dan masuk (login) yang aman menggunakan Firebase Authentication.
- **Eksplorasi Destinasi**: Menampilkan daftar destinasi gunung yang diambil dari API.
- **Fungsi Pencarian**: Memungkinkan pengguna untuk mencari destinasi berdasarkan nama.
- **Halaman Detail**: Menyajikan informasi lengkap untuk setiap destinasi, termasuk gambar, deskripsi, dan ketinggian.
- **Manajemen Profil**: Pengguna dapat melihat dan mengedit data profil mereka yang tersimpan di Cloud Firestore.
- **UI Responsif & Dinamis**: Antarmuka yang menampilkan status *loading*, *error*, dan data kosong secara kondisional.

## Teknologi & Library
- **Framework**: Flutter
- **Bahasa**: Dart
- **Backend & Database**: Firebase (Authentication & Cloud Firestore)
- **Manajemen State**: `StatefulWidget` & `setState()`
- **Key Packages**:
    - `firebase_auth`: Untuk autentikasi pengguna.
    - `cloud_firestore`: Untuk database NoSQL.
    - `google_fonts`: Untuk kustomisasi teks.

## Setup & Instalasi
Untuk menjalankan proyek ini di lingkungan lokal, ikuti langkah-langkah berikut:

1.  **Clone Repository**
    ```bash
    git clone [https://github.com/Muhammad-Fatah/MountainTravelApp.git](https://github.com/Muhammad-Fatah/MountainTravelApp.git)
    ```
2.  **Masuk ke Direktori Proyek**
    ```bash
    cd MountainTravelApp
    ```
3.  **Install Dependencies**
    ```bash
    flutter pub get
    ```
4.  **Konfigurasi Firebase**
    Pastikan Anda sudah membuat proyek di [Firebase Console](https://console.firebase.google.com/) dan menambahkan file konfigurasi `google-services.json` ke dalam direktori `android/app/`.

5.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Pengembang
- **Nama**: Muhammad Fatah
- **GitHub**: [@Muhammad-Fatah](https'://github.com/Muhammad-Fatah)
