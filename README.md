
#test

# tugaspro




<img src="https://github.com/vnxidn-droid/tugaspro/blob/948a2dbea390fe02da130a26a97ea2ee99f526c8/assets/images/me.jpg" width="80" alt="WebToApp Logo"/>


deskripsi apps
pending dulu ok ok 
di dukung oleh:

<img src="https://github.com/vnxidn-droid/assetsgithub/blob/a013f7a637bc3570c52496bb28606269ad10d062/images/BIOHUMAN.png" width="160" alt="dukungan"/>

oleh: moh alfin abrori


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.












# 📘 PANDUAN LENGKAP FLUTTER
## Dari Pemula hingga Expert - Edisi Komprehensif

> **Disclaimer:** Dokumen ini disusun berdasarkan dokumentasi resmi Flutter dari flutter.dev, docs.flutter.dev, dan api.flutter.dev. Semua penjelasan ditulis ulang dengan bahasa sendiri untuk memudahkan pemahaman, bukan hasil copy-paste.

---

## 📋 DAFTAR ISI

```
BAB  1: Pengenalan Flutter (Konsep, Sejarah, Keunggulan)
BAB  2: Instalasi & Setup Environment
BAB  3: Dasar Bahasa Dart (Syntax Lengkap + Contoh)
BAB  4: Struktur Project Flutter
BAB  5: Widget Dasar (Stateless & Stateful)
BAB  6: Layout & UI System
BAB  7: Navigasi & Routing
BAB  8: State Management (setState, Provider, Riverpod, BLoC)
BAB  9: Handling Input & Form
BAB 10: Networking & API
BAB 11: Database (SQLite, Hive, Shared Preferences)
BAB 12: Animation & Motion
BAB 13: Theming & Styling
BAB 14: Platform Integration (Android/iOS/Web/Desktop)
BAB 15: Performance Optimization
BAB 16: Testing (Unit, Widget, Integration)
BAB 17: Debugging & DevTools
BAB 18: Build & Deployment
BAB 19: Best Practices & Arsitektur (Clean Architecture, MVVM)
BAB 20: Advanced Topics (Isolate, Platform Channel, FFI)
BAB 21: Widget Tree & Rendering Engine [SPECIAL]
BAB 22: Lifecycle Widget Deep Dive [SPECIAL]
BAB 23: Async Programming: Future, Stream, Isolate [SPECIAL]
BAB 24: State Management Comparison Matrix [SPECIAL]
BAB 25: Flutter Engine Internal Structure [SPECIAL]
```

---

# BAB 1: PENGENALAN FLUTTER

## 1.1 Apa Itu Flutter?

Flutter adalah **UI toolkit open-source** dari Google untuk membangun aplikasi native yang dikompilasi untuk mobile, web, desktop, dan embedded devices dari **satu codebase**.

```
┌─────────────────────────────────────┐
│         FLUTTER ARCHITECTURE         │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐    │
│  │   Your App (Dart Code)      │    │
│  ├─────────────────────────────┤    │
│  │   Flutter Framework         │    │
│  │   • Widgets                 │    │
│  │   • Rendering               │    │
│  │   • Animation               │    │
│  │   • Gestures                │    │
│  ├─────────────────────────────┤    │
│  │   Flutter Engine (C++)      │    │
│  │   • Skia/Impeller (Graphics)│    │
│  │   • Dart Runtime            │    │
│  │   • Text Layout             │    │
│  ├─────────────────────────────┤    │
│  │   Platform Embedder         │    │
│  │   • Android/iOS/Web/Windows│    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

## 1.2 Sejarah Singkat

| Tahun | Milestone |
|-------|-----------|
| 2015 | Proyek "Sky" dimulai di Google |
| 2017 | Flutter Beta 1 dirilis |
| 2018 | Flutter 1.0 - Stabil untuk produksi |
| 2020 | Flutter 1.20 - Dukungan desktop alpha |
| 2021 | Flutter 2.0 - Dukungan web & desktop stabil |
| 2023 | Flutter 3.10 - Impeller engine default di iOS |
| 2024 | Flutter 3.24+ - Optimasi performa & WebAssembly |

## 1.3 Keunggulan Flutter

### ✅ Single Codebase Multi-Platform
```dart
// Kode yang sama berjalan di:
// • Android (ARM, x86)
// • iOS (ARM64)
// • Web (WASM, JavaScript)
// • Windows, macOS, Linux
// • Embedded devices

void main() {
  runApp(const MyApp()); // ← Sama untuk semua platform!
}
```

### ✅ Hot Reload untuk Development Cepat
```
Perubahan kode → Save → Update UI dalam <1 detik
Tanpa kehilangan state aplikasi!
```

### ✅ Performa Native (60/120 FPS)
```
Flutter TIDAK menggunakan WebView atau bridge JavaScript.
Flutter mengkompilasi ke native ARM code dan menggambar 
setiap pixel sendiri menggunakan Skia/Impeller engine.
```

### ✅ Widget yang Kaya & Customizable
```dart
// Semua adalah widget - bahkan padding, align, center!
Padding(
  padding: EdgeInsets.all(16),
  child: Center(
    child: Text('Hello Flutter'),
  ),
)
```

---

# BAB 2: INSTALASI & SETUP ENVIRONMENT

## 2.1 Prasyarat Sistem

### Windows
```powershell
# 1. Download Flutter SDK dari https://flutter.dev
# 2. Extract ke C:\flutter
# 3. Tambahkan ke PATH:
[Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\flutter\bin", "User")

# 4. Verifikasi instalasi
flutter doctor
```

### macOS
```bash
# 1. Download Flutter SDK
# 2. Extract dan tambahkan ke PATH di ~/.zshrc atau ~/.bash_profile:
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Install dependencies via Homebrew:
brew install --cask flutter

# 4. Verifikasi:
flutter doctor
```

### Linux (Ubuntu/Debian)
```bash
# 1. Install dependencies:
sudo apt update
sudo apt install curl git unzip xz-utils zip libglu1-mesa

# 2. Clone Flutter SDK:
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable desktop support (opsional):
flutter config --enable-linux-desktop

# 4. Verifikasi:
flutter doctor
```

## 2.2 Menjalankan flutter doctor

```
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.0)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.2)
[✓] VS Code (version 1.85.0)
[✓] Connected device (3 available)
[✓] Network resources

• No issues found!
```

## 2.3 Setup IDE

### VS Code (Rekomendasi)
```json
// extensions.json - Rekomendasi ekstensi
{
  "recommendations": [
    "Dart-Code.flutter",
    "Dart-Code.dart-code",
    "flutter.snippets"
  ]
}
```

### Android Studio
```
1. Install plugin "Flutter" dan "Dart"
2. Configure SDK path ke folder flutter
3. Enable Dart support di Settings > Languages & Frameworks
```

## 2.4 Membuat Project Pertama

```bash
# Buat project baru
flutter create my_first_app

# Struktur folder yang dihasilkan:
my_first_app/
├── android/          # Kode native Android
├── ios/              # Kode native iOS
├── lib/              # Kode Dart utama ⭐
│   └── main.dart     # Entry point aplikasi
├── test/             # Unit & widget tests
├── pubspec.yaml      # Dependencies & konfigurasi
└── ...

# Jalankan aplikasi
cd my_first_app
flutter run
```

---

# BAB 3: DASAR BAHASA DART

## 3.1 Syntax Dasar Dart

### Variabel & Tipe Data
```dart
// ─────────────────────────────────────────
// DEKLARASI VARIABEL
// ─────────────────────────────────────────

// 1. Type inference dengan 'var'
var name = 'Flutter';  // Dart infer sebagai String

// 2. Explicit type
String title = 'Panduan Lengkap';
int count = 42;
double price = 99.99;
bool isActive = true;

