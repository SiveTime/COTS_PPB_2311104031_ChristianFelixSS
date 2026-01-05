# COTS PPB - Simple Task Management App

**Nama:** Christian Felix SS  
**NIM:** 2311104031  
**Mata Kuliah:** Pemrograman Perangkat Bergerak (PPB)

## 📱 Overview Aplikasi

**Simple Task Management App** adalah aplikasi mobile berbasis Flutter untuk mengelola tugas-tugas kuliah. Aplikasi ini memungkinkan mahasiswa untuk menambah, melihat, mengedit, dan menandai tugas sebagai selesai dengan antarmuka yang intuitif dan modern.

### ✨ Fitur Utama
- 📋 **Dashboard** - Ringkasan tugas dan navigasi utama
- 📝 **Daftar Tugas** - Melihat semua tugas dengan filter status
- 🔍 **Detail Tugas** - Informasi lengkap dan edit tugas
- ➕ **Tambah Tugas** - Form untuk membuat tugas baru
- ✅ **Toggle Status** - Menandai tugas selesai/belum selesai
- 📚 **Mata Kuliah** - Kategorisasi tugas berdasarkan mata kuliah

## 🏗️ Arsitektur Aplikasi

### Struktur Folder
```
lib/
├── config/              # Konfigurasi aplikasi
│   └── api_config.dart
├── controllers/         # State management dengan Provider
│   └── task_controller.dart
├── design_system/       # Design system konsisten
│   ├── colors.dart      # Palet warna aplikasi
│   ├── typography.dart  # Sistem tipografi
│   └── spacing.dart     # Sistem spacing
├── models/              # Data models
│   └── task.dart
├── presentation/        # UI Layer
│   ├── pages/          # Halaman-halaman utama
│   │   ├── dashboard_page.dart
│   │   ├── task_list_page.dart
│   │   ├── task_detail_page.dart
│   │   └── add_task_page.dart
│   └── widgets/        # Komponen UI reusable
│       ├── custom_app_bar.dart
│       ├── custom_button.dart
│       ├── custom_input.dart
│       ├── custom_checkbox.dart
│       ├── task_card.dart
│       └── loading_widget.dart
├── services/           # Business logic & API calls
│   └── task_service.dart
└── main.dart          # Entry point aplikasi
```

## 🎨 Design System & Keseragaman UI

### 1. **Sistem Warna Konsisten**
```dart
// Primary Colors
- Primary Blue: #2F68FF
- Background: #F7F8FA  
- Surface: #FFFFFF

// Text Colors  
- Text Primary: #1F2937
- Text Secondary: #64748B

// Status Colors
- Success: #10B981
- Warning: #F59E0B  
- Error: #EF4444
```

### 2. **Tipografi Terstruktur**
- **Title 20 SemiBold** - Judul halaman dan header
- **Section 16 SemiBold** - Section headers dan subtitle
- **Body 14 Regular** - Konten utama dan form
- **Caption 12 Regular** - Label dan helper text

### 3. **Spacing Konsisten**
- **Screen Padding:** 16px untuk margin halaman
- **Card Padding:** 16px untuk padding dalam card
- **Element Spacing:** 8px, 12px, 16px, 24px, 32px

### 4. **Komponen UI Reusable**

#### **CustomButton**
- Primary button dengan loading state
- Secondary button untuk aksi alternatif
- Konsisten di seluruh aplikasi

#### **CustomInput**
- TextFormField dengan styling seragam
- Validasi terintegrasi
- Support untuk required fields

#### **TaskCard**
- Komponen card untuk menampilkan tugas
- Status indicator dengan warna konsisten
- Touch feedback dan navigasi

#### **CustomCheckbox**
- Checkbox dengan styling custom
- Konsisten dengan design system

## 📱 Halaman-Halaman Utama

### 1. **Dashboard Page**
- **Fungsi:** Halaman utama dengan ringkasan tugas
- **Fitur:** 
  - Header dengan judul aplikasi
  - Quick stats tugas
  - Navigasi ke halaman lain
  - Recent tasks preview

### 2. **Task List Page**
- **Fungsi:** Menampilkan semua tugas dalam bentuk list
- **Fitur:**
  - Filter berdasarkan status (Semua, Berjalan, Selesai)
  - Search functionality
  - Swipe actions untuk quick edit
  - FAB untuk tambah tugas baru

