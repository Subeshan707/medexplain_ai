# MedExplain AI - Safety & Compliance Guide

## ⚕️ Medical Disclaimer Requirements

### Primary Disclaimer Text

```
This application is for informational purposes only and does NOT constitute 
medical advice, diagnosis, or treatment. Always consult with a qualified 
healthcare provider for medical decisions.
```

### Where Disclaimers Must Appear

✅ **Required Locations:**
1. Splash screen (3-second display minimum)
2. Sticky footer on ALL screens
3. Results screen (above analysis)
4. App store descriptions
5. API responses (every response)
6. Marketing materials
7. Terms of Service

### Language Variants

When supporting multiple languages, disclaimer translation must be:
- Medically accurate
- Legally reviewed
- Culturally appropriate

## 🔒 Privacy & HIPAA Compliance

### Is This App HIPAA-Covered?

**Current Status**: **NO**

The app does NOT:
- Store patient data
- Maintain electronic health records
- Bill insurance
- Operate as a healthcare provider

**However**, if you plan to:
- Integrate with EHR systems
- Store reports long-term
- Process billing information
- Act as a covered entity

Then you **MUST**:
1. Sign Business Associate Agreements (BAAs)
2. Enable end-to-end encryption
3. Implement audit logging
4. Conduct HIPAA risk assessments

### PII Redaction

#### Implemented Protections

The n8n workflow automatically redacts:
- **Names**: Titles (Mr., Mrs., Dr.) + full names
- **MRN**: Medical Record Numbers
- **Dates**: Multiple formats (MM/DD/YYYY, DD-MM-YYYY)
- **Phone**: US format (XXX-XXX-XXXX)
- **SSN**: XXX-XX-XXXX format

#### Limitations

**NOT DETECTED** (requires NER/advanced NLP):
- Nicknames, informal names
- Addresses (street, city)
- Email addresses
- Unusual date formats
- International phone numbers

#### Recommendation

For production use with real PHI:
- Implement advanced NER (spaCy, AWS Comprehend Medical)
- User consent for data processing
- Explicit "De-identified Report" label

## 🚫 Non-Diagnostic Language

### Prohibited Terms

The following phrases **MUST NOT** appear in responses:

❌ "You have [disease]"
❌ "You are diagnosed with"
❌ "Take this medication"
❌ "Stop taking [drug]"
❌ "You should [treatment]"
❌ "Recommended treatment is"
❌ "This means you have"
❌ "You need to [clinical action]"

### Approved Language

✅ "Your report shows..."
✅ "These findings may indicate..."
✅ "Consult your doctor about..."
✅ "Questions to ask your healthcare provider:"
✅ "Possible interpretations include..."
✅ "Your doctor may consider..."

### System Prompt Enforcement

The Groq API system prompt includes:

```
CRITICAL RULES:
1. NEVER provide diagnosis or treatment recommendations
2. Use ONLY public medical guidelines (RSNA, CDC, NIH)
3. Explain findings faithfully from the report
```

**Safety Filter** (Post-LLM):
- Scans all responses for prohibited phrases
- Flags violations for review
- Adds stronger disclaimers if detected

## 📚 Citation Requirements

### Approved Sources

Responses should cite **ONLY** public, trusted medical organizations:

✅ **Approved**:
- RSNA (Radiology Society of North America)
- CDC (Centers for Disease Control)
- NIH (National Institutes of Health)
- WHO (World Health Organization)
- Mayo Clinic
- Johns Hopkins Medicine
- Cleveland Clinic
- American Cancer Society

❌ **NOT Approved**:
- Wikipedia
- WebMD, Healthline (patient education sites)
- Pharmaceutical company sites
- Individual blogs or YouTube
- Social media

### Citation Format

```json
{
  "citations": [
    "RSNA - Imaging Guidelines (rsna.org/practice-tools)",
    "NIH - MedlinePlus Medical Encyclopedia (medlineplus.gov)",
    "CDC - Health Information (cdc.gov/health)"
  ]
}
```

## 🚨 Red-Flag Detection

### Critical Keywords

The following terms automatically trigger red-flag warnings:

**Oncology**:
- Malignant
- Cancer
- Tumor
- Metastasis
- Carcinoma

**Cardiovascular**:
- Heart attack
- Myocardial infarction
- Stroke
- Embolism
- Aneurysm

**Emergency**:
- Critical
- Urgent
- Emergency
- Life-threatening
- Severe
- Acute

**Infectious**:
- Sepsis
- Septic shock

### Red-Flag Response

When detected:
1. Set `red_flag: true` in API response
2. Display prominent banner in Flutter UI
3. Add urgent language: "Please discuss with your healthcare provider urgently"
4. Escalate in clinician view

### False Positives

To minimize false alarms:
- Use context-aware detection (future enhancement)
- Allow "malignant" in historical context ("no malignant findings")
- Implement severity scoring

## 📱 App Store Compliance

### Google Play Store

**Required Disclosures**:
1. App Description:
   - Clear disclaimer in first paragraph
   - Not for diagnosis or treatment
   - No emergency use

2. Privacy Policy:
   - No data collection statement
   - Third-party API usage (n8n, Groq)
   - User data handling