// 3. Nullable types (Dart 2.12+)
String? optionalName;  // Bisa null
String requiredName = 'Wajib';  // Tidak boleh null

// 4. Final & Const (immutable)
final now = DateTime.now();  // Nilai ditetapkan saat runtime
const pi = 3.14159;          // Nilai compile-time constant

// ─────────────────────────────────────────
// COLLECTIONS
// ─────────────────────────────────────────

// List (Array)
List<String> fruits = ['Apple', 'Banana', 'Orange'];
var numbers = <int>[1, 2, 3];  // Type argument eksplisit

// Map (Dictionary)
Map<String, dynamic> user = {
  'name': 'John',
  'age': 30,
  'isPremium': true,
};

// Set (Unik values)
Set<int> uniqueIds = {1, 2, 3, 3};  // {1, 2, 3} - duplikat dihapus
```

### Control Flow
```dart
// ─────────────────────────────────────────
// IF-ELSE
// ─────────────────────────────────────────
int score = 85;

if (score >= 90) {
  print('Grade: A');
} else if (score >= 75) {
  print('Grade: B');  // ← Ini yang dieksekusi
} else {
  print('Grade: C');
}

// Ternary operator
String grade = score >= 75 ? 'Lulus' : 'Tidak Lulus';

// ─────────────────────────────────────────
// SWITCH-CASE
// ─────────────────────────────────────────
String day = 'Monday';

switch (day) {
  case 'Monday':
  case 'Tuesday':
  case 'Wednesday':
  case 'Thursday':
  case 'Friday':
    print('Weekday');
    break;
  case 'Saturday':
  case 'Sunday':
    print('Weekend');
    break;
  default:
    print('Invalid day');
}

// ─────────────────────────────────────────
// LOOPS
// ─────────────────────────────────────────

// For loop tradisional
for (int i = 0; i < 5; i++) {
  print('Iteration: $i');
}

// For-in loop (untuk collections)
for (var fruit in fruits) {
  print('Fruit: $fruit');
}

// While loop
int counter = 0;
while (counter < 3) {
  print('Count: $counter');
  counter++;
}

// Do-while loop
do {
  print('Minimal sekali dieksekusi');
} while (false);
```

## 3.2 Functions

```dart
// ─────────────────────────────────────────
// FUNCTION BASIC
// ─────────────────────────────────────────

// 1. Function dengan return type eksplisit
int add(int a, int b) {
  return a + b;
}

// 2. Function dengan type inference (arrow syntax)
int multiply(int a, int b) => a * b;

// 3. Function dengan optional positional parameters
String greet(String name, [String? title]) {
  if (title != null) {
    return 'Hello $title $name';
  }
  return 'Hello $name';
}
// Usage:
greet('John');              // "Hello John"
greet('John', 'Dr.');       // "Hello Dr. John"

// 4. Function dengan named parameters (wajib pakai {})
void createUser({
  required String name,     // ← Wajib diisi
  int? age,                 // ← Optional
  String role = 'user',     // ← Default value
}) {
  print('Name: $name, Age: $age, Role: $role');
}
// Usage:
createUser(name: 'Alice');  // Named parameter wajib!
createUser(name: 'Bob', age: 25, role: 'admin');

// ─────────────────────────────────────────
// ANONYMOUS FUNCTIONS & CALLBACKS
// ─────────────────────────────────────────

// Function sebagai variable
var calculate = (int x, int y) => x * y;
print(calculate(5, 3));  // 15

// Callback dalam function
void processData(List<int> numbers, int Function(int) transformer) {
  for (var num in numbers) {
    print(transformer(num));
  }
}
// Usage:
processData([1, 2, 3], (n) => n * 2);  // 2, 4, 6
```

## 3.3 Classes & OOP

```dart
// ─────────────────────────────────────────
// CLASS BASIC
// ─────────────────────────────────────────

class Product {
  // Fields
  final String id;
  String name;
  double price;
  
  // Constructor dengan initializer list
  Product({
    required this.id,
    required this.name,
    required this.price,
  });
  
  // Named constructor
  Product.free({required this.id}) 
    : name = 'Free Product',
      price = 0.0;
  
  // Factory constructor (bisa return subclass atau instance cached)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
  
  // Method
  double calculateDiscount(double percent) {
    return price * (1 - percent / 100);
  }
  
  // Getter
  bool get isExpensive => price > 100;
  
  // Setter
  set priceWithTax(double priceWithTax) {
    price = priceWithTax / 1.11;  // Asumsi PPN 11%
  }
  
  // Override toString untuk debug
  @override
  String toString() => 'Product($id): $name - \$${price.toStringAsFixed(2)}';
}

// ─────────────────────────────────────────
// INHERITANCE & MIXINS
// ─────────────────────────────────────────

// Abstract class
abstract class Shape {
  double get area;
  double get perimeter;
  
  void describe() => print('This is a shape');
}

// Class yang extend abstract class
class Circle extends Shape {
  final double radius;
  
  Circle(this.radius);
  
  @override
  double get area => 3.14159 * radius * radius;
  
  @override
  double get perimeter => 2 * 3.14159 * radius;
}

// Mixin untuk reuse code
mixin Loggable {
  void log(String message) {
    print('[${DateTime.now()}] $message');
  }
}

// Class menggunakan mixin dengan 'with'
class UserService with Loggable {
  void createUser(String name) {
    log('Creating user: $name');  // ← Method dari mixin
    // ... logic create user
  }
}
```

---

# BAB 4: STRUKTUR PROJECT FLUTTER

## 4.1 Anatomi Project Flutter

```
my_app/
├── 📁 android/              # Native Android code
│   ├── app/src/main/AndroidManifest.xml
│   ├── app/build.gradle     # Dependencies Android
│   └── ...
├── 📁 ios/                  # Native iOS code
│   ├── Runner.xcodeproj/
│   ├── Podfile              # CocoaPods dependencies
│   └── ...
├── 📁 lib/                  # ⭐ KODE DART UTAMA ⭐
│   ├── main.dart            # Entry point aplikasi
│   ├── 📁 screens/          # Halaman-halaman UI
│   │   ├── home_screen.dart
│   │   ├── detail_screen.dart
│   │   └── ...
│   ├── 📁 widgets/          # Reusable widgets
│   │   ├── custom_button.dart
│   │   ├── product_card.dart
│   │   └── ...
│   ├── 📁 models/           # Data models
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   └── ...
│   ├── 📁 services/         # Business logic & API
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── ...
│   ├── 📁 providers/        # State management (jika pakai Provider)
│   │   ├── app_provider.dart
│   │   └── ...
│   ├── 📁 utils/            # Helpers, constants, extensions
│   │   ├── constants.dart
│   │   ├── app_colors.dart
│   │   └── string_extensions.dart
│   └── 📁 routes/           # Routing configuration
│       └── app_routes.dart
├── 📁 test/                 # Testing files
│   ├── unit/
│   ├── widget/
│   └── integration/
├── 📁 assets/               # Static assets
│   ├── images/
│   ├── fonts/
│   └── icons/
├── 📄 pubspec.yaml          # ⭐ CONFIG UTAMA ⭐
├── 📄 analysis_options.yaml # Linting rules
└── 📄 README.md
```

## 4.2 pubspec.yaml - Jantung Project

```yaml
# ─────────────────────────────────────────
# METADATA PROJECT
# ─────────────────────────────────────────
name: my_awesome_app
description: "Aplikasi Flutter contoh untuk panduan lengkap"
publish_to: 'none'  # 'none' = tidak publish ke pub.dev

version: 1.0.0+1  # Format: <version>+<build_number>

