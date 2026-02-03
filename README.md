<div align="center">

# 🏥 MedExplain AI

### AI-Powered Medical Report Analysis & Explanation System

*Simplifying complex medical documents for patients and healthcare professionals*

[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Web-blue?style=for-the-badge)](https://flutter.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.29.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Groq](https://img.shields.io/badge/AI-Groq%20LLaMA%203.3-00D4AA?style=for-the-badge)](https://groq.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

---

**[Features](#-features)** • **[Demo](#-demo)** • **[Installation](#-installation)** • **[Architecture](#-architecture)** • **[API](#-api-documentation)** • **[Contributing](#-contributing)**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Demo](#-demo)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Privacy & Security](#-privacy--security)
- [Medical Safety](#-medical-safety-disclaimer)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**MedExplain AI** is a production-grade medical document analysis application that leverages advanced AI to help patients and clinicians understand medical reports, lab results, prescriptions, and radiology findings. Built with Flutter for seamless cross-platform support and powered by n8n workflows with Groq's LLaMA 3.3 70B model.

### Why MedExplain AI?

- 📄 **Medical documents are complex** - Full of jargon patients don't understand
- ⏰ **Doctors have limited time** - Can't always explain everything in detail
- 🌍 **Healthcare is global** - Multi-language support breaks barriers
- 🔒 **Privacy matters** - No data stored, HIPAA-conscious design

---

## ✨ Features

### Core Capabilities

| Feature | Description |
|---------|-------------|
| 📷 **Document Scanning** | Capture medical documents using camera with ML-powered OCR |
| 📁 **File Upload** | Support for PDF, images (JPG, PNG), and text files |
| 🤖 **AI Analysis** | Powered by Groq's LLaMA 3.3 70B for accurate explanations |
| 👥 **Dual Mode** | Patient-friendly & Clinician-focused explanations |
| 🚨 **Red-Flag Detection** | Automatic alerts for critical/urgent findings |
| 🔒 **Privacy-First** | Automatic PII redaction (names, MRN, dates, SSN) |
| 💬 **RAG Chat** | Ask follow-up questions about your reports |
| 🌐 **Multi-Language** | Support for English, Spanish, French, and more |
| 📚 **Citation-Backed** | References from RSNA, CDC, NIH guidelines |

### Patient Mode 👤

- ✅ Simple explanations at 8th-grade reading level
- ✅ Reassuring, empathetic tone
- ✅ What findings **may** indicate (non-diagnostic)
- ✅ Suggested questions to ask your doctor
- ✅ Clear medical disclaimers throughout

### Clinician Mode 👨‍⚕️

- ✅ Bullet-point clinical summary
- ✅ Key findings highlighted with severity
- ✅ Critical values flagged prominently
- ✅ Non-prescriptive clinical considerations
- ✅ Differential diagnosis prompts

---

## 🎬 Demo

### Application Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        MedExplain AI                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│   │   📷 Scan   │    │  📁 Upload  │    │  📝 Paste   │        │
│   │  Document   │    │    File     │    │    Text     │        │
│   └──────┬──────┘    └──────┬──────┘    └──────┬──────┘        │
│          │                  │                  │                │
│          └──────────────────┼──────────────────┘                │
│                             ▼                                   │
│                  ┌─────────────────────┐                        │
│                  │   🔍 OCR/Extract    │                        │
│                  │   Google ML Kit     │                        │
│                  └──────────┬──────────┘                        │
│                             ▼                                   │
│                  ┌─────────────────────┐                        │
│                  │  🔒 Privacy Filter  │                        │
│                  │   PII Redaction     │                        │
│                  └──────────┬──────────┘                        │
│                             ▼                                   │
│          ┌──────────────────┴──────────────────┐                │
│          ▼                                     ▼                │
│   ┌─────────────┐                       ┌─────────────┐         │
│   │ 👤 Patient  │                       │ 👨‍⚕️ Clinician│         │
│   │    Mode     │                       │    Mode     │         │
│   └──────┬──────┘                       └──────┬──────┘         │
│          │                                     │                │
│          └──────────────────┬──────────────────┘                │
│                             ▼                                   │
│                  ┌─────────────────────┐                        │
│                  │   🤖 AI Analysis    │                        │
│                  │   Groq LLaMA 3.3    │                        │
│                  └──────────┬──────────┘                        │
│                             ▼                                   │
│                  ┌─────────────────────┐                        │
│                  │   📊 Results View   │                        │
│                  │   + RAG Chat        │                        │
│                  └─────────────────────┘                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠 Technology Stack

### Frontend
| Technology | Purpose |
|------------|---------|
| **Flutter 3.29.2** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Provider** | State management |
| **Material Design 3** | UI components & theming |

### Backend & Services
| Technology | Purpose |
|------------|---------|
| **Firebase Auth** | User authentication |
| **Cloud Firestore** | Database (optional history) |
| **Firebase Hosting** | Web deployment |
| **n8n** | Workflow automation engine |

### AI & ML
| Technology | Purpose |
|------------|---------|
| **Groq API** | LLaMA 3.3 70B inference |
| **Google ML Kit** | On-device OCR/text recognition |
| **RAG Pipeline** | Context-aware Q&A |

### Platforms Supported
| Platform | Status |
|----------|--------|
| 🤖 Android | ✅ Supported |
| 🍎 iOS | ✅ Supported |
| 🪟 Windows | ✅ Supported |
| 🍏 macOS | ✅ Supported |
| 🐧 Linux | ✅ Supported |
| 🌐 Web | ✅ Supported |

---

## 🏗 Architecture

### System Architecture Diagram

```
┌────────────────────────────────────────────────────────────────────────────┐
│                              CLIENT LAYER                                  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│    ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│    │ Android  │  │   iOS    │  │ Windows  │  │  macOS   │  │   Web    │   │
│    │   App    │  │   App    │  │   App    │  │   App    │  │   App    │   │
│    └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│         │             │             │             │             │          │
│         └─────────────┴─────────────┼─────────────┴─────────────┘          │
│                                     │                                      │
│                          ┌──────────▼──────────┐                           │
│                          │    Flutter App      │                           │
│                          │  ┌───────────────┐  │                           │
│                          │  │   Providers   │  │                           │
│                          │  │  (State Mgmt) │  │                           │
│                          │  └───────────────┘  │                           │
│                          └──────────┬──────────┘                           │
│                                     │                                      │
└─────────────────────────────────────┼──────────────────────────────────────┘
                                      │ HTTPS
┌─────────────────────────────────────┼──────────────────────────────────────┐
│                          SERVICE LAYER                                     │
├─────────────────────────────────────┼──────────────────────────────────────┤
│                                     ▼                                      │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │                     n8n Workflow Engine                         │     │
│    ├─────────────────────────────────────────────────────────────────┤     │
│    │                                                                 │     │
│    │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐            │     │
│    │  │ Webhook │─▶│ Privacy │─▶│  Text   │─▶│   AI    │            │     │
│    │  │ Receive │  │  Check  │  │ Process │  │  Call   │            │     │
│    │  └─────────┘  └─────────┘  └─────────┘  └────┬────┘            │     │
│    │                                              │                  │     │
│    │  ┌─────────┐  ┌─────────┐  ┌─────────┐      │                  │     │
│    │  │Response │◀─│ Safety  │◀─│Red Flag │◀─────┘                  │     │
│    │  │ Builder │  │ Filter  │  │ Detect  │                         │     │
│    │  └─────────┘  └─────────┘  └─────────┘                         │     │
│    │                                                                 │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                     │                                      │
│    ┌────────────────────────────────┼────────────────────────────────┐     │
│    │                                ▼                                │     │
│    │  ┌─────────────┐    ┌─────────────────┐    ┌─────────────┐     │     │
│    │  │  Firebase   │    │    Groq API     │    │  Firebase   │     │     │
│    │  │    Auth     │    │  LLaMA 3.3 70B  │    │  Firestore  │     │     │
│    │  └─────────────┘    └─────────────────┘    └─────────────┘     │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User Input ──▶ OCR/Text Extract ──▶ PII Redaction ──▶ AI Processing ──▶ Results
     │                                                       │
     │                                                       ▼
     │                                              ┌─────────────────┐
     │                                              │  Response JSON  │
     │                                              ├─────────────────┤
     │                                              │ • Summary       │
     │                                              │ • Findings      │
     │                                              │ • Red Flags     │
     │                                              │ • Questions     │
     │                                              │ • Citations     │
     └──────────────── RAG Chat ◀──────────────────│ • Disclaimer    │
                                                    └─────────────────┘
```

---

## 🚀 Installation

### Prerequisites

- **Flutter SDK** 3.29.2 or later ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Android Studio** or **VS Code** with Flutter extensions
- **n8n** (self-hosted or cloud) for workflow automation
- **Groq API Key** (free tier at [console.groq.com](https://console.groq.com))
- **Firebase Project** (for authentication)

### Step 1: Clone Repository

```bash
git clone https://github.com/Subeshan707/medexplain_ai.git
cd medexplain_ai
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password and Google Sign-In)
3. Download configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
4. Run FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Step 4: n8n Workflow Setup

1. **Install n8n**:
```bash
npm install -g n8n
n8n start
```

2. **Import Workflows**:
   - Open n8n at `http://localhost:5678`
   - Go to **Workflows** → **Import from File**
   - Import `rag chatbot.json` and `report and image analyse.json`

3. **Configure Groq Credentials**:
   - Go to **Credentials** → **Add Credential**
   - Type: **HTTP Header Auth**
   - Name: `Groq API`
   - Header: `Authorization`
   - Value: `Bearer YOUR_GROQ_API_KEY`

4. **Activate Workflows** and note the webhook URLs

### Step 5: Configure App

Update `lib/config/constants.dart` with your webhook URL:

```dart
static const String webhookUrl = 'https://your-n8n-instance.com/webhook/medexplain-analyze';
```

### Step 6: Run the App

```bash
# Android
flutter run

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Web
flutter run -d chrome

# Linux
flutter run -d linux
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Windows
flutter build windows --release

# Web
flutter build web --release
```

---

## ⚙️ Configuration

### Environment Variables

Create a `.env` file (not committed to git):

```env
GROQ_API_KEY=your_groq_api_key
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/medexplain
FIREBASE_PROJECT_ID=your_project_id
```

### App Configuration

Key configuration files:
- `lib/config/constants.dart` - API endpoints & app constants
- `lib/config/theme.dart` - Material 3 theming
- `firebase.json` - Firebase hosting configuration

---

## 📖 Usage

### Analyzing a Medical Report

1. **Open the app** and sign in (optional)
2. **Choose input method**:
   - 📷 **Scan** - Use camera to capture document
   - 📁 **Upload** - Select PDF or image file
   - 📝 **Paste** - Enter text directly
3. **Select mode**:
   - 👤 **Patient** - Simple, easy-to-understand explanations
   - 👨‍⚕️ **Clinician** - Detailed clinical summary
4. **View results** with findings, explanations, and citations
5. **Ask follow-up questions** using the RAG chat feature

---

## 📡 API Documentation

### Webhook Endpoint

```
POST /webhook/medexplain-analyze
Content-Type: application/json
```

### Request Format

```json
{
  "mode": "patient",
  "language": "en",
  "report_text": "CBC Results: WBC 7.5, RBC 4.8, Hemoglobin 14.2...",
  "chat_mode": false
}
```

### Response Format

```json
{
  "status": "success",
  "red_flag": false,
  "patient_view": {
    "summary": "Your blood test results are within normal ranges...",
    "possible_meaning": [
      "Your white blood cell count is normal",
      "Hemoglobin levels indicate healthy oxygen transport"
    ],
    "questions_for_doctor": [
      "How often should I repeat this test?",
      "Are there any lifestyle changes you recommend?"
    ]
  },
  "clinician_view": {
    "findings": [
      "CBC within normal limits",
      "No evidence of anemia or infection"
    ],
    "critical_values": [],
    "considerations": [
      "Consider annual follow-up CBC"
    ]
  },
  "citations": [
    "RSNA - Radiological Society of North America",
    "NIH - National Institutes of Health"
  ],
  "disclaimer": "This analysis is for informational purposes only..."
}
```

### RAG Chat Mode

```json
{
  "chat_mode": true,
  "question": "What does my hemoglobin level mean?",
  "report_context": "Previous report text..."
}
```

---

## 🔒 Privacy & Security

### Automatic PII Redaction

All personally identifiable information is automatically redacted before AI processing:

| Data Type | Pattern | Replacement |
|-----------|---------|-------------|
| Names | Mr./Mrs./Dr. + Name | `[NAME REDACTED]` |
| MRN | Medical Record Numbers | `[MRN REDACTED]` |
| Dates | MM/DD/YYYY, DD-MM-YYYY | `[DATE REDACTED]` |
| Phone | XXX-XXX-XXXX | `[PHONE REDACTED]` |
| SSN | XXX-XX-XXXX | `[SSN REDACTED]` |
| Email | email@domain.com | `[EMAIL REDACTED]` |

### Security Features

- 🔐 **No data persistence** - Reports processed in memory only
- 🔒 **HTTPS everywhere** - All API calls encrypted
- 🛡️ **Firebase Auth** - Secure authentication
- 📝 **Audit logging** - Track all access (optional)
- 🚫 **No third-party tracking** - Zero analytics trackers

---

## ⚠️ Medical Safety Disclaimer

> **⚠️ IMPORTANT**: This application is for **informational purposes only** and does **NOT** provide medical diagnosis, treatment recommendations, or clinical advice.

### Safety Features Built-In

| Feature | Description |
|---------|-------------|
| 🚫 **No Diagnosis** | Never provides diagnostic conclusions |
| 💊 **No Treatment** | Never recommends medications or treatments |
| 🔒 **PII Redaction** | Automatically removes personal identifiers |
| 🚨 **Red-Flag Alerts** | Highlights critical findings requiring urgent attention |
| 📚 **Public Sources** | Citations from RSNA, CDC, NIH guidelines only |
| ⚠️ **Disclaimers** | Medical disclaimers prominently displayed |
| 🏥 **HIPAA-Conscious** | No data storage, memory-only processing |

### Red-Flag Keywords Detected

The system automatically flags reports containing:

```
• malignant, cancer, tumor, mass
• critical, urgent, emergency, stat
• stroke, heart attack, myocardial infarction
• severe, life-threatening, acute
• sepsis, hemorrhage, embolism, aneurysm
```

---

## 📁 Project Structure

```
medexplain_ai/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # App widget & routing
│   ├── config/
│   │   ├── theme.dart               # Material 3 medical theme
│   │   └── constants.dart           # API endpoints & disclaimers
│   ├── models/
│   │   ├── report_request.dart      # Request model
│   │   ├── analysis_response.dart   # Response model
│   │   ├── patient_view.dart        # Patient-facing data
│   │   └── clinician_view.dart      # Clinician-facing data
│   ├── providers/
│   │   ├── settings_provider.dart   # User preferences
│   │   ├── analysis_provider.dart   # API state management
│   │   └── theme_provider.dart      # Theme state
│   ├── services/
│   │   ├── api_service.dart         # n8n webhook client
│   │   └── file_service.dart        # File upload handler
│   ├── screens/
│   │   ├── splash_screen.dart       # Disclaimer screen
│   │   ├── home_screen.dart         # Main interface
│   │   ├── processing_screen.dart   # Loading state
│   │   └── results_screen.dart      # Analysis display
│   └── widgets/
│       ├── disclaimer_footer.dart   # Medical disclaimer
│       ├── mode_selector.dart       # Patient/Clinician toggle
│       ├── finding_card.dart        # Result cards
│       └── red_flag_banner.dart     # Critical alert banner
├── assets/
│   ├── images/                      # App images
│   └── icons/                       # Custom icons
├── android/                         # Android platform code
├── ios/                             # iOS platform code
├── web/                             # Web platform code
├── windows/                         # Windows platform code
├── macos/                           # macOS platform code
├── linux/                           # Linux platform code
├── test/                            # Unit & widget tests
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 🚀 Deployment

### n8n Hosting Options

| Platform | Pros | Pricing |
|----------|------|---------|
| **Railway.app** | Easy setup, auto-scaling | Free tier available |
| **Render.com** | Docker support, free tier | Free / $7/mo |
| **DigitalOcean** | Full control, reliable | $5/mo+ |
| **Self-hosted** | Maximum privacy | VPS cost |

### Flutter App Distribution

| Platform | Distribution Method |
|----------|---------------------|
| 🤖 **Android** | Google Play Store / APK sideload |
| 🍎 **iOS** | App Store / TestFlight |
| 🪟 **Windows** | Microsoft Store / MSIX / EXE |
| 🍏 **macOS** | App Store / DMG |
| 🐧 **Linux** | Snap Store / AppImage |
| 🌐 **Web** | Firebase Hosting / Vercel / Netlify |

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

### Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- ✅ Maintain medical safety standards
- ✅ Preserve privacy compliance
- ✅ Use non-diagnostic language
- ✅ Ensure all tests pass
- ✅ Follow Flutter best practices
- ✅ Document new features

### Code Style

```bash
# Format before committing
dart format lib/ test/

# Ensure no analysis issues
flutter analyze
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important Legal Notice**: This software is provided "AS IS" without warranty of any kind. It is **NOT** intended for clinical decision-making or as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider.

---

## 👨‍💻 Author

**Subeshan707**

- GitHub: [@Subeshan707](https://github.com/Subeshan707)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - Beautiful cross-platform framework
- [Groq](https://groq.com) - Lightning-fast AI inference
- [n8n](https://n8n.io) - Powerful workflow automation
- [Firebase](https://firebase.google.com) - Backend services
- [Google ML Kit](https://developers.google.com/ml-kit) - On-device ML

---

## 📞 Support

- 📧 **Email**: [Open an issue](https://github.com/Subeshan707/medexplain_ai/issues)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/Subeshan707/medexplain_ai/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Subeshan707/medexplain_ai/discussions)

---

<div align="center">

### Built with ❤️ for safer medical understanding

*Remember: This app explains reports, it doesn't diagnose.*
*Always consult your healthcare provider for medical advice.*

---

**⭐ Star this repo if you find it helpful!**

</div>