3. Content Rating:
   - Select "Medical" category
   - Appropriate age rating

4. Permissions:
   - Justify file upload permission
   - Internet access for API calls

### Apple App Store

Additional requirements:
1. HealthKit Integration: NOT APPLICABLE (we don't use it)
2. Research Consent: NOT APPLICABLE
3. Medical Disclaimer: **REQUIRED** in app description

### Desktop Distribution

- Include LICENSE file
- README with disclaimer
- Terms of Service (optional but recommended)

## 🧪 Validation & Testing

### Required Test Cases

#### Medical Safety Tests

1. **Input**: Report with "malignant tumor"
   - **Expected**: Red-flag banner displayed
   - **Expected**: Non-diagnostic language in response

2. **Input**: Report with critical lab values
   - **Expected**: `critical_values` array populated
   - **Expected**: Clinician mode highlights values

3. **Input**: Report with PII (name, MRN)
   - **Expected**: PII redacted before AI processing
   - **Expected**: "[NAME REDACTED]" in logs

#### Error Handling Tests

1. **Invalid Report**: Empty text
   - **Expected**: User-friendly error message
   
2. **Network Failure**: Disconnect during analysis
   - **Expected**: Retry dialog shown

3. **Malformed LLM Response**: Invalid JSON
   - **Expected**: Graceful error, not app crash

### Manual Review Process

Before each release:
1. Test with 10+ real medical reports
2. Review all LLM outputs for prohibited language
3. Verify red-flag detection on critical findings
4. Confirm disclaimers present on all screens
5. Legal team review (recommended)

## 📄 Legal Considerations

### Liability Limitations

**Recommended Terms of Service clauses**:

> "This software is provided 'AS IS' without warranty of any kind. The creators 
> are not liable for any medical decisions made based on this application."

> "This application is not intended for emergency use. In case of medical 
> emergency, call 911 or your local emergency number."

### User Consent

Before first use, require user to:
1. Read and accept Terms of Service
2. Acknowledge medical disclaimer
3. Confirm understanding that app is not diagnostic

### Data Retention Policy

**Current**: 
- No data stored
- Ephemeral processing only
- Session cleared on app close

**If you implement history**:
- User controls (delete analysis)
- Encryption at rest
- Maximum retention period (e.g., 30 days)

## 🌍 International Compliance

### GDPR (European Union)

If serving EU users:
1. **Right to Access**: Provide data export (JSON)
2. **Right to Deletion**: Clear analysis on request
3. **Consent**: Explicit opt-in for data processing
4. **Data Protection Officer**: Required if > 250 employees

### Other Jurisdictions

- **UK**: Similar to GDPR
- **Canada**: PIPEDA compliance
- **Australia**: Privacy Act 1988
- **India**: Personal Data Protection Bill

**Recommendation**: Consult local legal counsel before international deployment.

## ✅ Pre-Launch Checklist

### Development

- [ ] All disclaimers implemented
- [ ] PII redaction tested
- [ ] Red-flag detection validated
- [ ] Prohibited phrases filtered
- [ ] Citation sources verified
- [ ] Error handling tested

### Legal

- [ ] Terms of Service drafted
- [ ] Privacy Policy created
- [ ] Medical disclaimer reviewed by legal counsel
- [ ] Liability limitations documented
- [ ] Insurance coverage obtained (E&O recommended)

### Deployment

- [ ] HTTPS enforced
- [ ] API keys secured
- [ ] Rate limiting implemented
- [ ] Monitoring enabled
- [ ] Incident response plan documented

### App Stores

- [ ] Disclaimer in app description
- [ ] Content rating appropriate
- [ ] Privacy policy public URL
- [ ] Screenshots show disclaimers
- [ ] Age restriction set (if applicable)

## 📞 Emergency Use Warning

**Never use this app for**:
- Chest pain
- Difficulty breathing
- Severe bleeding
- Loss of consciousness
- Stroke symptoms
- Suspected heart attack

**Always include**:
> "⚠️ NOT FOR EMERGENCIES. Call 911 if you are experiencing a medical emergency."

## 📊 Recommended Audit Logging

For production deployments, log:
- Timestamp of analysis request
- Mode selected (patient/clinician)
- Report length (chars)
- Red-flag detected (yes/no)
- Response time
- Error occurred (yes/no)

**DO NOT LOG**:
- Report content
- Patient names
- Any PHI/PII
- Personal identifiers

## 👥 User Support

### Frequently Asked Questions

**Q: Can this app diagnose my condition?**
A: No. This app explains your existing medical report. Only a licensed healthcare provider can diagnose medical conditions.

**Q: Should I change my treatment based on this app?**
A: No. Never change your treatment without consulting your doctor.

**Q: What if I disagree with the explanation?**
A: Consult your healthcare provider. They have access to your full medical history.

**Q: Is my data secure?**
A: We don't store your report. Analysis is processed in real-time and discarded.

---

**Compliance Version**: 1.0
**Last Reviewed**: 2026-01-16
**Next Review**: 2026-04-16 (quarterly)

**Legal Notice**: This document provides guidelines but does NOT constitute legal advice. Consult with healthcare and legal professionals before deploying this application.