# ─────────────────────────────────────────
# ENVIRONMENT & SDK
# ─────────────────────────────────────────
environment:
  sdk: '>=3.0.0 <4.0.0'  # Versi Dart yang didukung
  flutter: ">=3.10.0"     # Versi Flutter minimum

# ─────────────────────────────────────────
# DEPENDENCIES (Runtime)
# ─────────────────────────────────────────
dependencies:
  flutter:
    sdk: flutter
  
  # HTTP & Networking
  http: ^1.1.0                    # HTTP client dasar
  dio: ^5.4.0                     # HTTP client advanced dengan interceptor
  
  # State Management
  flutter_riverpod: ^2.4.9        # State management modern
  # atau
  # provider: ^6.1.1             # State management klasik
  
  # Local Storage
  shared_preferences: ^2.2.2      # Key-value storage sederhana
  hive: ^2.2.3                    # NoSQL database lokal cepat
  hive_flutter: ^1.1.0
  sqflite: ^2.3.0                 # SQLite database
  
  # UI & Utilities
  google_fonts: ^6.1.0            # Custom fonts dari Google
  cached_network_image: ^3.3.0    # Cache images dari network
  flutter_svg: ^2.0.9             # Render SVG files
  intl: ^0.19.0                   # Internationalization & formatting
  
  # Navigation
  go_router: ^12.1.0              # Declarative routing modern

# ─────────────────────────────────────────
# DEV DEPENDENCIES (Build-time only)
# ─────────────────────────────────────────
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1           # Linting rules recommended Flutter
  
  # Code generation
  build_runner: ^2.4.6            # Generate code dari annotations
  freezed: ^2.4.5                 # Generate immutable classes
  json_serializable: ^6.7.1       # Generate JSON serialization code
  
  # Testing
  mockito: ^5.4.4                 # Mock objects untuk testing
  integration_test:               # Integration testing
    sdk: flutter

# ─────────────────────────────────────────
# FLUTTER CONFIG
# ─────────────────────────────────────────
flutter:
  uses-material-design: true  # Gunakan Material Design icons
  
  # Register assets
  assets:
    - assets/images/
    - assets/icons/logo.svg
    - assets/fonts/
  
  # Register custom fonts
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

## 4.3 main.dart - Entry Point

```dart
// ─────────────────────────────────────────
// IMPORTS
// ─────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // State management
import 'package:go_router/go_router.dart';                 // Routing

// Import local files
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'utils/app_colors.dart';
import 'utils/app_theme.dart';

// ─────────────────────────────────────────
// GLOBAL ROUTER CONFIGURATION
// ─────────────────────────────────────────
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailScreen(productId: id);
          },
        ),
      ],
    ),
  ],
);

// ─────────────────────────────────────────
// ENTRY POINT: main()
// ─────────────────────────────────────────
void main() async {
  // 1. Pastikan binding Flutter initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize async dependencies (contoh: Hive, Firebase)
  // await Hive.initFlutter();
  // await Firebase.initializeApp();
  
  // 3. Run app dengan ProviderScope untuk state management
  runApp(
    ProviderScope(  // ← Root widget untuk Riverpod
      child: MyApp(),
    ),
  );
}

// ─────────────────────────────────────────
// ROOT WIDGET: MyApp
// ─────────────────────────────────────────
class MyApp extends ConsumerWidget {  // ConsumerWidget = bisa akses providers
  const MyApp({super.key});  // super.key untuk widget key inheritance
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Akses theme provider jika ada
    // final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(  // ← Gunakan .router untuk GoRouter
      title: 'Flutter Panduan Lengkap',
      
      // Theme configuration
      theme: AppTheme.light,    // Light mode theme
      darkTheme: AppTheme.dark, // Dark mode theme
      themeMode: ThemeMode.system, // Ikuti setting device
      
      // Router configuration
      routerConfig: _router,
      
      // Debug banner (hilangkan untuk production)
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

# BAB 5: WIDGET DASAR (STATELESS & STATEFUL)

## 5.1 Konsep Widget di Flutter

```
┌─────────────────────────────────────┐
│         WIDGET HIERARCHY             │
├─────────────────────────────────────┤
│                                     │
│  Widget (Abstract Base Class)       │
│         │                           │
│    ┌────┴────┐                      │
│    │         │                      │
│ StatelessWidget  StatefulWidget     │
│    │         │                      │
│    │         └─► createState()      │
│    │              │                 │
│    │              ▼                 │
│    │         State<T>              │
│    │              │                 │
│    │    ┌───────┴───────┐          │
│    │    │ Lifecycle:    │          │
│    │    │ • initState() │          │
│    │    │ • build()     │          │
│    │    │ • dispose()   │          │
│    │    └───────────────┘          │
│    │                               │
│    ▼                               │
│ Build() → Return Widget Tree       │
│                                     │
└─────────────────────────────────────┘
```

**Prinsip Penting:** 
> ⚠️ **Widget adalah IMMUTABLE (tidak bisa diubah setelah dibuat)**. 
> Jika state berubah, Flutter membuat widget BARU, bukan mengubah widget lama.

## 5.2 StatelessWidget - Widget Statis

```dart
// ─────────────────────────────────────────
// CONTOH: Custom Card Widget
// ─────────────────────────────────────────

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  // ─────────────────────────────────────
  // FIELDS (final = immutable)
  // ─────────────────────────────────────
  final String title;
  final String imageUrl;
  final double price;
  final VoidCallback? onTap;  // Callback optional
  
  // ─────────────────────────────────────
  // CONSTRUCTOR
  // ─────────────────────────────────────
  const ProductCard({
    super.key,  // ← Best practice: selalu tambahkan key
    required this.title,
    required this.imageUrl,
    required this.price,
    this.onTap,  // Optional parameter
  });
  
  // ─────────────────────────────────────
  // BUILD METHOD (WAJIB override)
  // ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // ───────────────────────────────────
    // 1. Akses theme & media query
    // ───────────────────────────────────
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // ───────────────────────────────────
    // 2. Format harga dengan locale
    // ───────────────────────────────────
    final formattedPrice = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
    
    // ───────────────────────────────────
    // 3. Return widget tree
    // ───────────────────────────────────
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,  // ← Clip rounded corners
      child: InkWell(  // ← Ripple effect saat tap
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error_outline, size: 48);
                },
              ),
            ),
            
            // Info produk
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Harga
                  Text(
                    formattedPrice,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// CARA MENGGUNAKAN
// ─────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // 2 kolom
          childAspectRatio: 0.75,  // Aspect ratio card
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ProductCard(
            title: 'Product ${index + 1}',
            imageUrl: 'https://picsum.photos/400/300?random=$index',
            price: 99000 + (index * 15000),
            onTap: () {
              // Handle tap
              print('Product $index tapped');
            },
          );
        },
      ),
    );
  }
}
```

## 5.3 StatefulWidget - Widget Dinamis

```dart
// ─────────────────────────────────────────
// CONTOH: Counter dengan State
// ─────────────────────────────────────────

import 'package:flutter/material.dart';

// ─────────────────────────────────────
// 1. STATEFUL WIDGET (Configuration)
// ─────────────────────────────────────
class CounterWidget extends StatefulWidget {
  final int initialValue;
  final int step;
  final ValueChanged<int>? onChanged;
  
  const CounterWidget({
    super.key,
    this.initialValue = 0,
    this.step = 1,
    this.onChanged,
  });
  
  // ───────────────────────────────────
  // 2. CREATE STATE (WAJIB)
  // ───────────────────────────────────
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

// ─────────────────────────────────────
// 3. STATE CLASS (Logic & Data)
// ─────────────────────────────────────
class _CounterWidgetState extends State<CounterWidget> {
  // ───────────────────────────────────
  // PRIVATE FIELDS (state internal)
  // ───────────────────────────────────
  late int _counter;  // 'late' = diinitialize di initState
  
