# DCC Mobile (Dinus Career Center)

DCC Mobile adalah aplikasi mobile resmi Dinus Career Center (UDINUS) yang dirancang untuk membantu mahasiswa dan alumni dalam menavigasi karir mereka. Aplikasi ini menyediakan akses mudah ke lowongan pekerjaan, pelacakan lamaran, event pengembangan karir, dan manajemen profil profesional.

## 🚀 Fitur Utama

- **Beranda (Home):** Ringkasan aktivitas, rekomendasi loker terbaru, dan event mendatang.
- **Lowongan Kerja (Job):** Pencarian dan filter lowongan kerja (Full-time, Magang, Part-time) dengan fitur simpan (bookmark).
- **Pelacakan (Track):** Memantau status lamaran kerja secara real-time dari tahap verifikasi hingga selesai.
- **Event:** Informasi seminar, webinar, dan workshop karir lengkap dengan detail pendaftaran dan pembicara.
- **Profil (Profile):** Manajemen Curriculum Vitae (CV), keahlian (tech stack), pengalaman kerja, dan pendidikan.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (v3.x)
- **State Management:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc) (v9.1.1)
- **Concurrency & Equality:** [Equatable](https://pub.dev/packages/equatable)
- **UI & Styling:** 
  - Google Fonts (Poppins)
  - Custom Modular Widgets
  - Modern Design System (Service-Oriented Architecture)

## 📂 Struktur Proyek

Proyek ini menggunakan struktur folder berbasis fitur (feature-first) untuk skalabilitas dan pemeliharaan yang lebih baik:

```text
lib/
├── core/               # Tema, widget global, dan utilitas pendukung
├── features/           # Modul fitur mandiri
│   ├── auth/           # Otentikasi & Manajemen Sesi
│   ├── event/          # Manajemen & Detail Event
│   ├── home/           # Dashboard & Integrasi Utama
│   ├── job/            # Katalog & Filter Lowongan Kerja
│   ├── profile/        # Resume & Identitas Profesional
│   └── track/          # Monitoring Status Lamaran
└── main.dart           # Titik masuk aplikasi
```

Setiap fitur dalam `lib/features/` memiliki sub-struktur:
- `bloc/`: Logika bisnis dan manajemen state.
- `models/`: Data classes dan mapping.
- `screens/`: UI halaman utama fitur.
- `services/`: Komunikasi data (API/Dummy data).
- `widgets/`: Komponen UI spesifik fitur.

## 🏁 Cara Menjalankan

1. **Clone repositori:**
   ```bash
   git clone https://github.com/username/dcc_mobile.git
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---
*Dikembangkan dengan ❤️ untuk masa depan karir mahasiswa UDINUS.*
