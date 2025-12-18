# mangapp

A Flutter application for discovering food places around campus.

MANGAPP - KELOMPOK 10

## Anggota Kelompok
1. Clay Amsal Sebastian Hutabarat - 5026231132  
2. Muhammad Rifqi Alfareza Santosa - 5026231133    
3. Muhammad Naufal Erwin Effendi - 5026231152  
4. Muhammad Daniel Alfarisi - 5026231161   
5. Daniel Sandi Bratanata Aritonang - 5026231216  
6. Davin Jonathan Tanus - 5026231131  

## Deskripsi Ide
Mangapp adalah platform untuk membantu mahasiswa menemukan tempat makan di sekitar kampus sesuai preferensi dan anggaran. Aplikasi ini menyediakan informasi warung makan, restoran, dan kafe lengkap dengan rating, ulasan mahasiswa, serta fitur pencarian berdasarkan harga, jarak, dan kategori makanan.

## Inovasi Fitur
- Sistem Rekomendasi: Berdasarkan rating dan favorit 
- Rating & Ulasan: Penilaian detail rasa, pelayanan, suasana, dan value  
- Hidden Gem: Menampilkan tempat makan tersembunyi dengan kualitas tinggi  
- History: Riwayat pembelian dan pengeluaran user  

## Struktur Folder
```bash
.vscode/
android/
assets/images/
ios/
lib/
linux/
macos/
test/
web/
windows/
.gitignore
.metadata
README.md
analysis_options.yaml
devtools_options.yaml
pubspec.lock
pubspec.yaml
```
## Teknologi
- Flutter  
- Supabase (Auth & Database)  
- Figma (UI/UX Design)  
## Clone
```bash
git clone https://github.com/CharArtix/mangapp.git
```
## Install Dependencies
Tambahkan dependencies berikut pada `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  supabase_flutter: ^2.0.0
```
lalu jalankan 
```bash
flutter pub get
```
tambahkan 
```bash
await Supabase.initialize(
  url: 'https://xxxxxxx.supabase.co',
  anonKey: 'YOUR_ANON_KEY',
);
```