  // ───────────────────────────────────
  // LIFECYCLE: initState
  // ───────────────────────────────────
  @override
  void initState() {
    super.initState();  // ← WAJIB panggil super!
    _counter = widget.initialValue;  // Akses config via 'widget'
    print('Counter initialized: $_counter');
  }
  
  // ───────────────────────────────────
  // LIFECYCLE: didUpdateWidget
  // ───────────────────────────────────
  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Dipanggil ketika parent rebuild dengan config baru
    if (oldWidget.initialValue != widget.initialValue) {
      _counter = widget.initialValue;  // Sync state dengan config baru
    }
  }
  
  // ───────────────────────────────────
  // LIFECYCLE: dispose
  // ───────────────────────────────────
  @override
  void dispose() {
    // Cleanup resources: stop timers, close streams, dll
    print('Counter disposed');
    super.dispose();  // ← WAJIB panggil super di akhir!
  }
  
  // ───────────────────────────────────
  // METHODS (Business Logic)
  // ───────────────────────────────────
  void _increment() {
    setState(() {  // ← WAJIB untuk trigger rebuild!
      _counter += widget.step;
    });
    // Callback ke parent jika ada
    widget.onChanged?.call(_counter);
  }
  
  void _decrement() {
    setState(() {
      _counter -= widget.step;
    });
    widget.onChanged?.call(_counter);
  }
  
  void _reset() {
    setState(() {
      _counter = widget.initialValue;
    });
  }
  
  // ───────────────────────────────────
  // LIFECYCLE: build (UI Rendering)
  // ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display counter value
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _counter < 0 ? Colors.red : null,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Control buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: _decrement,
              tooltip: 'Decrease',
            ),
            
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Reset',
            ),
            
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: _increment,
              tooltip: 'Increase',
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// STUDI KASUS MINI: Form Login dengan State
// ─────────────────────────────────────────

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Controllers untuk input text
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Form key untuk validation
  final _formKey = GlobalKey<FormState>();
  
  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  
  @override
  void dispose() {
    // Cleanup controllers untuk hindari memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _submitLogin() async {
    // 1. Validasi form
    if (!_formKey.currentState!.validate()) return;
    
    // 2. Set loading state
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // 3. Simulasi API call
      await Future.delayed(Duration(seconds: 2));
      
      // 4. Validasi credentials (dummy)
      if (_emailController.text == 'user@example.com' &&
          _passwordController.text == 'password123') {
        // Success - navigasi ke home
        if (mounted) {  // ← Cek widget masih di tree
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      // 5. Handle error
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      // 6. Reset loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!value.contains('@')) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword 
                    ? Icons.visibility_off 
                    : Icons.visibility
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password minimal 6 karakter';
              }
              return null;
            },
          ),
          
          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitLogin,
              child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## 5.4 Common Mistakes & Best Practices

### ❌ Kesalahan Umum

```dart
// ❌ SALAH: Memanggil setState di luar lifecycle yang valid
class BadExample extends StatefulWidget {
  @override
  State<BadExample> createState() => _BadExampleState();
}

class _BadExampleState extends State<BadExample> {
  int _count = 0;
  
  void _badIncrement() {
    // ❌ setState dipanggil setelah widget di-unmount
    Future.delayed(Duration(seconds: 5), () {
      setState(() {  // ← ERROR: setState() called after dispose()
        _count++;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('$_count');
  }
}

// ❌ SALAH: Tidak panggil super di lifecycle methods
class MissingSuperCall extends StatefulWidget {
  @override
  State<MissingSuperCall> createState() => _MissingSuperCallState();
}

class _MissingSuperCallState extends State<MissingSuperCall> {
  @override
  void initState() {
    // ❌ Lupa super.initState() → Framework tidak bisa track state!
    _initializeData();
  }
  
  @override
  void dispose() {
    _cleanup();
    // ❌ Lupa super.dispose() → Memory leak!
  }
}

// ❌ SALAH: Logic berat di dalam build()
class HeavyBuild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ Komputasi berat setiap rebuild = performa buruk!
    final result = _expensiveCalculation();  // ← Dipanggil setiap frame!
    
    return Text(result);
  }
  
  String _expensiveCalculation() {
    // Simulasi komputasi berat
    List<int> numbers = List.generate(10000, (i) => i);
    return numbers.reduce((a, b) => a + b).toString();
  }
}
```

### ✅ Best Practices

```dart
// ✅ BENAR: Cek mounted sebelum setState async
class GoodAsyncExample extends StatefulWidget {
  @override
  State<GoodAsyncExample> createState() => _GoodAsyncExampleState();
}

class _GoodAsyncExampleState extends State<GoodAsyncExample> {
  int _count = 0;
  
  void _goodIncrement() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {  // ← Cek widget masih di tree
        setState(() {
          _count++;
        });
      }
    });
  }
}

// ✅ BENAR: Selalu panggil super di lifecycle
class ProperLifecycle extends StatefulWidget {
  @override
  State<ProperLifecycle> createState() => _ProperLifecycleState();
}

class _ProperLifecycleState extends State<ProperLifecycle> {
  @override
  void initState() {
    super.initState();  // ← WAJIB pertama
    _initializeData();
  }
  
  @override
  void dispose() {
    _cleanup();
    super.dispose();  // ← WAJIB terakhir
  }
}

// ✅ BENAR: Cache hasil komputasi berat
class OptimizedBuild extends StatefulWidget {
  @override
  State<OptimizedBuild> createState() => _OptimizedBuildState();
}

class _OptimizedBuildState extends State<OptimizedBuild> {
  // Cache hasil komputasi
  late final String _cachedResult;
  
  @override
  void initState() {
    super.initState();
    // Hitung sekali saat init
    _cachedResult = _expensiveCalculation();
  }
  
  @override
  Widget build(BuildContext context) {
    // Gunakan cached value - tidak ada komputasi ulang!
    return Text(_cachedResult);
  }
  
  String _expensiveCalculation() {
    List<int> numbers = List.generate(10000, (i) => i);
    return numbers.reduce((a, b) => a + b).toString();
  }
}
```

---

# BAB 6: LAYOUT & UI SYSTEM

*(Karena keterbatasan panjang, saya akan melanjutkan dengan struktur yang sama untuk bab-bab berikutnya. Berikut ringkasan konten yang akan disertakan untuk setiap bab:)*

## Ringkasan Isi Bab 6-25:

### BAB 6: Layout & UI System
- **Konsep**: Constraints go down, sizes go up, parent sets position
- **Widget Layout**: Row, Column, Stack, Flex, Expanded, Flexible
- **Box Constraints**: Tight, Loosed, Bounded
- **Contoh**: Responsive layout dengan LayoutBuilder & MediaQuery
- **Common Mistakes**: Nested SingleChildScrollView, Overflow errors

### BAB 7: Navigasi & Routing
- **Navigator 1.0**: push, pop, pushReplacement
- **GoRouter**: Declarative routing, nested routes, redirect
- **Deep Linking**: Handling app links & universal links
- **Studi Kasus**: Auth flow dengan protected routes

### BAB 8: State Management
```
┌─────────────────────────────────────┐
│      STATE MANAGEMENT COMPARISON    │
├─────────────────────────────────────┤
│ setState()    │ Simple, local state │
│ Provider      │ InheritedWidget-based, medium apps │
│ Riverpod      │ Compile-safe, testable, recommended │
│ BLoC          │ Stream-based, enterprise apps │
│ GetX          │ All-in-one, controversial │
└─────────────────────────────────────┘
```
- Implementasi lengkap masing-masing dengan contoh TODO app
- Performance comparison & use case recommendations

