#  MedExplain AI

> **Safe, AI-powered medical report explanations for patients and clinicians**

![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Web-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.29.2-02569B?logo=flutter)
![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-FF6D5A?logo=n8n)
![Groq](https://img.shields.io/badge/AI-Groq%20LLaMA%203.3-00D4AA)
![License](https://img.shields.io/badge/License-MIT-green)

<p align="center">
  <img src="assets/images/medexplain_banner.png" alt="MedExplain AI Banner" width="800">
</p>

##  Overview

MedExplain AI is a production-grade medical report explanation system that leverages AI to help patients and clinicians understand radiology reports, lab results, and medical documents safely. Built with Flutter for cross-platform support and powered by n8n workflows with Groq's LLaMA 3.3 70B model.

###  Key Features

| Feature | Description |
|---------|-------------|
|  **Privacy-First** | Automatic PII redaction (names, MRN, dates, SSN) |
|  **Red-Flag Detection** | Automatic alerts for critical findings |
|  **Multi-Platform** | Android, iOS, Windows, macOS, Linux, Web |
|  **Dual Mode** | Patient-friendly & Clinician-focused explanations |
|  **Citation-Backed** | References from RSNA, CDC, NIH |
|  **Medical Safety** | No diagnosis, no treatment recommendations |

---

##  Patient Mode

<img align="right" src="assets/screenshots/patient_mode.png" width="300">

-  Simple 8th-grade reading level
-  Reassuring, empathetic tone
-  What findings **may** indicate (non-diagnostic)
-  Questions to ask your doctor
-  Clear medical disclaimers

<br clear="right"/>

---

##  Clinician Mode

<img align="right" src="assets/screenshots/clinician_mode.png" width="300">

-  Bullet-point clinical summary
-  Key findings highlighted
-  Critical values flagged
-  Non-prescriptive considerations
-  Differential diagnosis prompts

<br clear="right"/>

---

##  Medical Safety Disclaimer

> **IMPORTANT**: This application is for **informational purposes only** and does **NOT** provide medical diagnosis, treatment recommendations, or clinical advice.

### Safety Features Built-In:

-  **No Diagnosis**: Never provides diagnostic conclusions
-  **No Treatment**: Never recommends medications or treatments
-  **PII Redaction**: Automatically removes personal identifiers
-  **Red-Flag Alerts**: Highlights critical findings requiring urgent attention
-  **Public Sources Only**: Citations from RSNA, CDC, NIH guidelines
-  **Prominent Disclaimers**: Medical disclaimers on every screen
-  **HIPAA-Conscious Design**: No data storage, client-side processing

---

##  System Architecture

\\\

                         USER DEVICE                              
     
                      Flutter App                               
     Cross-platform (Android/iOS/Windows/macOS/Linux/Web)     
     Material Design 3 UI                                      
     Offline-capable report viewing                            
     

                               HTTPS POST
                              

                      n8n WORKFLOW ENGINE                         
               
   Privacy    Text     AI Call   Red-Flag        
   Check       Normalize   (Groq)      Detection       
               
                                                                 
                                        
   Safety    Response                               
   Filter      Builder                                        
                                          

                               API Response
                              

                        GROQ API                                  
   Model: LLaMA 3.3 70B Versatile                               
   Temperature: 0.2 (deterministic)                              
   Max Tokens: 2048                                              
   Medical-tuned system prompt                                   

\\\

---

##  Project Structure

\\\
medexplain_ai/
 lib/
    main.dart                    # Entry point
    app.dart                     # App widget & routing
    config/
       theme.dart               # Material 3 medical theme
       constants.dart           # API endpoints & disclaimers
    models/
       report_request.dart      # Request model
       analysis_response.dart   # Response model
       patient_view.dart        # Patient-facing data
       clinician_view.dart      # Clinician-facing data
    providers/
       settings_provider.dart   # User preferences
       analysis_provider.dart   # API state management
       theme_provider.dart      # Theme state
    services/
       api_service.dart         # n8n webhook client
       file_service.dart        # File upload handler
    screens/
       splash_screen.dart       # Disclaimer screen
       home_screen.dart         # Main interface
       processing_screen.dart   # Loading state
       results_screen.dart      # Analysis display
    widgets/
        disclaimer_footer.dart   # Medical disclaimer
        mode_selector.dart       # Patient/Clinician toggle
        finding_card.dart        # Result cards
        red_flag_banner.dart     # Critical alert banner
 n8n_workflows/
    rag_chatbot.json             # Main RAG workflow
    report_analyze.json          # Report analysis workflow
 assets/
    images/
    icons/
    animations/
 pubspec.yaml
 README.md
\\\

---

##  Quick Start

### Prerequisites

- **Flutter SDK** 3.29.2 or later
- **n8n** (self-hosted or cloud)
- **Groq API Key** (free tier at [console.groq.com](https://console.groq.com))

### 1. Clone Repository

\\\ash
git clone https://github.com/YOUR_USERNAME/medexplain-ai.git
cd medexplain-ai
\\\

### 2. Install Dependencies

\\\ash
flutter pub get
\\\

### 3. Configure Webhook URL

Update \lib/config/constants.dart\:

\\\dart
static const String webhookUrl = 'https://your-n8n-instance.com/webhook/medexplain-analyze';
\\\

### 4. Setup n8n Workflow

1. **Install n8n**:
   \\\ash
   npm install -g n8n
   n8n start
   \\\

2. **Import Workflow**:
   - Open n8n (http://localhost:5678)
   - Go to **Workflows**  **Import from File**
   - Select \
8n_workflows/rag_chatbot.json\

3. **Configure Groq Credentials**:
   - Go to **Credentials**  **Add Credential**
   - Type: **HTTP Header Auth**
   - Header: \Authorization\
   - Value: \Bearer YOUR_GROQ_API_KEY\

4. **Activate Workflow**

### 5. Run the App

\\\ash
# Android
flutter run

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Web
flutter run -d chrome

# Build Release APK
flutter build apk --release
\\\

---

##  n8n Workflow Details

### Webhook Endpoint
\\\
POST /webhook/medexplain-analyze
\\\

### Request Format

\\\json
{
  "mode": "patient",
  "language": "en",
  "report_text": "Your medical report text here...",
  "chat_mode": false
}
\\\

### Response Format

\\\json
{
  "status": "success",
  "red_flag": false,
  "patient_view": {
    "summary": "Your test results show normal values...",
    "possible_meaning": ["Finding 1", "Finding 2"],
    "questions_for_doctor": ["Question 1", "Question 2"]
  },
  "clinician_view": {
    "findings": ["CBC within normal limits", "..."],
    "critical_values": [],
    "considerations": ["Consider follow-up in 6 months"]
  },
  "citations": [
    "RSNA - Radiological Society of North America",
    "NIH - National Institutes of Health"
  ],
  "disclaimer": "This is for informational purposes only..."
}
\\\

### RAG Chat Mode

\\\json
{
  "chat_mode": true,
  "question": "What does my hemoglobin level mean?",
  "report_context": "Previous report text..."
}
\\\

---

##  Privacy & Compliance

### Automatic PII Redaction

| Data Type | Pattern | Example |
|-----------|---------|---------|
| Names | Mr./Mrs./Dr. + Name | \[NAME REDACTED]\ |
| MRN | Medical Record Numbers | \[MRN REDACTED]\ |
| Dates | MM/DD/YYYY formats | \[DATE REDACTED]\ |
| Phone | XXX-XXX-XXXX | \[PHONE REDACTED]\ |
| SSN | XXX-XX-XXXX | \[SSN REDACTED]\ |

### Red-Flag Keywords Detected

- \malignant\, \cancer\, \	umor\
- \critical\, \urgent\, \emergency\
- \stroke\, \heart attack\, \myocardial infarction\
- \severe\, \life-threatening\, \cute\
- \sepsis\, \hemorrhage\, \embolism\, \neurysm\

---

##  Screenshots

<p align="center">
  <img src="assets/screenshots/home.png" width="200" alt="Home Screen">
  <img src="assets/screenshots/upload.png" width="200" alt="Upload">
  <img src="assets/screenshots/results.png" width="200" alt="Results">
  <img src="assets/screenshots/chat.png" width="200" alt="Chat">
</p>

---

##  Testing

\\\ash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
\\\

---

##  Deployment

### n8n Hosting Options

| Platform | Pros | Setup |
|----------|------|-------|
| **Railway.app** | Easy, auto-scaling | One-click deploy |
| **Render.com** | Free tier available | Docker support |
| **DigitalOcean** | Full control | App Platform |
| **Self-hosted** | Maximum privacy | VPS + Docker |

### Flutter App Distribution

- **Android**: Google Play Store / APK sideload
- **iOS**: App Store / TestFlight
- **Windows**: MSIX / EXE installer
- **macOS**: App Store / DMG
- **Web**: Firebase Hosting / Vercel

---

##  Contributing

Contributions are welcome! Please ensure:

1.  Medical safety standards maintained
2.  Privacy compliance preserved
3.  Non-diagnostic language used
4.  All tests passing
5.  Code follows Flutter best practices

---

##  License

MIT License - see [LICENSE](LICENSE) file.

**Important**: This software is provided "AS IS" without warranty. It is **NOT** intended for clinical decision-making or as a substitute for professional medical advice.

---

##  Support

-  Email: your-email@example.com
-  Issues: [GitHub Issues](https://github.com/YOUR_USERNAME/medexplain-ai/issues)
-  Discussions: [GitHub Discussions](https://github.com/YOUR_USERNAME/medexplain-ai/discussions)

---

<p align="center">
  <strong>Built with  for safer medical understanding</strong>
  <br>
  <em>Remember: This app explains reports, it doesn't diagnose. Always consult your healthcare provider.</em>
</p>
