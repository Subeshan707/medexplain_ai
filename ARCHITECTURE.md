# MedExplain AI - Architecture Documentation

## System Overview

MedExplain AI is a three-tier healthcare application designed for safe, compliant medical report explanation.

## Architecture Layers

### 1. Frontend Layer (Flutter)

**Purpose**: Cross-platform user interface for patients and clinicians

**Components**:
- Presentation (Screens)
- State Management (Riverpod)
- Business Logic (Providers)
- Data Models
- Services (API, File)

**Key Design Decisions**:
- **Riverpod** for predictable state management
- **Material 3** for modern, accessible UI
- **JSON Serialization** for type-safe API communication
- **SharedPreferences** for persistent settings

### 2. Backend Layer (n8n)

**Purpose**: Secure workflow automation and AI orchestration

**Pipeline**:
```
Webhook → Privacy → Normalization → AI → Parsing → Red-Flag → Safety → Response
```

**Key Nodes**:
1. **Webhook Trigger**: Receives POST requests from Flutter
2. **Privacy Check**: PII redaction (names, MRN, dates, SSN)
3. **Text Normalization**: Clean text, standardize abbreviations
4. **Groq API Call**: LLM inference with medical safety prompts
5. **Parse Response**: Extract and validate JSON from LLM
6. **Red-Flag Detection**: Pattern matching for critical findings
7. **Medical Safety Filter**: Ensure non-diagnostic language
8. **Response Builder**: Structure data for Flutter models
9. **Webhook Response**: Return JSON to client

### 3. AI Layer (Groq)

**Model**: LLaMA 3.1 70B Versatile

**Configuration**:
- Temperature: 0.2 (low for medical accuracy)
- Max tokens: 2048
- Streaming: Disabled

**System Prompt Design**:
- Enforces non-diagnostic language
- Mandates public source citations
- Dual-mode output (patient + clinician)
- JSON-only responses

## Data Flow

### Request Flow

```
User Input (Flutter)
    ↓
Report Request Model
    ↓
HTTP POST (JSON)
    ↓
n8n Webhook Trigger
    ↓
Privacy + Normalization
    ↓
Groq API (LLM)
    ↓
JSON Parsing + Validation
    ↓
Red-Flag Detection
    ↓
Safety Filtering
    ↓
Structured Response
    ↓
HTTP Response (JSON)
    ↓
Analysis Response Model
    ↓
UI Rendering (Flutter)
```

### Data Models

#### Request (Flutter → n8n)

```dart
class ReportRequest {
  String mode;           // "patient" | "clinician"
  String language;       // "en"
  String reportText;     // Medical report content
}
```

#### Response (n8n → Flutter)

```dart
class AnalysisResponse {
  String status;               // "success" | "error"
  bool redFlag;                // Critical findings detected
  PatientView patientView;     // Simple explanations
  ClinicianView clinicianView; // Clinical analysis
  List<String> citations;      // Source references
  String disclaimer;           // Medical disclaimer
}
```

## Security Architecture

### Privacy Measures

1. **Client-Side Processing**
   - No persistent storage
   - Ephemeral analysis only
   - User controls all data

2. **PII Redaction**
   - Pattern-based detection in n8n
   - Automatic redaction before AI processing
   - Types: Names, MRN, dates, phone, SSN

3. **Network Security**
   - HTTPS required for production
   - No API keys in Flutter app
   - Credentials managed in n8n only

### Medical Safety

1. **Prompt Engineering**
   - Explicit prohibition of diagnosis/treatment
   - Citation requirements
   - Disclaimer enforcement

2. **Response Filtering**
   - Post-LLM safety checks
   - Prohibited phrase detection
   - Fallback disclaimers

3. **Red-Flag System**
   - Keyword pattern matching
   - Critical value detection
   - Urgent warning display

## State Management (Riverpod)

### Providers