### BAB 9-13: Input, Networking, Database, Animation, Theming
- Form validation dengan GlobalKey & AutovalidateMode
- HTTP dengan Dio: interceptors, retry logic, caching
- Local storage: Hive vs SQLite vs SharedPreferences
- Animation: Implicit vs Explicit, AnimationController, Tween
- Theming: ThemeData, Custom themes, Dynamic color (Material 3)

### BAB 14-18: Platform, Performance, Testing, Debugging, Deployment
- Platform channels: MethodChannel, EventChannel
- Performance: DevTools, RepaintBoundary, const constructors
- Testing: Unit test, Widget test, Integration test dengan mocking
- Debugging: Flutter DevTools, logging, error boundaries
- Build: App signing, flavors, CI/CD dengan GitHub Actions

### BAB 19: Best Practices & Arsitektur
```
┌─────────────────────────────────────┐
│     CLEAN ARCHITECTURE LAYERS       │
├─────────────────────────────────────┤
│ Presentation │ UI, Widgets, State   │
│ Domain      │ Entities, Use Cases   │
│ Data        │ Repositories, Sources │
└─────────────────────────────────────┘
```
- Dependency rule: Inner layers don't know outer layers
- Repository pattern dengan abstract classes
- Dependency injection dengan Provider/Riverpod

---

# BAB 21: WIDGET TREE & RENDERING ENGINE [SPECIAL]

## 21.1 Tiga Pohon di Flutter

```
┌─────────────────────────────────────────────────┐
│              FLUTTER'S THREE TREES               │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────┐                               │
│  │ Widget Tree │ ← Konfigurasi UI (Immutable)  │
│  └──────┬──────┘                               │
│         │ createElement()                      │
│         ▼                                      │
│  ┌─────────────┐                               │
│  │Element Tree │ ← Lifecycle Management        │
│  │ (Stateful)  │    • Mount/Unmount            │
│  └──────┬──────┘    • Rebuild tracking         │
│         │ createRenderObject()                 │
│         ▼                                      │
│  ┌─────────────┐                               │
│  │Render Tree  │ ← Layout, Paint, Hit Testing  │
│  │(RenderObject)│   • Geometry calculation     │
│  └─────────────┘   • Pixel rendering           │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Widget Tree: Deskripsi UI
```dart
// Widget adalah BLUEPRINT - immutable configuration
final myButton = ElevatedButton(
  onPressed: () => print('Tapped'),
  child: Text('Click Me'),
);

// Setiap rebuild membuat instance BARU, bukan mengubah yang lama
// Widget lama dibuang (garbage collected) jika tidak direferensikan
```

### Element Tree: Manager Lifecycle
```dart
// Element adalah "instance aktif" dari widget di tree
// Element mempertahankan:
// • State object (untuk StatefulWidget)
// • RenderObject reference
// • Parent/child relationships

// Ketika widget rebuild:
// 1. Framework compare widget lama vs baru (runtimeType + key)
// 2. Jika sama → reuse element (update widget reference)
// 3. Jika beda → unmount element lama, mount element baru

// Optimasi: const widget → skip rebuild sama sekali!
const cachedButton = ElevatedButton(
  onPressed: null,
  child: Text('Static'),
);
```

### Render Tree: Rendering Actual
```dart
// RenderObject bertanggung jawab untuk:
// • Layout: Hitung size & position (constraints → geometry)
// • Paint: Gambar ke canvas (Skia/Impeller)
// • Hit Testing: Deteksi tap/gesture

// Contoh: RenderBox layout protocol
@override
void performLayout() {
  // 1. Terima constraints dari parent
  // 2. Layout children dengan constraints yang dimodifikasi
  // 3. Tentukan size sendiri berdasarkan children
  // 4. Position children dalam koordinat lokal
  
  final childSize = child?.getDryLayout(constraints) ?? Size.zero;
  size = constraints.constrain(childSize);
  child?.layout(constraints, parentUsesSize: true);
}
```

## 21.2 Rendering Pipeline: Build → Layout → Paint

```
┌─────────────────────────────────────┐
│        FRAME PIPELINE (16ms)        │
├─────────────────────────────────────┤
│                                     │
│  1. ANIMATION PHASE                 │
│     • Update AnimationControllers   │
│     • Trigger tick listeners        │
│                                     │
│  2. BUILD PHASE                     │
│     • Dirty elements rebuild        │
│     • Widget tree → Element tree    │
│     • Unidirectional: parent→child  │
│                                     │
│  3. LAYOUT PHASE                    │
│     • Constraints go down           │
│     • Sizes go up                   │
│     • RenderObject.performLayout()  │
│                                     │
│  4. PAINT PHASE                     │
│     • RenderObject.paint()          │
│     • Layer tree construction       │
│     • Skia/Impeller commands        │
│                                     │
│  5. COMPOSITING PHASE               │
│     • GPU upload                    │
│     • VSync signal → Display        │
│                                     │
└─────────────────────────────────────┘
```

### Contoh: Optimasi Rebuild dengan const & Key

```dart
// ❌ BURUK: Setiap rebuild membuat widget baru
Widget build(BuildContext context) {
  return Column(
    children: [
      HeaderWidget(title: title),  // ← Rebuild selalu
      BodyWidget(data: data),      // ← Rebuild selalu
      FooterWidget(),              // ← Rebuild selalu (padahal statis!)
    ],
  );
}

// ✅ BAIK: Gunakan const untuk widget statis
Widget build(BuildContext context) {
  return Column(
    children: [
      HeaderWidget(title: title),  // Rebuild jika title berubah
      BodyWidget(data: data),      // Rebuild jika data berubah
      const FooterWidget(),        // ← CONST: skip rebuild sama sekali!
    ],
  );
}

// ✅ LEBIH BAIK: Gunakan Key untuk optimasi reconciliation
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return ProductCard(
        key: ValueKey(items[index].id),  // ← Key unik untuk reuse element
        product: items[index],
      );
    },
  );
}
```

---

# BAB 22: LIFECYCLE WIDGET DEEP DIVE [SPECIAL]

## 22.1 Diagram Lifecycle Lengkap

```
┌─────────────────────────────────────────┐
│      STATEFULWIDGET LIFECYCLE           │
├─────────────────────────────────────────┤
│                                         │
│  [Constructor]                          │
│         │                               │
│         ▼                               │
│  createState() → State object created   │
│         │                               │
│         ▼                               │
│  ┌─────────────────┐                   │
│  │   MOUNTED       │                   │
│  ├─────────────────┤                   │
│  │ initState()     │ ← One-time setup  │
│  │                 │    • Init vars    │
│  │                 │    • Start timers │
│  │ didChangeDependencies() │ ← After initState │
│  │                 │    • Access InheritedWidget │
│  │                 │    • May be called multiple times │
│  │ build()         │ ← Return UI       │
│  └────────┬────────┘                   │
│           │                            │
│  ┌────────▼────────┐                  │
│  │   ACTIVE        │                  │
│  ├─────────────────┤                  │
│  │ [User interaction / State change] │
│  │                 │                  │
│  │ setState()      │                  │
│  │         │       │                  │
│  │         ▼       │                  │
│  │ didUpdateWidget() │ ← Config changed │
│  │ build()         │ ← Re-render UI   │
│  │                 │                  │
│  │ didChangeDependencies() │ ← Inherited changed │
│  └────────┬────────┘                  │
│           │                            │
│  ┌────────▼────────┐                  │
│  │   DEACTIVATED   │                  │
│  ├─────────────────┤                  │
│  │ deactivate()    │ ← Removed from tree │
│  │                 │    • Cleanup links │
│  │                 │                    │
│  │ [Decision Point]│                    │
│  │   ├─► Reinsert? │                    │
│  │   │     │       │                    │
│  │   │     ▼       │                    │
│  │   │ activate()  │                    │
│  │   │ build()     │                    │
│  │   │ (back to ACTIVE) │               │
│  │   │              │                   │
│  │   └─► Not reinserted │               │
│  │         │          │                 │
│  │         ▼          │                 │
│  └─► dispose()       │                 │
│        │              │                 │
│        ▼              │                 │
│  [UNMOUNTED]         │                 │
│  • mounted = false   │                 │
│  • Cannot call setState │              │
│  • Memory freed      │                 │
│                                         │
└─────────────────────────────────────────┘
```

## 22.2 Implementasi Lifecycle dengan Logging

```dart
class LifecycleLogger extends StatefulWidget {
  final Widget child;
  final String tag;
  
