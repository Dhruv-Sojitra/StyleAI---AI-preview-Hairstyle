<div align="center">

<img src="assets/images/app_icon.png" alt="StyleAI Logo" width="120" height="120" style="border-radius: 20px"/>

# StyleAI – AI Hairstyle Preview App

**An AI-powered Flutter mobile application that lets you preview different hairstyles on your own photo using artificial intelligence.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

</div>

---

## 👨‍💻 Developer

| Field | Details |
|---|---|
| **Name** | Dhruv Sojitra |
| **GitHub** | [@Dhruv-Sojitra](https://github.com/Dhruv-Sojitra) |
| **Project** | StyleAI – AI Hairstyle Preview App |
| **Version** | 1.0.0 |

---

## 📱 About the App

StyleAI is an AI-powered mobile application built with **Flutter** and **Firebase** that allows users to preview different hairstyles on their own photos. Users can upload their photo, choose from a wide variety of male and female hairstyle options, and instantly see a realistic AI-generated preview of how that style would look on them.

---

## ✨ Features

### 🤖 AI Hairstyle Preview
- Upload your photo from the gallery or camera
- Choose from **18+ male** and **female** hairstyle options
- AI generates a realistic hairstyle preview on your photo
- Save and share your transformations

### 👤 User Authentication
- Email & Password Sign Up / Sign In
- Google Sign-In support
- Firebase Authentication integration
- Secure user session management

### 🖼️ Image Management
- Upload photos from gallery or camera
- View hairstyle generation history
- Mark results as **Favorites**
- Share generated previews directly

### 🔔 Smart Notifications
- Daily style tip notifications
- Preview completion alerts
- Reminder notifications for uploaded images
- Customizable notification preferences

### 📊 Data Visualization
- View your makeover statistics on the Profile screen
- Track how many hairstyles you've tried
- See your favorites count at a glance

### 🎨 Personalization
- Dark Mode / Light Mode toggle
- Edit your display name and profile
- Persistent user preferences with SharedPreferences

### ❓ Help & Support
- Interactive FAQ accordion section
- Contact support via `support@styleai.com`
- Clean, scrollable support interface

### ℹ️ About StyleAI
- Full app description and mission
- Feature highlights
- Developer credits
- Version information

---

## 🗂️ Project Structure

```
ai_hairstyle_preview_app/
├── lib/
│   ├── main.dart                    # App entry point & Firebase init
│   ├── firebase_options.dart        # Firebase platform config
│   ├── models/
│   │   └── generation_result_model.dart
│   ├── providers/
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash screen
│   │   ├── onboarding_screen.dart   # First-launch onboarding
│   │   ├── login_screen.dart        # Authentication screen
│   │   ├── home_screen.dart         # Main navigation hub
│   │   ├── upload_screen.dart       # Photo upload & AI generation
│   │   ├── result_screen.dart       # AI result display
│   │   ├── profile_screen.dart      # User profile & settings
│   │   ├── edit_profile_screen.dart # Edit display name
│   │   ├── favorites_screen.dart    # Saved favorites
│   │   ├── notification_screen.dart # Notification settings
│   │   ├── help_support_screen.dart # FAQ & Contact support
│   │   └── about_screen.dart        # About the app
│   ├── services/
│   │   ├── auth_service.dart        # Firebase Auth
│   │   ├── firestore_service.dart   # Firestore database
│   │   ├── replicate_service.dart   # Replicate AI API
│   │   ├── free_ai_service.dart     # Hugging Face AI API
│   │   └── notification_service.dart
│   ├── utils/
│   │   ├── app_theme.dart
│   │   └── design_system.dart
│   └── widgets/
│       └── custom_widgets.dart
├── android/                         # Android configuration
├── assets/
│   └── images/
└── pubspec.yaml
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Firebase Auth** | User authentication |
| **Cloud Firestore** | Real-time database |
| **Firebase Storage** | Image storage |
| **Replicate API** | AI hairstyle generation |
| **Hugging Face API** | Alternative AI generation |
| **Flutter Riverpod** | State management |
| **flutter_local_notifications** | Push notifications |
| **shared_preferences** | Local data persistence |
| **Google Fonts** | Premium typography |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `3.x` or higher
- Dart SDK `3.x`
- Android Studio or VS Code
- Firebase project configured

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Dhruv-Sojitra/StyleAI---AI-preview-Hairstyle.git
   cd StyleAI---AI-preview-Hairstyle
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**

   Open `lib/services/replicate_service.dart` and replace:
   ```dart
   static const String _replicateApiToken = 'YOUR_REPLICATE_API_TOKEN';
   ```

   Open `lib/services/free_ai_service.dart` and replace:
   ```dart
   static const String _hfToken = 'YOUR_HUGGING_FACE_API_TOKEN';
   ```

4. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Update `lib/firebase_options.dart` with your Firebase project credentials

5. **Run the app**
   ```bash
   # Run on Windows
   flutter run -d windows

   # Build Android APK
   flutter build apk --release
   ```

---

## 📲 Supported Platforms

| Platform | Status |
|---|---|
| ✅ Android | Fully Supported |
| ✅ Windows | Fully Supported |
| 🔄 iOS | Configurable |
| 🔄 Web | Configurable |

---

## 🎨 Hairstyle Options

### 👨 Male Styles
Crew Cut, Buzz Cut, Sports Buzz, Clean Short Hair, Slicked Back, Pompadour, Comb Over, Side Slick, Retro Greaser, Undercut, Textured Hair, Messy Hair, Korean Middle Part, Mohawk, Curly Hair, Stylish Perm, Tin Foil Perm, Bowl Cut

### 👩 Female Styles
Bob Cut, Pixie Cut, Long Waves, Straight & Sleek, Braided, and more...

---

## 📸 App Screenshots

> _Screenshots to be added_

---

## 🔐 Security Notes

- API tokens are **not committed** to this repository.
- Add your own API keys locally before running.
- Firebase config should be set up per project.

---

## 📄 License

This project is licensed under the **MIT License** — feel free to use and modify for educational purposes.

---

## 🙏 Acknowledgements

- [Flutter](https://flutter.dev) — The UI framework
- [Firebase](https://firebase.google.com) — Backend & Auth
- [Replicate](https://replicate.com) — AI model API
- [Hugging Face](https://huggingface.co) — Open source AI models
- [Unsplash](https://unsplash.com) — Sample preview images

---

<div align="center">

**Made with ❤️ by Dhruv Sojitra**

</div>
