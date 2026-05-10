# A2Z HealthConnect 🏥

**AI-powered multilingual telemedicine app for rural India**

Built with Flutter, optimized for low-end Android devices and poor internet connectivity.

## Features

- 🩺 **Doctor Consultation** — Browse & book video/voice calls with doctors
- 🧠 **AI Symptom Checker** — Select symptoms, get AI-powered health guidance
- 📁 **Offline Records** — Save health records locally, sync when online
- 💊 **Medicine Availability** — Check nearby pharmacy stock & prices
- 🌐 **Multilingual** — English, Hindi (हिंदी), Kannada (ಕನ್ನಡ)
- 🌙 **Dark/Light Mode** — Theme toggle with persistence
- 📴 **Offline-First** — Works without internet, shows connectivity status
- 🔐 **Aadhaar/ABHA Login** — Mock government ID-based authentication

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| State Management | Provider |
| Local Storage | SharedPreferences |
| Network | http package |
| Connectivity | connectivity_plus |
| Typography | Google Fonts (Inter) |
| Backend (planned) | Node.js + Express |

## Mock User for Testing

| Field | Value |
|-------|-------|
| Name | Rajesh Kumar |
| Phone | +91 9876543210 |
| Aadhaar | 1234 5678 9012 |
| ABHA ID | 12-3456-7890-1234 |
| OTP | Any 6-digit number (e.g., 123456) |

## Getting Started

### Prerequisites

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
2. Verify installation: `flutter doctor`

### Run the App

```bash
# Navigate to project directory
cd a2z_healthconnect

# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp setup
├── config/                      # Theme, colors, routes, constants
├── l10n/                        # Localization (EN, HI, KN)
├── models/                      # Data models
├── services/                    # API, auth, storage, connectivity
├── providers/                   # State management (Provider)
├── screens/                     # All app screens
└── widgets/                     # Reusable UI components
```

## API Integration Points

The app includes placeholder integration points marked with `// TODO:` comments:

| Endpoint | File | Purpose |
|----------|------|---------|
| `POST /auth/send-otp` | `auth_service.dart` | Send OTP to phone |
| `POST /auth/verify-otp` | `auth_service.dart` | Verify OTP |
| `POST /auth/verify-aadhaar` | `auth_service.dart` | Aadhaar verification |
| `GET /api/doctors` | `doctor_consultation_screen.dart` | List doctors |
| `POST /api/symptom-check` | `symptom_checker_screen.dart` | AI symptom analysis |
| `GET /api/medicines` | `medicine_screen.dart` | Medicine availability |

## Navigation Flow

```
Splash → Onboarding → Language Selection → Login → Home (Bottom Nav)
                                              ↓
                              ┌────────┬──────┴──────┬──────────┐
                              Home   Consult    AI Check    Records   Profile
```

## License

This project is for educational and demonstration purposes.