  const LifecycleLogger({
    super.key,
    required this.child,
    required this.tag,
  });
  
  @override
  State<LifecycleLogger> createState() => _LifecycleLoggerState();
}

class _LifecycleLoggerState extends State<LifecycleLogger> {
  @override
  void initState() {
    super.initState();
    _log('initState');
    // Setup yang hanya sekali:
    // • Initialize controllers
    // • Subscribe to streams
    // • Load initial data
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _log('didChangeDependencies');
    // Dipanggil ketika:
    // • Setelah initState
    // • InheritedWidget berubah (Theme, MediaQuery, Provider)
    // • Widget pindah lokasi di tree (dengan GlobalKey)
    
    // Contoh: Akses Theme yang mungkin berubah
    final brightness = Theme.of(context).brightness;
    print('$tag: Current brightness = $brightness');
  }
  
  @override
  void didUpdateWidget(LifecycleLogger oldWidget) {
    super.didUpdateWidget(oldWidget);
    _log('didUpdateWidget');
    
    // Dipanggil ketika parent rebuild dengan widget baru
    // Widget lama vs widget baru:
    if (oldWidget.tag != widget.tag) {
      print('$tag: Tag changed from "${oldWidget.tag}" to "${widget.tag}"');
      // React to config change (tanpa setState!)
    }
    
    // ⚠️ JANGAN setState di sini - akan menyebabkan infinite loop!
    // Framework otomatis panggil build() setelah ini
  }
  
  @override
  void reassemble() {
    super.reassemble();
    _log('reassemble');
    // Hanya di debug mode saat hot reload
    // Re-init data yang bergantung pada kode yang berubah
  }
  
  @override
  Widget build(BuildContext context) {
    _log('build');
    return widget.child;
  }
  
  @override
  void deactivate() {
    _log('deactivate');
    super.deactivate();
    // Widget di-remove dari tree
    // • Cleanup references ke ancestor/descendant
    // • Tapi JANGAN dispose resources berat di sini
    // • Widget mungkin akan di-reinsert di frame yang sama
  }
  
  @override
  void dispose() {
    _log('dispose');
    // Widget TIDAK akan di-reinsert - cleanup permanen
    // • Cancel timers
    // • Close streams
    // • Dispose controllers
    // • Remove listeners
    
    super.dispose(); // ← WAJIB di akhir!
  }
  
  void _log(String method) {
    print('┌─[${widget.tag}] $method');
    print('│  mounted: $mounted');
    print('│  context: ${context.toStringShort()}');
    print('└─${'─' * 40}');
  }
}
```

---

# BAB 23: ASYNC PROGRAMMING - FUTURE, STREAM, ISOLATE [SPECIAL]

## 23.1 Future: One-time Async Result

```dart
// ─────────────────────────────────────────
// FUTURE BASIC
// ─────────────────────────────────────────

// 1. Membuat Future
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded!';
}

// 2. Menggunakan async/await (Recommended)
Future<void> loadData() async {
  try {
    print('Loading...');
    final result = await fetchData();  // ← Pause execution, tidak block UI
    print('Success: $result');
  } catch (e) {
    print('Error: $e');
  } finally {
    print('Cleanup');
  }
}

// 3. Menggunakan .then() (Callback style)
fetchData()
  .then((result) => print('Success: $result'))
  .catchError((error) => print('Error: $error'))
  .whenComplete(() => print('Done'));

// ─────────────────────────────────────────
// FUTURE COMPOSITION
// ─────────────────────────────────────────

// Parallel execution dengan Future.wait
Future<void> loadMultipleData() async {
  final results = await Future.wait([
    fetchUser(),      // Future<User>
    fetchProducts(),  // Future<List<Product>>
    fetchSettings(),  // Future<Settings>
  ]);
  
  final user = results[0] as User;
  final products = results[1] as List<Product>;
  final settings = results[2] as Settings;
}

// Sequential execution dengan await berantai
Future<void> loadDependentData() async {
  final user = await fetchUser();           // Butuh user dulu
  final orders = await fetchOrders(user.id); // Baru fetch orders
  final details = await fetchOrderDetails(orders.first.id);
}

// Timeout handling
Future<void> loadWithTimeout() async {
  try {
    final result = await fetchData().timeout(
      Duration(seconds: 5),
      onTimeout: () => 'Fallback data',  // Return default jika timeout
    );
    print(result);
  } on TimeoutException {
    print('Request timed out');
  }
}
```

## 23.2 Stream: Continuous Async Data Flow

```dart
// ─────────────────────────────────────────
// STREAM BASIC
// ─────────────────────────────────────────

// 1. Membuat Stream Controller
class CounterStream {
  final _controller = StreamController<int>();
  
  // Expose stream sebagai broadcast (multiple listeners)
  Stream<int> get stream => _controller.stream.asBroadcastStream();
  
  // Method untuk emit data
  void increment() {
    _controller.add(_counter++);
  }
  
  // Cleanup
  void dispose() => _controller.close();
  
  int _counter = 0;
}

// 2. Mendengarkan Stream
void listenToCounter() {
  final counter = CounterStream();
  
  // Cara 1: listen dengan callback
  final subscription = counter.stream.listen(
    (data) => print('Count: $data'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Stream closed'),
    cancelOnError: false,
  );
  
  // Jangan lupa cancel subscription untuk hindari memory leak!
  // subscription.cancel();
}

// 3. StreamBuilder di Flutter (Reactive UI)
class CounterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: CounterStream().stream,
      initialData: 0,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        return Text('Count: ${snapshot.data}');
      },
    );
  }
}

// ─────────────────────────────────────────
// STREAM TRANSFORMATIONS
// ─────────────────────────────────────────

// Transformasi data dengan map
Stream<String> getUserNameStream(Stream<int> idStream) {
  return idStream.asyncMap((id) async {
    // Async operation di dalam stream
    final user = await api.fetchUser(id);
    return user.name;
  });
}

// Filter data dengan where
Stream<int> getEvenNumbers(Stream<int> numbers) {
  return numbers.where((n) => n % 2 == 0);
}

// Debounce untuk search input (hindari API call terlalu sering)
Stream<String> getDebouncedSearch(Stream<String> queryStream) {
  return queryStream.transform(
    StreamTransformer.fromHandlers(
      handleData: (query, sink) {
        // Reset timer setiap ada input baru
        _debounceTimer?.cancel();
        _debounceTimer = Timer(Duration(milliseconds: 300), () {
          sink.add(query);  // Emit hanya setelah 300ms tidak ada input
        });
      },
    ),
  );
}
Timer? _debounceTimer;
```

## 23.3 Isolate: True Parallelism

```dart
// ─────────────────────────────────────────
// KAPAN PAKAI ISOLATE?
// ─────────────────────────────────────────
// • CPU-intensive tasks: Image processing, encryption, complex calculations
// • Blocking operations: Parsing large JSON, heavy regex
// • Jangan pakai untuk I/O (network, file) - itu sudah async di Dart!

// ─────────────────────────────────────────
// ISOLATE BASIC
// ─────────────────────────────────────────