```dart
// Settings (persisted)
SettingsProvider
  ├─ selectedMode: String
  ├─ selectedLanguage: String
  └─ isDarkMode: bool

// Analysis (transient)
AnalysisProvider
  ├─ isLoading: bool
  ├─ response: AnalysisResponse?
  ├─ error: String?
  └─ reportText: String?

// Theme (derived)
ThemeProvider (watches SettingsProvider.isDarkMode)
```

### State Flow

```
User Action
    ↓
Provider Notifier Method
    ↓
State Update (copyWith)
    ↓
ConsumerWidget Rebuild
    ↓
UI Reflects New State
```

## Error Handling

### Levels

1. **Network Errors**
   - Connection timeout (60s)
   - DNS resolution failures
   - SSL certificate issues
   → Retry mechanism with user notification

2. **API Errors**
   - 400: Invalid request → User-friendly message
   - 500: Server error → Retry suggestion
   - Timeout → Show retry dialog

3. **Validation Errors**
   - Empty report text
   - Oversized reports (>5MB)
   - Invalid file types
   → Inline error messages

4. **LLM Errors**
   - Invalid JSON response
   - Missing required fields
   - Prohibited content detected
   → Graceful degradation with disclaimers

## Performance Considerations

### Frontend

- **Lazy Loading**: Screens loaded on demand
- **Memoization**: Expensive computations cached
- **Efficient Rebuilds**: ConsumerWidget selective listening
- **Image Optimization**: Asset compression

### Backend

- **Timeout Management**: 60s max for API calls
- **Function Node Efficiency**: Minimal regex operations
- **Caching**: n8n workflow static data cached
- **Groq Model**: Fast inference (<5s typical)

## Scalability

### Current Capacity

- n8n: ~100 concurrent requests (depends on hosting)
- Groq: API rate limits (check plan)
- Flutter: Unlimited clients (stateless backend)

### Scaling Strategies

1. **Horizontal Scaling**
   - Multiple n8n instances behind load balancer
   - Groq API key rotation
   - CDN for static assets

2. **Caching**
   - Implement Redis for common reports
   - Cache normalized text
   - Pre-computed red-flag patterns

3. **Async Processing**
   - Queue-based architecture (RabbitMQ/Redis)
   - Webhook callback for results
   - Push notifications

## Deployment Architecture

### Development

```
Flutter (localhost)
    ↓ HTTP
n8n (localhost:5678)
    ↓ HTTPS
Groq API (cloud)
```

### Production

```
Flutter App (Android/Desktop)
    ↓ HTTPS
Load Balancer (Nginx/CloudFlare)
    ↓
n8n (Railway/Render/VPS)
    ↓ HTTPS
Groq API (cloud)
```

## Monitoring & Observability

### Recommended Tools

- **n8n**: Built-in execution logs
- **Sentry**: Flutter error tracking
- **Groq Console**: Token usage, latency
- **Google Analytics**: App usage (anonymized)

### Key Metrics

- API response time (P50, P95, P99)
- Error rate (%)
- Red-flag detection rate
- User mode preference (Patient vs Clinician)

## Compliance Notes

### HIPAA Considerations

- **Covered Entity**: This app is NOT
- **De-identification**: PII redaction implemented
- **BAA Required**: If processing PHI at scale
- **Audit Logs**: Enable in n8n for production

### Recommended Disclaimers

All screens must display:
> "This application is for informational purposes only and does NOT constitute medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider."

## Future Enhancements

1. **Multi-language Support**
   - Spanish, Hindi, Mandarin
   - Translation in n8n layer

2. **PDF Parsing**
   - Native PDF text extraction
   - OCR for scanned reports

3. **Offline Mode**
   - Cache previous analyses
   - Read-only access

4. **Voice Input**
   - Speech-to-text for reports
   - Text-to-speech for results

5. **Analytics Dashboard**
   - Usage statistics
   - Red-flag trends
   - Performance metrics

---

**Document Version**: 1.0
**Last Updated**: 2026-01-16
**Author**: MedExplain AI Team
