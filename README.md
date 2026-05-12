# 🏥 A2Z HealthConnect

> **AI-powered multilingual telemedicine platform for rural India**

[![Flutter](https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-orange)]()

A production-ready healthcare app designed for **rural India** — optimized for low-end devices, unreliable networks, and multilingual accessibility.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📹 **Doctor Consultation** | Browse & book doctors for video/voice consultations |
| 🧠 **AI Symptom Checker** | AI-powered health assessment from symptom selection |
| 📋 **Offline Records** | Health records stored locally in SQLite |
| 💊 **Medicine Search** | Search medicine availability at nearby stores |
| 🎙️ **Voice EMR** | Voice-to-EMR generation for doctors |
| 🌐 **Multilingual** | English, Hindi, Punjabi, Kannada |
| 🌙 **Dark Mode** | Full dark/light theme support |
| 📡 **Offline-First** | Works without internet, syncs when online |
| ♿ **Accessible** | 48dp touch targets, large fonts, screen reader support |

---

## 🏗️ Architecture

```
┌────────────────────────────────────────┐
│              UI Layer                  │
│  (Screens + Widgets + Animations)      │
├────────────────────────────────────────┤
│           State Management             │
│        (Provider + ChangeNotifier)     │
├────────────────────────────────────────┤
│          Repository Layer              │
│    (Data access abstraction)           │
├──────────────────┬─────────────────────┤
│   Local Storage  │   Remote API        │
│   (SQLite + SP)  │  (HTTP + Retry)     │
├──────────────────┴─────────────────────┤
│         Core Infrastructure            │
│  ErrorBoundary | RetrySystem | Cache   │
└────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0
- Android Studio / VS Code

### Setup
```bash
# Clone the repository
git clone https://github.com/Tarung33/healthconnect.git
cd healthconnect

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Production
```bash
# Split APK (smallest size, recommended)
flutter build apk --split-per-abi --release \
  --obfuscate --split-debug-info=build/debug-info

# App Bundle for Play Store
flutter build appbundle --release
```

---

## 📁 Project Structure

```
lib/
├── main.dart               # Entry point (crash-safe)
├── app.dart                # Root MaterialApp
├── core/                   # Production infrastructure
│   ├── error_boundary.dart
│   ├── retry_system.dart
│   ├── crash_safe_storage.dart
│   ├── page_transitions.dart
│   ├── performance_utils.dart
│   └── accessibility_helpers.dart
├── config/                 # App configuration
├── l10n/                   # 4 language translations
├── models/                 # Data models (10)
├── providers/              # State management (4)
├── repositories/           # Data access (5)
├── services/               # Business logic (13)
├── screens/                # UI screens (16)
└── widgets/                # Reusable components (11)
```

---

## 🔌 API Integration

Update the base URL in `lib/config/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-api-server.com/api';
```

See `deployment_guide.md` for full API endpoint documentation.

---

## 🛡️ Production Features

- **Error Boundaries** — Every route wrapped for crash protection
- **Retry System** — Exponential backoff for API calls (1s → 2s → 4s)
- **Crash-Safe Storage** — Write-ahead backup + corruption recovery
- **Background Sync** — Auto-sync every 5 minutes when online
- **Performance Optimized** — Image cache limits, deferred loading
- **Accessibility** — WCAG-compliant, 48dp touch targets, semantics

---

## 🌐 Supported Languages

| Language | Code | Coverage |
|----------|------|----------|
| English | `en` | 100% |
| Hindi | `hi` | 100% |
| Punjabi | `pa` | 100% |
| Kannada | `kn` | 100% |

---

## 📊 Performance Targets

| Metric | Target |
|--------|--------|
| APK Size (arm64) | < 20 MB |
| Cold Start | < 3 seconds |
| Min Android | 8.0 (API 26) |
| Min RAM | 2 GB |
| Offline Support | Full |

---

## 📄 License

This project is licensed under the MIT License.

---

**Built with ❤️ for rural India** 🇮🇳