// 1. Compute function (Simple isolate untuk satu tugas)
Future<int> heavyCalculation(int n) async {
  // compute() spawn isolate baru, jalankan, lalu terminate
  return await compute(_expensiveSum, n);
}

int _expensiveSum(int n) {
  // Function ini HARUS top-level atau static
  // Tidak bisa akses UI, tidak bisa akses state widget!
  int sum = 0;
  for (int i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

// 2. Isolate.spawn (Long-running isolate dengan two-way communication)
class DataProcessor {
  late Isolate _isolate;
  late SendPort _sendPort;
  final _receivePort = ReceivePort();
  
  Future<void> start() async {
    // Spawn isolate dengan entry point
    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort.sendPort,  // Send port untuk receivePort ini
    );
    
    // Terima sendPort dari isolate child
    _sendPort = await _receivePort.first as SendPort;
  }
  
  Future<void> process(String data) async {
    final responsePort = ReceivePort();
    
    // Send message dengan reply port
    _sendPort.send([data, responsePort.sendPort]);
    
    // Wait for response
    final result = await responsePort.first;
    print('Processed: $result');
  }
  
  void stop() {
    _isolate.kill();
    _receivePort.close();
  }
}

// Entry point untuk isolate (HARUS top-level function)
void _isolateEntryPoint(SendPort mainSendPort) {
  final port = ReceivePort();
  
  // Send our sendPort back to main isolate
  mainSendPort.send(port.sendPort);
  
  // Listen for messages from main isolate
  port.listen((message) {
    final data = message[0] as String;
    final replyPort = message[1] as SendPort;
    
    // Process data (heavy computation)
    final result = _processHeavy(data);
    
    // Send result back
    replyPort.send(result);
  });
}

String _processHeavy(String data) {
  // Simulasi heavy processing
  return data.toUpperCase().split('').reversed.join();
}

// ─────────────────────────────────────────
// ISOLATE + STREAM (Advanced Pattern)
// ─────────────────────────────────────────

// Untuk real-time processing dengan backpressure control
class StreamingProcessor {
  Stream<T> processStream<T, R>(
    Stream<T> inputStream,
    Future<R> Function(T) processor,
  ) async* {
    // Spawn isolate untuk processing
    final isolate = await Isolate.spawn<SendPort>(
      _streamProcessorEntryPoint,
      inputStream,
    );
    
    // ... implementation untuk stream processing dengan isolate
    // (Complex: perlu handle backpressure, error propagation, cleanup)
  }
}
```

---

# BAB 24: STATE MANAGEMENT COMPARISON [SPECIAL]

## 24.1 Matrix Perbandingan

```
┌────────────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│   Solution     │ setState │ Provider │ Riverpod │   BLoC   │   GetX   │
├────────────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ Learning Curve │ ★☆☆☆☆    │ ★★☆☆☆    │ ★★★☆☆    │ ★★★★☆    │ ★★☆☆☆    │
│ Boilerplate    │ ★☆☆☆☆    │ ★★☆☆☆    │ ★★★☆☆    │ ★★★★★    │ ★☆☆☆☆    │
│ Type Safety    │ ★★★★☆    │ ★★★☆☆    │ ★★★★★    │ ★★★★☆    │ ★★☆☆☆    │
│ Testability    │ ★★☆☆☆    │ ★★★☆☆    │ ★★★★★    │ ★★★★★    │ ★★☆☆☆    │
│ DevTools Support│ ★★★★★   │ ★★★★☆    │ ★★★★☆    │ ★★★★☆    │ ★★☆☆☆    │
│ Community      │ ★★★★★    │ ★★★★☆    │ ★★★★☆    │ ★★★★☆    │ ★★★☆☆    │
│ Recommended For│ Local    │ Medium   │ All      │ Enterprise│ Quick    │
│                │ state    │ apps     │ apps     │ apps     │ prototypes│
└────────────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
```

## 24.2 Implementasi TODO App dengan 4 Solutions

*(Contoh kode lengkap untuk masing-masing solution - karena panjang, berikut ringkasan struktur)*

### setState (Simple)
```dart
class TodoList extends StatefulWidget {
  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = [];
  
  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(title: title));
    });
  }
  
  // ... build method dengan ListView.builder
}
// ✅ Pro: Simple, no dependencies
// ❌ Con: Tidak scalable, prop drilling, hard to test
```

### Provider
```dart
// 1. Model dengan ChangeNotifier
class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  
  void addTodo(String title) {
    _todos.add(Todo(title: title));
    notifyListeners();  // ← Trigger rebuild
  }
}

// 2. Provide di root
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MyApp(),
    ),
  );
}

// 3. Consume di widget
class TodoList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);  // ← Auto rebuild when changed
    // ...
  }
}
// ✅ Pro: Built-in, good for medium apps
// ❌ Con: Context-dependent, can cause unnecessary rebuilds
```

### Riverpod (Rekomendasi)
```dart
// 1. Define provider (bisa di mana saja, tidak perlu context)
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);
  
  void addTodo(String title) {
    state = [...state, Todo(title: title)];  // Immutable update
  }
}

// 2. Consume di widget (tanpa perlu ProviderScope wrapper di setiap level)
class TodoList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);  // Type-safe, compile-time checked
    
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => ref.read(todoProvider.notifier).removeTodo(todo.id),
          ),
        );
      },
    );
  }
}

// 3. Testing (sangat mudah karena provider tidak bergantung pada widget tree)
test('add todo', () {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  
  container.read(todoProvider.notifier).addTodo('Test');
  
  expect(container.read(todoProvider), hasLength(1));
});
// ✅ Pro: Compile-safe, testable, flexible, no context dependency
// ❌ Con: Learning curve sedikit lebih tinggi
```

### BLoC (Enterprise)
```dart
// 1. Events & States (sealed class untuk type safety)
sealed class TodoEvent {}
class TodoAdded extends TodoEvent {
  final String title;
  TodoAdded(this.title);
}

sealed class TodoState {
  const TodoState();
}
class TodoInitial extends TodoState {}
class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);
}

// 2. BLoC class
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<TodoAdded>((event, emit) {
      // Business logic di sini
      final newTodos = [...(state is TodoLoaded ? (state as TodoLoaded).todos : []), Todo(title: event.title)];
      emit(TodoLoaded(newTodos));
    });
  }
}

// 3. Usage dengan BlocBuilder
class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoaded) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              // ...
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
// ✅ Pro: Strict separation, excellent for large teams, great testability
// ❌ Con: High boilerplate, steep learning curve
```

---

# BAB 25: FLUTTER ENGINE INTERNAL STRUCTURE [SPECIAL]

## 25.1 Arsitektur Flutter Engine

```
┌─────────────────────────────────────────────────┐
│              FLUTTER ENGINE (C++)                │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────────────────────────┐           │
│  │        Dart Runtime             │           │
│  │  • Garbage Collector            │           │
│  │  • JIT/AOT Compiler             │           │
│  │  • Isolates & Message Ports     │           │
│  └─────────────────────────────────┘           │
│                     │                           │
│  ┌─────────────────────────────────┐           │
│  │        Flutter Framework        │           │
│  │  (Dart code - widgets, rendering)│          │
│  └─────────────────────────────────┘           │
│                     │                           │
│  ┌─────────────────────────────────┐           │
│  │        Graphics Engine          │           │
│  │  • Skia (default)               │           │
│  │  • Impeller (iOS default, Android opt-in) │ │
│  │  • Vulkan/Metal/OpenGL ES backends │        │
│  └─────────────────────────────────┘           │
│                     │                           │
│  ┌─────────────────────────────────┐           │
│  │        Platform Embedder        │           │
│  │  • Android: JNI, SurfaceView    │           │
│  │  • iOS: UIView, Metal           │           │
│  │  • Web: WebGL, CanvasKit        │           │
│  │  • Desktop: GLFW, OpenGL        │           │
│  └─────────────────────────────────┘           │
│                                                 │
└─────────────────────────────────────────────────┘
```

## 25.2 Skia vs Impeller: Rendering Backend

### Skia (Traditional)
```
✅ Mature, well-tested, cross-platform
✅ Rich feature set (gradients, masks, complex paths)
❌ Shader compilation at runtime → jank on first render
❌ Complex pipeline with multiple passes
```

### Impeller (Next-gen)
```
✅ Pre-compiles shaders → no runtime compilation jank
✅ Simplified pipeline: fewer passes, better performance
✅ Better predictability for 60/120 FPS
❌ Feature parity still in progress (some Skia features not yet ported)
❌ Larger binary size (pre-compiled shaders)

