# DCC Mobile (Dinus Career Center)

DCC Mobile adalah aplikasi mobile resmi Dinus Career Center (UDINUS) yang dirancang untuk membantu mahasiswa dan alumni dalam menavigasi karir mereka. Aplikasi ini menyediakan akses mudah ke lowongan pekerjaan, pelacakan lamaran, event pengembangan karir, dan manajemen profil profesional.

## 🚀 Fitur Utama

- **Beranda (Home):** Ringkasan aktivitas, rekomendasi loker terbaru, dan event mendatang.
- **Lowongan Kerja (Job):** Pencarian dan filter lowongan kerja (Full-time, Magang, Part-time) dengan fitur simpan (bookmark) dan form pendaftaran (termasuk upload berkas).
- **Pelacakan (Track):** Memantau status lamaran kerja secara real-time dari tahap pendaftaran hingga penyelesaian (verifikasi, interview, dll).
- **Event:** Informasi seminar, webinar, dan workshop karir lengkap dengan detail jadwal, pembicara, dan tautan pendaftaran.
- **Profil (Profile):** Manajemen Curriculum Vitae (CV), keahlian (tech stack), pengalaman kerja, pendidikan, serta export profil menjadi dokumen PDF.
- **Notifikasi Realtime:** Sistem notifikasi cerdas yang didukung sinkronisasi _background_ (berjalan di latar belakang) dan _realtime database_.

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (v3.x / Material 3)
- **Backend & Database:** [Supabase](https://supabase.com/) (`supabase_flutter`) untuk Auth, Postgres Database, & Realtime
- **State Management:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc)
- **Latar Belakang & Notifikasi:** `workmanager`, `flutter_local_notifications`
- **Utilitas Tambahan:** `flutter_dotenv`, `shared_preferences`, `intl`
- **UI & Styling:**
  - Google Fonts (Manrope)
  - Custom Modular Widgets
  - Modern Design System

## 📂 Struktur Proyek

Proyek ini menggunakan struktur folder berbasis fitur (feature-first) untuk skalabilitas dan pemeliharaan yang rapi:

```text
lib/
├── core/               # Tema, widget global, dan utilitas inti (env, workmanager logger)
├── features/           # Modul fitur fungsional
│   ├── auth/           # Otentikasi (Supabase OTP) & Manajemen Sesi
│   ├── event/          # Katalog & Daftar Event
│   ├── event_detail/   # Rincian mendalam event & pembicara
│   ├── home/           # Dashboard utama
│   ├── job/            # Katalog, filter, & aplikasi Lowongan Kerja
│   ├── notification/   # Realtime Notification & Background Services
│   ├── profile/        # Resume & Identitas Profesional
│   └── track/          # Monitoring Status Lamaran Aktif
└── main.dart           # Titik awal aplikasi
```

Setiap fitur dalam `lib/features/` umumnya menggunakan pendekatan BLoC:

- `bloc/`: Logika bisnis dan abstraksi state.
- `models/`: Data class (parsing langsung dari DB).
- `screens/`: UI halaman spesifik fitur.
- `services/`: Lapisan abstraksi komunikasi ke _backend_.
- `widgets/`: Komponen UI spesifik.

## 🏁 Cara Menjalankan

### ⚠️ Persiapan Wajib (Environment)

Aplikasi ini terhubung langsung dengan **Supabase**. Aplikasi akan menampilkan halaman galat _(Config Error Screen)_ jika konfigurasi tidak disediakan.

1. **Clone repositori:**

   ```bash
   git clone https://github.com/username/dcc_mobile.git
   ```

2. **Siapkan file `.env`:**
   Buat file bernama `.env` di _root directory_ proyek (sejajar dengan `pubspec.yaml`), lalu isi dengan _credentials_ Supabase Anda:

   ```env
   SUPABASE_URL=https://<project_id>.supabase.co
   SUPABASE_ANON_KEY=ey...<kunci_anon>
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

---