### 3. **Task Detail Page**
- **Fungsi:** Menampilkan detail lengkap tugas
- **Fitur:**
  - Informasi lengkap tugas
  - Edit mode untuk mengubah catatan
  - Toggle completion status
  - Full-width layout yang konsisten

### 4. **Add Task Page**
- **Fungsi:** Form untuk menambah tugas baru
- **Fitur:**
  - Form validation lengkap
  - Date picker untuk deadline
  - Dropdown mata kuliah
  - Auto-save draft

## 🔧 State Management

### Provider Pattern
- **TaskController** sebagai ChangeNotifier
- Centralized state untuk semua operasi tugas
- Reactive UI updates
- Error handling terintegrasi

### State Operations
```dart
// Menambah tugas baru
await taskController.addTask(task);

// Toggle status tugas
await taskController.toggleTaskCompletion(taskId);

// Update catatan tugas
await taskController.updateTaskNote(taskId, note);

// Load semua tugas
await taskController.loadTasks();
```

## 🚀 Navigasi

### Navigation Flow
```
Dashboard
├── → Task List Page
│   ├── → Task Detail Page
│   └── → Add Task Page
├── → Task Detail Page (dari recent tasks)
└── → Add Task Page
```

### Navigation Features
- **MaterialPageRoute** untuk transisi halaman
- **Return values** untuk update data setelah edit
- **Back navigation** dengan data refresh
- **Deep linking** support untuk task detail

## 🎯 Keunggulan UI/UX

### 1. **Konsistensi Visual**
- Semua komponen menggunakan design system yang sama
- Warna, tipografi, dan spacing terstandarisasi
- Visual hierarchy yang jelas

### 2. **Responsive Design**
- Full-width layout untuk semua komponen
- Adaptive spacing untuk berbagai ukuran layar
- Touch-friendly button sizes

### 3. **User Experience**
- Loading states untuk feedback visual
- Form validation dengan pesan error yang jelas
- Smooth navigation dengan proper back handling
- Intuitive gestures dan interactions

### 4. **Accessibility**
- Proper contrast ratios
- Readable font sizes
- Touch target sizes sesuai standar
- Semantic widget structure

## 🛠️ Teknologi yang Digunakan

- **Flutter SDK:** 3.38.5
- **Dart:** 3.10.4
- **State Management:** Provider ^6.1.2
- **HTTP Client:** http ^1.2.2
- **Date Formatting:** intl ^0.19.0
- **Platform:** Android (API Level 21+)

## 📦 Instalasi dan Menjalankan

1. **Clone repository**
```bash
git clone https://github.com/username/COTS_PPB_2311104031_ChristianFelixSS.git
cd COTS_PPB_2311104031_ChristianFelixSS
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run aplikasi**
```bash
flutter run
```

4. **Build APK**
```bash
flutter build apk --release
```

## 🐛 Debugging & Testing

### Issues yang Telah Diperbaiki
1. **NDK Android Error** - Fixed dengan install ulang NDK versi yang kompatibel
2. **White-on-White Text** - Fixed dengan perbaikan color alpha channel
3. **Dropdown Overflow** - Fixed dengan DraggableScrollableSheet
4. **Layout Inconsistency** - Fixed dengan full-width container approach

### Testing Checklist
- ✅ Form validation berfungsi
- ✅ Navigation tidak error
- ✅ State management reactive
- ✅ UI konsisten di semua halaman
- ✅ Build APK sukses

## 📸 Screenshots

*Screenshots akan ditambahkan setelah aplikasi final*

1. **Dashboard** - Halaman utama dengan overview tugas
2. **Task List** - Daftar semua tugas dengan filter
3. **Task Detail** - Detail tugas dengan edit capability
4. **Add Task** - Form tambah tugas dengan validation

## 👨‍💻 Developer

**Christian Felix SS**  
NIM: 2311104031  
Program Studi: [Program Studi]  
Universitas: [Nama Universitas]

---

*Aplikasi ini dibuat sebagai tugas akhir mata kuliah Pemrograman Perangkat Bergerak (PPB) dengan fokus pada implementasi design system yang konsisten dan user experience yang optimal.*