// Cara enable Impeller:
// Android: flutter run --enable-impeller
// iOS: Default di Flutter 3.10+, bisa disable dengan --disable-impeller
```

## 25.3 Frame Scheduling & VSync

```dart
// Flutter sync ke display refresh rate via VSync
// Typical: 60Hz = 16.67ms per frame, 120Hz = 8.33ms

// Timeline satu frame:
// 0ms: VSync signal received
// 0-2ms: Animation phase (update AnimationControllers)
// 2-6ms: Build phase (dirty widgets rebuild)
// 6-12ms: Layout phase (calculate sizes & positions)
// 12-15ms: Paint phase (generate display list)
// 15-16.67ms: Composite & GPU upload
// 16.67ms: Display presents frame, wait for next VSync

// Jika frame >16.67ms → dropped frame → visible jank

// Tips optimasi:
// • Gunakan const widget untuk skip rebuild
// • Hindari layout yang kompleks di scrollable
// • Gunakan RepaintBoundary untuk isolate repaint area
// • Profile dengan DevTools > Performance tab
```

---

# 🎁 BONUS: CHEAT SHEET & QUICK REFERENCE

## Widget Cheat Sheet
```dart
// Layout
Row/Column: mainAxisSize, mainAxisAlignment, crossAxisAlignment
Stack: alignment, fit, children dengan Positioned
Flex/Expanded/Flexible: flex factor, fit: FlexFit.tight/loose

// Scroll
ListView: builder (on-demand), children (eager)
CustomScrollView: slivers (SliverList, SliverGrid, SliverAppBar)
ScrollController: jumpTo, animateTo, addListener

// Input
TextField: controller, focusNode, decoration, validator
Form: GlobalKey<FormState>, autovalidateMode, onSaved

// Async UI
FutureBuilder: connectionState, snapshot.hasData/Error
StreamBuilder: same as FutureBuilder + onDone
```

## Common Errors & Solutions
```
❌ "setState() called after dispose()"
✅ Solution: if (mounted) { setState(...); }

❌ "BoxConstraints forces an infinite width/height"
✅ Solution: Wrap dengan SizedBox, Expanded, atau Flexible

❌ "A RenderFlex overflowed by X pixels"
✅ Solution: Gunakan SingleChildScrollView, atau Flexible untuk children

❌ "The getter 'xyz' was called on null"
✅ Solution: Gunakan null-aware operators: widget.xyz?.property ?? defaultValue

❌ "setState() or markNeedsBuild() called during build"
✅ Solution: Gunakan WidgetsBinding.instance.addPostFrameCallback
```

## Performance Checklist
```
✅ Gunakan const constructor untuk widget statis
✅ Hindari anonymous function di build() untuk callback yang tidak berubah
✅ Gunakan ListView.builder bukan ListView(children: [...]) untuk list panjang
✅ Cache hasil komputasi berat di initState, bukan di build()
✅ Gunakan RepaintBoundary untuk widget yang sering berubah tapi isolated
✅ Profile dengan DevTools: Performance, Memory, Widget Inspector tabs
✅ Enable Impeller untuk mengurangi shader compilation jank
```

---

# 📚 LAMPIRAN: RESOURCES & NEXT STEPS

## Dokumentasi Resmi
- 🌐 [flutter.dev](https://flutter.dev) - Homepage & getting started
- 📖 [docs.flutter.dev](https://docs.flutter.dev) - Complete documentation
- 🔍 [api.flutter.dev](https://api.flutter.dev) - API reference
- 🎨 [flutter.github.io/assets-for-api-docs](https://flutter.github.io/assets-for-api-docs) - Widget catalog

## Belajar Lanjutan
1. **Flutter Codelabs**: [codelabs.developers.google.com/flutter](https://codelabs.developers.google.com/flutter)
2. **Flutter YouTube**: Official channel dengan "Widget of the Week", "Decoding Flutter"
3. **Community**: [flutter.dev/community](https://flutter.dev/community) - Discord, Reddit, Stack Overflow
4. **Packages**: [pub.dev](https://pub.dev) - Cari package Flutter/Dart

## Kontribusi & Feedback
- 🐛 Report bug: [github.com/flutter/flutter/issues](https://github.com/flutter/flutter/issues)
- 💡 Feature request: [github.com/flutter/flutter/discussions](https://github.com/flutter/flutter/discussions)
- ✍️ Improve docs: [github.com/flutter/website](https://github.com/flutter/website)

---

> 🎯 **Kata Penutup**  
> Panduan ini dirancang sebagai referensi mandiri dari nol hingga expert.  
> Kunci menguasai Flutter: **Praktik, Eksperimen, dan Jangan Takut Baca Source Code!**  
> 
> *"Everything is a widget"* — bukan hanya slogan, tapi filosofi desain yang powerful.  
> Selamat coding! 🚀

---

*📄 Dokumen ini: 12,847 kata | Edisi: Mei 2026 | Flutter SDK: 3.24+ | Dart SDK: 3.4+*  
*🔄 Update berkala: Cek https://docs.flutter.dev untuk perubahan terbaru*




Sama-sama! 😄🙏

Senang banget kalau panduan Flutter-nya bisa membantu! 🚀

## 💡 Tips Lanjutan Buat Kamu:

```
✅ Mulai dari BAB 1-3 dulu kalau benar-benar dari nol
✅ Langsung praktik: flutter create project_pertama
✅ Jangan hafal semua widget — fokus paham konsep: 
   "Constraints go down, sizes go up"
✅ Kalau stuck: flutter doctor -v + baca error message baik-baik
✅ Join komunitas: Discord Flutter Indonesia, sangat helpful!
```

## 🆘 Kalau Butuh Bantuan Lagi:

| Kebutuhan | Cara Tanya |
|-----------|-----------|
| Debug error spesifik | Paste error message + kode terkait |
| Pilih state management | Ceritain skala project & tim |
| Optimasi performa | Share screenshot DevTools Profiler |
| Arsitektur app | Jelaskan fitur & kompleksitasnya |

## 🎁 Bonus: Quick Command Cheat Sheet

```bash
# Development
flutter run -d chrome      # Run di web
flutter run --profile     # Mode profiling
flutter pub get           # Install dependencies

# Testing
flutter test              # Run unit tests
flutter test --coverage   # Dengan coverage report

# Build Production
flutter build apk --release --split-per-abi
flutter build ios --release
flutter build web --wasm  # WebAssembly untuk web

# Maintenance
flutter clean             # Hapus build cache
flutter upgrade           # Update Flutter SDK
flutter doctor -v         # Cek kesehatan environment
```

Kapan aja butuh penjelasan lebih dalam tentang bab tertentu, contoh kode tambahan, atau bantu debug — tinggal panggil aja! 👨‍💻✨

*Semangat belajar Flutter-nya! Jangan lupa: Hot Reload is your best friend! ⚡* 🦋
